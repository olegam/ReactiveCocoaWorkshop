//
//  AppDelegate.m
//  ReactiveExample1
//
//  Created by Ole Gammelgaard Poulsen on 08/08/13.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "AppDelegate.h"
#import "SignupViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	SignupViewController *signupViewController = [SignupViewController new];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signupViewController];
	self.window.rootViewController = navigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}







@end