//
//  HomeViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "HomeViewController.h"
#import "EnginnerHomeViewController.h"
#import "UserHomeViewController.h"
#import "NSDate-Helper.h"
#import "UserVideoLuBoJiViewCtrl.h"
#import "VNSettingsView.h"
#import "JCActionView.h"
#import "AppDelegate.h"
#import "DataSync.h"
#import "EngineerPresetScenarioViewCtrl.h"
#import "UIButton+Color.h"

@interface HomeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, JCActionViewDelegate> {
    
    UIButton *_settingsBtn;
    UIButton *_engineerBtn;
    UIButton *_userBtn;
    
    UIView *_homeView;
    UILabel* timeLabel;
    UILabel* dateLabel;
    UILabel* weekdayLabel;
    
    NSTimer *_timer;
    BOOL _isStop;
    
    UIScrollView *_content;
    
    VNSettingsView *_vnsetView;
    
    UIImagePickerController *_imagePicker;
    
    UIImageView *imageView;
}

@end

@implementation HomeViewController

- (void) viewWillAppear:(BOOL)animated
{
    if(_timer && [_timer isValid])
    {
        [_timer invalidate];
    }
    
    _isStop = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(updateTime)
                                            userInfo:nil
                                             repeats:NO];
    
    
    [[DataSync sharedDataSync] logoutCurrentRegulus];

}

- (void) viewWillDisappear:(BOOL)animated{
    
    _isStop = YES;
    if(_timer && [_timer isValid])
    {
        [_timer invalidate];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    _homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self createHomeView];
    
    _vnsetView = [[VNSettingsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_vnsetView setViewCtrl:self];
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _content.bounces = NO;
    [self.view addSubview:_content];
    _content.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT);
    _content.pagingEnabled = YES;
    _content.showsHorizontalScrollIndicator = NO;
    
    [_content addSubview:_homeView];
    [_content addSubview:_vnsetView];

    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    UIEdgeInsets inset = _content.contentInset;
    inset.top = -StatusRect.size.height;
    _content.contentInset = inset;
    
}



- (void) createHomeView{
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_homeView addSubview:imageView];
    
    UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
    [_homeView addGestureRecognizer:longPress0];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_shadow.png"]];
    icon.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
    icon.userInteractionEnabled = YES;
    [_homeView addSubview:icon];
    
    
    _engineerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _engineerBtn.frame = CGRectMake(70, SCREEN_HEIGHT - 60, 50, 50);
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_n.png"] forState:UIControlStateNormal];
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_s.png"] forState:UIControlStateHighlighted];
    [_engineerBtn addTarget:self action:@selector(engineerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homeView addSubview:_engineerBtn];
    
    
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 60, 50, 50);
    [_userBtn setImage:[UIImage imageNamed:@"main_user_log_normal.png"] forState:UIControlStateNormal];
    [_userBtn setImage:[UIImage imageNamed:@"main_user_login_selected.png"] forState:UIControlStateHighlighted];
    [_userBtn addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homeView addSubview:_userBtn];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                   SCREEN_HEIGHT - 240,
                                                                   SCREEN_WIDTH, 60)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:60];
    timeLabel.userInteractionEnabled = YES;
    
    NSString *hourStr = [NSDate currentHour];
    NSString *minuteStr = [NSDate currentMinute];
    timeLabel.text = [hourStr stringByAppendingString:minuteStr];
    
    [_homeView addSubview:timeLabel];
    
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                   SCREEN_HEIGHT - 180,
                                                                   110, 40)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:24];
    dateLabel.userInteractionEnabled = YES;
    
    NSString *dateStr = [NSDate currentDate];
    
    dateLabel.text = dateStr;
    [_homeView addSubview:dateLabel];
    
    
    weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(180,
                                                                      SCREEN_HEIGHT - 180,
                                                                      120, 40)];
    weekdayLabel.textColor = [UIColor whiteColor];
    weekdayLabel.font = [UIFont systemFontOfSize:24];
    weekdayLabel.userInteractionEnabled = YES;
    
    NSString *weekDayStr = [NSDate currentWeekday];
    
    weekdayLabel.text = weekDayStr;
    [_homeView addSubview:weekdayLabel];
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [_homeView addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 50, 70, 10);
    
}


- (void) longPressed0:(id)sender{
    if(_imagePicker == nil)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    [[UINavigationBar appearance] setTintColor:THEME_COLOR];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        JCActionView *jcAction = [[JCActionView alloc] initWithTitles:@[@"直接拍照", @"从相册中选取"]
                                                                frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        jcAction.delegate_ = self;
        jcAction.tag = 2017;
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.window addSubview:jcAction];
        [jcAction animatedShow];
        
    }
    else
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES
                         completion:^{
                             
                         }];
    }
}

- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView{
    
    if(index == 0)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES
                         completion:^{
                         }];
    }
    else if(index == 1)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES
                         completion:^{
                             
                         }];
    }
    
}


/**** Image Picker Delegates ******/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(800, 800)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                imageView.image = img;
                ///////图从这儿穿出去
                
            });
        });
    }
    
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    if(image==nil)return nil;
    
    float width = image.size.width;
    float height = image.size.height;
    float x, x1, y1;
    
    if(width > height)
    {
        x1 = width / newSize.height;
        y1 = height / newSize.width;
    }
    else
    {
        x1 = width / newSize.width;
        y1 = height / newSize.height;
    }
    
    x = (x1 > y1) ? x1:y1;
    
    if(x < 1.0)return image;
    
    if(fabs(x-1.0) < 0.0001)return image;
    
    CGSize s = CGSizeMake(width/x,height/x);
    
    
    UIGraphicsBeginImageContext(s);
    [image drawInRect:CGRectMake(0,0,s.width,s.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) updateTime{
    
    NSString *hourStr = [NSDate currentHour];
    NSString *minuteStr = [NSDate currentMinute];
    timeLabel.text = [hourStr stringByAppendingString:minuteStr];
    
    NSString *dateStr = [NSDate currentDate];
    dateLabel.text = dateStr;
    
    NSString *weekDayStr = [NSDate currentWeekday];
    weekdayLabel.text = weekDayStr;
    
    if(!_isStop)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateTime)
                                                userInfo:nil
                                                 repeats:NO];
    }
}

- (void) userLoginAction:(id)sender{
    
    UserHomeViewController *lctrl = [[UserHomeViewController alloc] init];
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) engineerAction:(id)sender{
    EnginnerHomeViewController *lctrl = [[EnginnerHomeViewController alloc] init];
    [self.navigationController pushViewController:lctrl animated:YES];
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
