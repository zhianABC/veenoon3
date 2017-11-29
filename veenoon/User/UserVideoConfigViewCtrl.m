//
//  UserVideoConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/28.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoConfigViewCtrl.h"
#import "CustomPickerView.h"
#import "UserVideoConfigView.h"

@interface UserVideoConfigViewCtrl () {
   
}
@property (nonatomic, strong) NSArray *_inputDevices;

@end

@implementation UserVideoConfigViewCtrl
@synthesize _inputDevices;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
   
    
    self._inputDevices = @[@{@"name":@"DVD播放器",@"image":@"user_video_dvd_n.png",
                             @"image_sel":@"user_video_dvd_s.png"},
                           @{@"name":@"硬盘播放器",@"image":@"user_video_disk_n.png",
                             @"image_sel":@"user_video_disk_s.png"},
                           @{@"name":@"桌面信息盒",@"image":@"user_video_desk_n.png",
                             @"image_sel":@"user_video_desk_s.png"},
                           @{@"name":@"桌面信息盒",@"image":@"user_video_desk_n.png",
                             @"image_sel":@"user_video_desk_s.png"},
                           @{@"name":@"远程视讯",@"image":@"user_video_remote_n.png",
                             @"image_sel":@"user_video_remote_s.png"},
                           @{@"name":@"摄像机1",@"image":@"user_video_camera_n.png",
                             @"image_sel":@"user_video_camera_s.png"},
                           @{@"name":@"摄像机2",@"image":@"user_video_camera_n.png",
                             @"image_sel":@"user_video_camera_s.png"},
                           @{@"name":@"摄像机3",@"image":@"user_video_camera_n.png",
                             @"image_sel":@"user_video_camera_s.png"}];

   
    UserVideoConfigView *uv = [[UserVideoConfigView alloc]
                               initWithFrame:CGRectMake(0, 0,
                                                        SCREEN_WIDTH,
                                                        SCREEN_HEIGHT-114)];
    [self.view addSubview:uv];
    
    uv._inputDatas = self._inputDevices;
    [uv show];
    
}


- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
