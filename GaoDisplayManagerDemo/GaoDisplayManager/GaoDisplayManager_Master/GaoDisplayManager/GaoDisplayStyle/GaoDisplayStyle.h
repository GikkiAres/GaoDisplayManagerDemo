//
//  GaoDisplayStyle.h
//  JsoMediaCaptureViewController
//
//  Created by Gikki Ares on 2020/9/23.
//  Copyright © 2020 vgemv. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
	//typedef void(^maskBtnBlock)(void);
typedef NS_ENUM(NSUInteger, GaoDisplayPosition) {
	GaoDisplayPositionCenter,
	GaoDisplayPositionRight,
	GaoDisplayPositionLeft,
	GaoDisplayPositionBottom,
	GaoDisplayPositionTop
};

typedef NS_ENUM(NSUInteger, GaoDisplayAnimationType) {
		//没有动画
	GaoDisplayAnimationTypeNone,
		//从右滑动到左
	GaoDisplayAnimationTypeMoveFromRight,
		//从最底端滑上来
	GaoDisplayAnimationTypeMoveFromBottom
};

typedef NS_ENUM(NSUInteger, GaoUndisplayAnimationType) {
	GaoUndisplayAnimationTypeNone,
		//从当前位置移动到左边消失;
	GaoUndisplayAnimationTypeMoveToLeft,
		//从当前位置移动到右边消失;
	GaoUndisplayAnimationTypeMoveToRight,
		//滑到最底端;
	GaoUndisplayAnimationTypeMoveToBottom
};


@interface GaoDisplayStyle : NSObject

//是否增加遮罩
@property(nonatomic,assign) BOOL mb_isUseMask;

//遮罩的透明度.
@property(nonatomic,assign) CGFloat mf_maskAlpha;

//是否可以点击遮罩触发remove方法
@property(nonatomic,assign) BOOL mb_isMaskCancellable;

//展示的持续时间,如果设置该时间,超过该时间就会自动移除.
@property(nonatomic,assign) CGFloat mf_displayTime;

@property(nonatomic,assign) GaoDisplayPosition displayPosition;
@property(nonatomic,assign) GaoDisplayAnimationType displayAnimationType;
@property(nonatomic,assign) GaoUndisplayAnimationType undisplayAnimationType;



//@property(nonatomic,assign) CGFloat mb_maskCancellable;

+ (GaoDisplayStyle *)defaulStyle;

@end

NS_ASSUME_NONNULL_END
