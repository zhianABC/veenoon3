//
//  EngineerNewTeslariViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerNewTeslariViewCtrl.h"
#import "EngineerAudioDevicePluginViewCtrl.h"

#import "RegulusSDK.h"
#import "DataSync.h"
#import "DataCenter.h"
#import "KVNProgress.h"


@interface EngineerNewTeslariViewCtrl () {
    
}
@property (nonatomic, strong) NSArray *_driver_objs;
@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSArray *_area_objs;

@end

@implementation EngineerNewTeslariViewCtrl
@synthesize _mapDrivers;
@synthesize _driver_objs;
@synthesize _area_objs;
@synthesize _isLocal;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP+10, SCREEN_WIDTH-80, 40)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"欢迎使用T-CES系统";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame) + 20, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"TESLARIA将引导您完成整个系统的设置过程";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame), SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"音频> 视频> 环境> 传感器> 其他";
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    if(_isLocal)
    {
        //准备插件
        [[DataCenter defaultDataCenter] prepareDrivers];
        [self actionNewArea];
    }
    
#if LOGIN_REGULUS
    
    //获取Regulus支持的插件
    [[DataSync sharedDataSync] syncRegulusDrivers];
    
    [[DataSync sharedDataSync] syncRegulusIRDrivers];
    
#endif
    

}

- (void) actionNewArea{
    
    //[KVNProgress dismiss];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[DataSync sharedDataSync] newVeenoonArea];
    
    });
    
    
}



- (void) okAction:(id)sender{
    
    EngineerAudioDevicePluginViewCtrl *ctrl = [[EngineerAudioDevicePluginViewCtrl alloc] init];
    NSMutableDictionary *selectedSysDic = [[NSMutableDictionary alloc] init];
    ctrl._selectedSysDic = selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

