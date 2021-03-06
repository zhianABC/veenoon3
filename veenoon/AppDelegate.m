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
#import "UserDefaultsKV.h"
#import "RegulusSDK.h"
#import "InvitationCodeViewCotroller.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "KVNProgress.h"
#import "DataCenter.h"
#import "Utilities.h"
#import "JDStatusBarNotification.h"

@interface AppDelegate () <RegulusSDKDelegate>
{
    UIView *_maskView;
    UIActivityIndicatorView *_wait;
    
    BOOL _endingImportState;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [NSThread sleepForTimeInterval:1.0];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [RegulusSDK sharedRegulusSDK].delegate = self;
    
    User *u = [UserDefaultsKV getUser];
    
    if(u)
    {
        if([u isActive])
        {
            HomeViewController *wellcome = [[HomeViewController alloc] init];
            _naviRoot = [[CMNavigationController alloc] initWithRootViewController:wellcome];
            _naviRoot.navigationBarHidden = YES;
        }
        else
        {
            WellcomeViewController *wellcome = [[WellcomeViewController alloc] init];
            wellcome._isActiving = YES;
            _naviRoot = [[CMNavigationController alloc] initWithRootViewController:wellcome];
            _naviRoot.navigationBarHidden = YES;
            
        }
    }
    else
    {
        WellcomeViewController *wellcome = [[WellcomeViewController alloc] init];
        wellcome._isActiving = NO;
        _naviRoot = [[CMNavigationController alloc] initWithRootViewController:wellcome];
        _naviRoot.navigationBarHidden = YES;
        
    }
        
    
    self.window.rootViewController = _naviRoot;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    _maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _wait.hidesWhenStopped = YES;
    [_maskView addSubview:_wait];
    _wait.center = CGPointMake(768/2, 1024/2);
    
    return YES;
}

- (void) logout{
    
    [UserDefaultsKV clearUser];
    
    WellcomeViewController *wellcome = [[WellcomeViewController alloc] init];
    _naviRoot = [[CMNavigationController alloc] initWithRootViewController:wellcome];
    _naviRoot.navigationBarHidden = YES;
    
    self.window.rootViewController = _naviRoot;
    
}

//Regulus SDK delegate
-(void)onConnectChanged:(BOOL)connect
{
    if (connect) {
        
        if(_endingImportState)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Reload_Projects_After_Import_Action"
                                                                object:nil];
        }
        
        _endingImportState = NO;
        
        [JDStatusBarNotification dismissAnimated:YES];
    }
    else{
     
        [JDStatusBarNotification showWithStatus:@"断开链接"
                                      styleName:JDStatusBarStyleError];
    }

}

-(void)onRecvDeviceNotify:(RgsDeviceNoteObj *)notify
{
    
    NSLog(@"dev:%ld,notify:%@,param:%@\n",
          notify.device_id,
          notify.notify,
          notify.param);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RgsDeviceNotify"
                                                        object:notify];
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

- (void) enterMainApp {
    
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
        [dic setObject:@(1) forKey:@"result"];
    }
    else if(status == RGS_IR_RECORD_TIMEOUT)
    {
        [dic setObject:@(2) forKey:@"result"];
    }
    
    if(status != RGS_IR_RECORD_WAIT)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Study_IR"
                                                            object:dic];
    }
}

-(void) onUploadProject:(RgsNotifyStatus) status persent:(CGFloat)persent error:(NSError *)error{
    
    //NSLog(@"%f - %d", persent, status);
    
    if(status == RGS_NOTIFY_STATUS_DONE)
    {
        [KVNProgress showSuccess];
    }
    else if(status != RGS_NOTIFY_STATUS_START)
    {
        [KVNProgress dismiss];
    }
}

-(void) onExportProject:(RgsNotifyStatus) status{
    
    if(status == RGS_NOTIFY_STATUS_DONE)
    {
        if([DataCenter defaultDataCenter]._isExpotingToCloudPrj)
        {
            [DataCenter defaultDataCenter]._isExpotingToCloudPrj = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Export_Done"
                                                                object:nil];
        }
        else
        {
            [KVNProgress showSuccessWithStatus:@"导出成功!"];
        }
    }
    else if(status != RGS_NOTIFY_STATUS_START)
    {
        [KVNProgress dismiss];
    }
}
-(void) onImportProject:(RgsNotifyStatus) status{
    
    if(status == RGS_NOTIFY_STATUS_DONE)
    {
        [KVNProgress showWithStatus:@"已导入，请稍侯..."];
        _endingImportState = YES;
        
    }
    else if(status == RGS_NOTIFY_STATUS_FAILED
            || status == RGS_NOTIFY_STATUS_TIMEOUT)
    {
        [KVNProgress dismiss];
    }
}

-(void)onSystemWillReboot:(NSString *)reason
{
    //[KVNProgress showSuccessWithStatus:reason];
}


-(void)onDownloadUpdatePacket:(RgsNotifyStatus)status persent:(CGFloat)persent error:(NSError *)error
{
    if (error) {
        [KVNProgress showErrorWithStatus:[error description]];
    }
    else if(status == RGS_NOTIFY_STATUS_START)
    {
        //NSLog(@"%f",persent);
        [KVNProgress showProgress:persent status:@"正在下载"];
    }
    else if (status == RGS_NOTIFY_STATUS_DONE)
    {
        [KVNProgress showSuccessWithStatus:@"下载完成"];
        //        [self presentViewController:[self RebootAlert] animated:YES completion:nil];
    }
}

-(void)onDepressUpdatePacket:(RgsNotifyStatus)status persent:(CGFloat)persent error:(NSError *)error
{
    if(error)
    {
        [KVNProgress showErrorWithStatus:[error description]];
    }
    else if(status == RGS_NOTIFY_STATUS_START)
    {
        [KVNProgress showProgress:persent status:@"正在解压"];
    }
    else if (status == RGS_NOTIFY_STATUS_DONE)
    {
        //[KVNProgress showSuccessWithStatus:@"解压完成"];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"解压完成"
                                                    message:@"重启完成升级，是否重启？"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"重启", nil];
        av.tag = 201901;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 201901 && alertView.cancelButtonIndex != buttonIndex) {
        
        [[RegulusSDK sharedRegulusSDK] RebootSystem:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyGoBackWhenReboot"
                                                            object:nil];
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskLandscape;
}

-(void)handle_enter_foreground
{
    if([[RegulusSDK sharedRegulusSDK] IsLoginBeforce])
    {
        [[RegulusSDK sharedRegulusSDK] Resume:^(BOOL result, NSError *error)
         {
             
         }];
    }
}

- (void) handle_enter_background{
    
    if ([[RegulusSDK sharedRegulusSDK] IsLoginBeforce]) {
        [[RegulusSDK sharedRegulusSDK] Pause:^(BOOL result, NSError *error) {
            
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self handle_enter_background];
    
    //[[DataSync sharedDataSync] logoutCurrentRegulus];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self handle_enter_foreground];
    //[[DataSync sharedDataSync] reloginRegulus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*

// 是否允许旋转 IOS5
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

// 是否允许旋转 IOS6
-(BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

 */
@end
