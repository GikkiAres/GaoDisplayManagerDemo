	//
	//  UIView+GaDisplay.h
	//  productLine
	//
	//  Created by GikkiAres on 2019/2/26.
	//  Copyright © 2019 base. All rights reserved.
	//

#import <UIKit/UIKit.h>
#import "GaoDisplayStyle.h"
#import "GaoToastViewIl.h"




@interface UIView (GaDisplay)

//- (void)displayInView:(UIView *)containerView withMask:(BOOL)needMask position:(GaDisplayPosition)position displayAnimationType:(GaDisplayAnimationType)displayAnimationType undisplayAnimationType:(GaUndisplayAnimationType)undisplayAnimationType cancelBlock:(void(^)(void))cancelBlock;
//
//- (void)displayInView:(UIView *)containerView withMask:(BOOL)needMask isMaskCancellable:(BOOL)isMaskCancellable position:(GaDisplayPosition)position displayAnimationType:(GaDisplayAnimationType)displayAnimationType undisplayAnimationType:(GaUndisplayAnimationType)undisplayAnimationType cancelBlock:(void(^)(void))cancelBlock displayInterval:(NSTimeInterval)interval;

- (void)displayInView:(UIView *)containerView withDisplayStyle:(GaoDisplayStyle *)style completionHandler:(void(^)(void))handler;

- (void)undisplay;
@end

