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
#import "Scenario.h"
#import "VVideoProcessSet.h"
#import "VVideoProcessSetProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface UserVideoConfigViewCtrl () <UserVideoConfigViewDelegate, VVideoProcessSetProxyDelegate> {
   
    int inputMin;
    int inputMax;
    
    int outputMax;
    int outputMin;
    
    
    UserVideoConfigView *_contrlPanl;
    
}
@property (nonatomic, strong) NSMutableArray *_inputDevices;
@property (nonatomic, strong) NSMutableArray *_outputDevices;
@property (nonatomic, strong) VVideoProcessSet *_curProcessor;
@property (nonatomic, strong) VVideoProcessSetProxy *_currentProxy;

@end

@implementation UserVideoConfigViewCtrl
@synthesize _inputDevices;
@synthesize _outputDevices;
@synthesize _scenario;
@synthesize _curProcessor;
@synthesize _currentProxy;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"user_corner_video.png" withTitle:@"视频处理器"];
    
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
    
   
    _contrlPanl = [[UserVideoConfigView alloc]
                               initWithFrame:CGRectMake(0, 0,
                                                        SCREEN_WIDTH,
                                                        SCREEN_HEIGHT-114)];
    [self.view addSubview:_contrlPanl];
    
    if([_scenario._videoDevices count])
    {
        for(BasePlugElement *plug in _scenario._videoDevices)
        {
            if([plug isKindOfClass:[VVideoProcessSet class]])
                self._curProcessor = (VVideoProcessSet*)plug;
        }
    }
    
    [self getCurrentDeviceDriverProxys];
    
    
    
    
}


- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserVideoConfigViewCtrl);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedVideoProcessorProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
            }
        }];
    }
#endif
}

- (void) loadedVideoProcessorProxy:(NSArray*)proxys{
    
    id proxy = self._curProcessor._proxyObj;
    
    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        self._currentProxy = proxy;
    }
    
    if(_currentProxy)
    {
        _currentProxy.delegate = self;
        _currentProxy._rgsProxyObj = [proxys objectAtIndex:0];
        [_currentProxy checkRgsProxyCommandLoad];
        
        self._curProcessor._proxyObj = _currentProxy;
    }
    
}

- (void) didLoadedProxyCommand {
    
    _currentProxy.delegate = nil;
    
    NSDictionary *inputSettings = [_currentProxy getVideoProcessInputSettings];
    
    inputMin = [[inputSettings objectForKey:@"min"] intValue];
    inputMax = [[inputSettings objectForKey:@"max"] intValue];
    
    NSDictionary *outputSettings = [_currentProxy getVideoProcessOutputSettings];
    
    outputMin = [[outputSettings objectForKey:@"min"] intValue];
    outputMax = [[outputSettings objectForKey:@"max"] intValue];
    
    [self updateView];
}

- (void) updateView{
    
    self._inputDevices = [NSMutableArray array];
    self._outputDevices = [NSMutableArray array];
    
    NSDictionary *inputs = _currentProxy._inputDevices;
    
    for(int i = inputMin; i <= inputMax; i++)
    {
        id key = [NSString stringWithFormat:@"%d", i];
        
        if([inputs objectForKey:key])
        {
            [self._inputDevices addObject:[inputs objectForKey:key]];
        }
        else
        {
            [self._inputDevices addObject:@{@"ctrl_val":key}];
        }
        
    }
    
    NSDictionary *outputs = _currentProxy._outputDevices;
    
    for(int i = outputMin; i <= outputMax; i++)
    {
        id key = [NSString stringWithFormat:@"%d", i];
        
        if([outputs objectForKey:key])
        {
            [self._outputDevices addObject:[outputs objectForKey:key]];
        }
        else
        {
            [self._outputDevices addObject:@{@"ctrl_val":key}];
        }
        
    }
   
    /*
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
     */
    
    
   
    
    _contrlPanl._inputDatas = self._inputDevices;
    _contrlPanl._outputDatas = self._outputDevices;
    _contrlPanl.delegate_ = self;
    [_contrlPanl show];
    
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
    if ([deviceName containsString:video_camera_name]) {
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
