//
//  GaoDisplayStyle.m
//  JsoMediaCaptureViewController
//
//  Created by Gikki Ares on 2020/9/23.
//  Copyright © 2020 vgemv. All rights reserved.
//

#import "GaoDisplayStyle.h"

@implementation GaoDisplayStyle


/**
 默认的展示风格:
 有遮罩,透明度为0.5,点击取消;
 不自动消失.
 从右边出来
 到左边消失
 
 */
+ (GaoDisplayStyle *)defaulStyle {
	GaoDisplayStyle * style = [GaoDisplayStyle new];
	style.mb_isUseMask = YES;
	style.mf_maskAlpha = 0.5;
	style.mb_isMaskCancellable = YES;
	style.mf_displayTime = 0;
	style.displayPosition = GaoDisplayPositionCenter;
	style.displayAnimationType = GaoDisplayAnimationTypeMoveFromRight;
	style.undisplayAnimationType = GaoUndisplayAnimationTypeMoveToLeft;
	return style;
}

@end
