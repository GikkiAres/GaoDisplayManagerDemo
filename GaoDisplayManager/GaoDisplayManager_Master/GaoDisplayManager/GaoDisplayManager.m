	//
	//  UIView+GaDisplay.m
	//  productLine
	//
	//  Created by GikkiAres on 2019/2/26.
	//  Copyright © 2019 base. All rights reserved.
	//

#import "GaoDisplayManager.h"
#import <objc/runtime.h>



@implementation UIView (GaDisplay)

static int kCompetionHanlder;
static int kDisplayStyle;

#pragma mark 1 Life Circle

#pragma mark 2 Basic Function
	//MaskBtn点击事件,如果触发了该事件,说明有MaskBtn,需要取消;
- (void)onMaskBtnClick {
	[self undisplay];
}


#pragma mark 3 Interface
- (void)displayInView:(UIView *)containerView withDisplayStyle:(GaoDisplayStyle *)style completionHandler:(void(^)(void))handler {
	
		//关联展示样式对象
	objc_setAssociatedObject(self, &kDisplayStyle,style, OBJC_ASSOCIATION_RETAIN);
		//关联取消的block
	if(handler){
		objc_setAssociatedObject(self, &kCompetionHanlder, handler, OBJC_ASSOCIATION_RETAIN);
	}
	
	//关联显示的时间
	if(style.mf_displayTime) {
		__weak typeof(self) weakSelf = self;
		[NSTimer scheduledTimerWithTimeInterval:style.mf_displayTime repeats:NO block:^(NSTimer * _Nonnull timer) {
			[weakSelf undisplay];
			[timer invalidate];
		}];
			//        objc_setAssociatedObject(self, &kDisplayInterval, cancelBlock, OBJC_ASSOCIATION_RETAIN);
	}
	UIView * parentView = nil;
	
	CGSize size = self.bounds.size;
		//    objc_setAssociatedObject(self, &akSize, @(size), OBJC_ASSOCIATION_RETAIN);
	
	if(style.mb_isUseMask) {
			//如果有遮罩的话,是加在遮罩上的;
			//        UIView * vMask = [[UIView alloc]initWithFrame:superview.bounds];
		UIButton * btnMask = [[UIButton alloc]initWithFrame:containerView.bounds];
		parentView = btnMask;
		
		[btnMask setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:style.mf_maskAlpha]];
		if(style.mb_isMaskCancellable) {
			[btnMask addTarget:self action:@selector(onMaskBtnClick) forControlEvents:UIControlEventTouchUpInside];
		}
			//关联block和btnMask;
		objc_setAssociatedObject(self, @selector(onMaskBtnClick), btnMask, OBJC_ASSOCIATION_RETAIN);
		
		[btnMask addSubview:self];
		[containerView addSubview:btnMask];
	}
	else {
			//不添加Mask
		parentView = containerView;
		[containerView addSubview:self];
	}
	
		//MARK: Step:计算displayView在superView的位置--targetFrame
	CGRect targetFrame = CGRectZero;
		//屏幕尺寸
	CGFloat f_screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat f_screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	switch (style.displayPosition) {
		case GaoDisplayPositionCenter: {
			CGFloat targetX = (parentView.bounds.size.width-self.bounds.size.width)/2;
			CGFloat targetY = (parentView.bounds.size.height-self.bounds.size.height)/2;
			targetFrame = CGRectMake(targetX, targetY, self.bounds.size.width, self.bounds.size.height);
			break;
		}
		case GaoDisplayPositionRight: {
				//displayView和parentView的右边对齐,垂直居中
			CGFloat xTarget = parentView.bounds.size.width - size.width;
			CGFloat yTarget = (parentView.bounds.size.height - size.height)/2;
			targetFrame = CGRectMake(xTarget, yTarget, size.width, size.height);
			
			break;
		}
		case GaoDisplayPositionLeft: {
			break;
		}
		case GaoDisplayPositionBottom: {
			
			CGFloat yTarget = parentView.bounds.size.height - size.height;
			targetFrame = CGRectMake(0, yTarget, size.width, size.height);
			break;
		}
		case GaoDisplayPositionTop: {
			CGFloat xTarget = (parentView.bounds.size.width-self.bounds.size.width)/2;
			
				//                CGFloat yTarget = parentView.bounds.size.height - size.height;
			targetFrame = CGRectMake(xTarget, 84, size.width, size.height);
			break;
		}
		default:{
			break;
		}
	}
	
	
	
		//MARK: Step:计算起始位置
	CGRect startFrame = CGRectZero;
	
	switch (style.displayAnimationType) {
		case GaoDisplayAnimationTypeNone:{
			startFrame = targetFrame;
			break;
		}
		case GaoDisplayAnimationTypeMoveFromRight:
				//从右边划过来 调整x为 screen.width;
			startFrame = targetFrame;
			startFrame.origin.x = f_screenWidth;
			
			break;
		case GaoDisplayAnimationTypeMoveFromBottom:{
			startFrame = targetFrame;
			startFrame.origin.y = f_screenHeight;
			break;
		}
		default:{
			break;
		}
	}
	
		//MARK: Step:执行动画
	self.frame = startFrame;
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.frame = targetFrame;
	} completion:^(BOOL finished) {
		
	}];
}


- (void)undisplay{
		//屏幕尺寸
	CGFloat f_screenWidth = [UIScreen mainScreen].bounds.size.width;
//	CGFloat f_screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	GaoDisplayStyle * style = objc_getAssociatedObject(self, &kDisplayStyle);
		//MARK: 1 计算结束的位置--finishFrame
	CGRect rc_currentFrame = self.frame;
	CGRect rc_finishFrame= rc_currentFrame;
	switch (style.undisplayAnimationType) {
		case GaoUndisplayAnimationTypeNone:{
			[self remove];
			break;
		}
		case GaoUndisplayAnimationTypeMoveToLeft:{
			//计算结束时的位置,-width
			rc_finishFrame.origin.x = -rc_currentFrame.size.width;
			[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.frame = rc_finishFrame;
			} completion:^(BOOL finished) {
				[self remove];
			}];
			break;
		}
		case GaoUndisplayAnimationTypeMoveToRight:{
			rc_finishFrame.origin.x = f_screenWidth;
			[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.frame = rc_finishFrame;
			} completion:^(BOOL finished) {
				[self remove];
			}];
			break;
		}
		case GaoUndisplayAnimationTypeMoveToBottom:{
			CGRect targetFrame = CGRectZero;
			CGFloat yTarget = self.superview.bounds.size.height;
			CGSize size = self.bounds.size;
			targetFrame = CGRectMake(0, yTarget, size.width, size.height);
			[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				self.frame = targetFrame;
			} completion:^(BOOL finished) {
				[self remove];
			}];
			break;
		}
			
		default:{
			break;
		}
	}
	
	
}

/**
 将displayView从父视图中移除,并释放关联资源.
 */
- (void)remove {
	UIButton *btnMask = objc_getAssociatedObject(self, @selector(onMaskBtnClick));
	if(btnMask) {
		UIButton *btnMask = objc_getAssociatedObject(self, @selector(onMaskBtnClick));
		[btnMask removeFromSuperview];
		void(^completionHandler)(void)  = objc_getAssociatedObject(self,&kCompetionHanlder);
		if(completionHandler) {
			completionHandler();
		}
	}
	[self removeFromSuperview];
}

#pragma mark 4 Delegate

#pragma mark 5 Event

@end
