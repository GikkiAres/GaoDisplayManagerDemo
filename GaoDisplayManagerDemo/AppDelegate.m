//
//  AppDelegate.m
//  GaoDisplayManagerDemo
//
//  Created by Gikki Ares on 2020/8/5.
//  Copyright © 2020 vgemv. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	self.window = [[UIWindow alloc] init];
	self.window.frame = [UIScreen mainScreen].bounds;
	HomeViewController * vc = [HomeViewController new];
	UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
	self.window.rootViewController = nc;
	[self.window makeKeyAndVisible];
	
	return YES;
}

@end
