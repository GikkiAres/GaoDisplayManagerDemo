//
//  LablePromptView.h
//  productLine
//
//  Created by GikkiAres on 2020/5/27.
//  Copyright © 2020 base. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GaoToastViewIl : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;

+ (GaoToastViewIl *)newInstanceWithMessage:(NSString *)message;

+ (void)showNewInstancenewInstanceWithMessage:(NSString *)message inView:(UIView *)superView;


@end

NS_ASSUME_NONNULL_END
