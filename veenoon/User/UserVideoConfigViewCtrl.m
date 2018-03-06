//
//  UserVideoConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/28.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoConfigViewCtrl.h"
#import "UserVideoConfigView.h"
#import "UserVideoDVDDiskViewCtrl.h"
#import "UserVideoCameraSettingsViewCtrl.h"
#import "UserVideoRemoteShiXunViewCtrl.h"
#import "UserVideoLuBoJiViewCtrl.h"

@interface UserVideoConfigViewCtrl () <UserVideoConfigViewDelegate> {
   
}
@property (nonatomic, strong) NSArray *_inputDevices;
@property (nonatomic, strong) NSArray *_outputDevices;

@end

@implementation UserVideoConfigViewCtrl
@synthesize _inputDevices;
@synthesize _outputDevices;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
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
    
    self._outputDevices = @[@{@"name":@"拼接屏",@"image":@"user_video_pinjieping_n.png",
                              @"image_sel":@"user_video_pinjieping_s.png",
                              @"code":@"1000"},
                            @{@"name":@"投影机",@"image":@"user_video_touying_n.png",
                              @"image_sel":@"user_video_touying_s.png",
                              @"code":@"1001"},
                            @{@"name":@"液晶电视",@"image":@"user_video_yejing_n.png",
                              @"image_sel":@"user_video_yejing_s.png",
                              @"code":@"1002"},
                            @{@"name":@"液晶电视",@"image":@"user_video_yejing_n.png",
                              @"image_sel":@"user_video_yejing_s.png",
                              @"code":@"1003"},
                            @{@"name":@"录播机",@"image":@"user_video_lubo_n.png",
                              @"image_sel":@"user_video_lubo_s.png",
                              @"code":@"1004"},
                            @{@"name":@"远程视讯",@"image":@"user_video_remote_n.png",
                              @"image_sel":@"user_video_remote_s.png",
                              @"code":@"1005"}];

   
    UserVideoConfigView *uv = [[UserVideoConfigView alloc]
                               initWithFrame:CGRectMake(0, 0,
                                                        SCREEN_WIDTH,
                                                        SCREEN_HEIGHT-114)];
    [self.view addSubview:uv];
    
    uv._inputDatas = self._inputDevices;
    uv._outputDatas = self._outputDevices;
    uv.delegate_ = self;
    [uv show];
    
}

- (void) didPupConfigView:(StickerLayerView*)sticker {
    NSDictionary *dic = sticker._element;
    
    NSString *deviceName = [dic objectForKey:@"name"];
    
    if ([@"DVD播放器" isEqualToString:deviceName]
            || [@"硬盘播放器" isEqualToString:deviceName]) {
        UserVideoDVDDiskViewCtrl *ctrl = [[UserVideoDVDDiskViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    if ([@"远程视讯" isEqualToString:deviceName]) {
        UserVideoRemoteShiXunViewCtrl *ctrl = [[UserVideoRemoteShiXunViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    if ([deviceName containsString:@"摄像机"]) {
        UserVideoCameraSettingsViewCtrl *ctrl = [[UserVideoCameraSettingsViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    if ([@"录播机" isEqualToString:deviceName]) {
        UserVideoLuBoJiViewCtrl *ctrl = [[UserVideoLuBoJiViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
