//
//  AppDelegate.m
//  ExasForiPad
//
//  Created by jack on 4/9/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "CMNavigationController.h"
#import "WellcomeViewController.h"
#import "HomeViewController.h"
#import "EngineerMonitorViewCtrl.h"
#import "DataSync.h"
#import "RegulusSDK.h"

@interface AppDelegate () <RegulusSDKDelegate>
{
    UIView *_maskView;
    UIActivityIndicatorView *_wait;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setActive:YES error:nil];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
    [RegulusSDK sharedRegulusSDK].delegate = self;
    
    HomeViewController *wellcome = [[HomeViewController alloc] init];
    _naviRoot = [[CMNavigationController alloc] initWithRootViewController:wellcome];
    _naviRoot.navigationBarHidden = YES;
    self.window.rootViewController = _naviRoot;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //[self enterApp];
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    _maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _wait.hidesWhenStopped = YES;
    [_maskView addSubview:_wait];
    _wait.center = CGPointMake(768/2, 1024/2);
    
    return YES;
}


//Regulus SDK delegate
-(void)onConnectChanged:(BOOL)connect
{
    
}

-(void)onRecvDeviceNotify:(RgsDeviceNoteObj *)notify
{
    NSLog(@"dev:%ld,notify:%@,param:%@\n",notify.device_id,notify.notify,notify.param);
}

-(void)onDowningTopology:(float)persen
{
    //[KVNProgress showProgress:persen];
}

-(void)onDownDoneTopology
{
    //[KVNProgress dismiss];
}


+(AppDelegate*)shareAppDelegate{
    
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return app;
}

- (void) showWait:(BOOL)show{
    if(show)
    {
        [self.window addSubview:_maskView];
        [_wait startAnimating];
    }
    else
    {
        [_maskView removeFromSuperview];
        [_wait stopAnimating];
    }
}

- (void) enterApp {
    
    HomeViewController *homeCtrl = [[HomeViewController alloc] init];
    _naviRoot = [[CMNavigationController alloc] initWithRootViewController:homeCtrl];
    _naviRoot.navigationBarHidden = YES;
    self.window.rootViewController = _naviRoot;
}

-(void) onIrcodeRecord:(NSString *)serial key:(NSString *)key status:(RgsIrRecordStatus)status{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:serial forKey:@"uuid"];
    [dic setObject:key forKey:@"key"];
    if(status == RGS_IR_RECORD_DONE)
    {
        [dic setObject:@1 forKey:@"result"];
    }
    else
    {
        [dic setObject:@0 forKey:@"result"];
    }
    
    if(status != RGS_IR_RECORD_WAIT)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Study_IR"
                                                            object:dic];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskLandscape;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[DataSync sharedDataSync] logoutCurrentRegulus];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[DataSync sharedDataSync] reloginRegulus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
