//
//  LablePromptView.m
//  productLine
//
//  Created by GikkiAres on 2020/5/27.
//  Copyright © 2020 base. All rights reserved.
//

#import "GaoToastViewIl.h"
#import "GaoDisplayManager.h"

@implementation GaoToastViewIl

+ (GaoToastViewIl *)newInstanceWithMessage:(NSString *)message {
    GaoToastViewIl * view = [[[NSBundle mainBundle]loadNibNamed:@"GaoToastViewIl" owner:nil options:nil]firstObject];
    view.bounds = CGRectMake(0, 0, 350, 140);
    [view commonInit];
    view.label.text = message;
    view.alpha = 0.9;
    return view;
}

+ (void)showNewInstancenewInstanceWithMessage:(NSString *)message  inView:(UIView *)superView{
    GaoToastViewIl * view = [GaoToastViewIl newInstanceWithMessage:@"无仕样数据,在线获取"];
    [view showInView:superView];
}

- (void)commonInit{
    self.layer.borderWidth = 2;
    UIColor * color = [UIColor blackColor];
    self.layer.borderColor = [color CGColor];
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.textColor = color;
    
}

- (void)showInView:(UIView *)superview {
	GaoDisplayStyle * style = [GaoDisplayStyle defaulStyle];
	style.mf_displayTime = 2;
	[self displayInView:superview withDisplayStyle:style completionHandler:nil];
}

- (void)dealloc {
    NSLog(@"GaoToastViewIl dealloc!");
}


@end
