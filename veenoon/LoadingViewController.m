//
//  LoadingViewController.m
//  Hint
//
//  Created by chen jack on 2017/9/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "LoadingViewController.h"
#import "UserDefaultsKV.h"
#import "SBJson4.h"
#import "AppDelegate.h"
#import "DataSync.h"

@interface LoadingViewController ()
{
    BOOL _isChecking;
    
    WebClient *_msgChecker;
}
@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *adview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_splash.png"]];
    [self.view addSubview:adview];
    CGRect rc = adview.frame;
    int newWidth = SCREEN_WIDTH;
    
    rc.size.height = (adview.frame.size.height)*(newWidth)/(adview.frame.size.width);
    rc.size.width = SCREEN_WIDTH;
    adview.frame = rc;
    
    UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_footer.png"]];
    [self.view addSubview:footer];
    footer.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - CGRectGetHeight(footer.frame)/2+1);
    
    [self checkNewVersion];
    
    
}

- (void) checkNewVersion{
    

    
}


- (void) proccessVersion:(NSDictionary*)v{
    
   
}

- (void) enterApp{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app enterMainApp];
}

- (void) showTimer:(int)secs{
    
    [NSTimer scheduledTimerWithTimeInterval:secs
                                     target:self
                                   selector:@selector(enterApp)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
