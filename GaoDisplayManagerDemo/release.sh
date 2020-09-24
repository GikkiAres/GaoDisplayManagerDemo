# 切换到当前脚本文件所在的目录,并将该目录的路径保存到变量中.
ROOT_DIR=`cd $(dirname $0); pwd -P`
# 读取VERSION文件中记录的版本号.
VERSION=$(cat VERSION)

echo $VERSION
exit
###
# BUILD
###
update_version(){
    buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$1") && \
    buildNumber=$(($buildNumber + 1))  && \
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber " "$1" && \
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION " "$1"
    return $?
}

echo "> Update Info.plist with VERSION($VERSION) ..."
PLIST1=`xcodebuild -project JSPlayerSDK.xcodeproj -target JSPlayerSDK -showBuildSettings|grep PRODUCT_SETTINGS_PATH |awk -F "=" '{print $2}'`
PLIST2=`xcodebuild -project JSPlayerSDK.xcodeproj -target JSPlayerSDKUI -showBuildSettings|grep PRODUCT_SETTINGS_PATH |awk -F "=" '{print $2}'`
update_version $PLIST1 &&
update_version $PLIST2
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST1)
echo "> Building $buildNumber..."
GCC_PREPROCESSOR_DEFINITIONS="INTERNAL_PLAYER_VERSION=$buildNumber"
xcodebuild clean -project JSPlayerSDK.xcodeproj -sdk iphoneos -target JSPlayerSDKUI |xcpretty && \
xcodebuild clean -project JSPlayerSDK.xcodeproj -sdk iphoneos -target JSPlayerSDK |xcpretty && \
xcodebuild -project JSPlayerSDK.xcodeproj -sdk iphoneos -target JSPlayerSDKUI |xcpretty 
xcodebuild -project JSPlayerSDK.xcodeproj -sdk iphoneos -target JSPlayerSDK GCC_PREPROCESSOR_DEFINITIONS=$GCC_PREPROCESSOR_DEFINITIONS |xcpretty && \
xcodebuild -project JSPlayerSDK.xcodeproj -sdk iphonesimulator -target JSPlayerSDK GCC_PREPROCESSOR_DEFINITIONS=$GCC_PREPROCESSOR_DEFINITIONS |xcpretty
ret=${PIPESTATUS[0]}; if [[ $ret -ne 0 ]]; then echo -e "\033[31mbuild failed, ret=$ret\033[0m"; exit $ret; fi

###
# PACK
###
echo "> Lipo create archs ..."
rm -rf release/JSPlayerSDK.framework && \
rm -rf release/JSPlayerSDKUI.bundle && \
cp -rf build/Release-iphoneos/JSPlayerSDK.framework release/ && \
cp -rf build/Release-iphoneos/JSPlayerSDKUI.bundle release/ && \
lipo -create \
    build/Release-iphoneos/JSPlayerSDK.framework/JSPlayerSDK \
    build/Release-iphonesimulator/JSPlayerSDK.framework/JSPlayerSDK \
    -output \
    release/JSPlayerSDK.framework/JSPlayerSDK

rm -rf release/JSPlayerSDKUI.bundle/JSPlayerSDKUI
/usr/libexec/PlistBuddy -c "Delete :CFBundleExecutable " "release/JSPlayerSDKUI.bundle/Info.plist"

ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi

###
# CHECK
###
ARCHS=$(lipo -archs release/JSPlayerSDK.framework/JSPlayerSDK)
echo "> Check archs ($ARCHS)..."
echo $ARCHS|grep armv7|grep arm64|grep x86_64|grep i386
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi


echo "> Check version string ($VERSION) ..."
grep $VERSION release/JSPlayerSDK.framework/Info.plist
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi

grep $VERSION release/JSPlayerSDKUI.bundle/Info.plist
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi 

###
# GIT push
###
echo "> Copying to GIT folder ..."
rm -rf release/Pods_release/JSPlayerSDK/SDK/*
cp -rf release/JSPlayerSDK.framework release/Pods_release/JSPlayerSDK/SDK/ && \
cp -rf release/JSPlayerSDKUI.bundle release/Pods_release/JSPlayerSDK/SDK/
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi


echo "> Update podspec version ..."
sed -E -i "" "s/^(.*s\.version.*=).*$/\1 \"$VERSION\"/" release/Pods_release/JSPlayerSDK/js_player_sdk.podspec
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi


cd release/Pods_release/JSPlayerSDK

echo "> Doing git works ..."
git add ./ && \
git commit -m "release.sh $VERSION" && \
git tag -a $VERSION -m "release.sh $VERSION" && \
git push origin $VERSION
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi

###
# PODS upload
###
echo "> Pods uploading ..."
pod trunk push js_player_sdk.podspec --verbose

    # 如果session过期，则执行
    # pod trunk register "16990471@qq.com" "ssddawei" 
    # 登陆
ret=$?; if [[ $ret -ne 0 ]]; then echo -e "\033[31mfailed, ret=$ret\033[0m"; exit $ret; fi
cd $ROOT_DIR

###
###
###

MSG='> ALL DONE !!!'
echo -e "\033[32m${MSG}\033[0m"
