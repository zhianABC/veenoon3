//
//  AppDelegate.h
//  ExasForiPad
//
//  Created by jack on 4/9/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *_naviRoot;
    
    
}
@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)shareAppDelegate;

- (void) enterMainApp;

- (void) showWait:(BOOL)show;

- (void) logout;

@end

