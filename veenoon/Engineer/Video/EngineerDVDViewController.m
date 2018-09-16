//
//  EngineerDVDViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerDVDViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "VDVDPlayerSet.h"
#import "BrandCategoryNoUtil.h"
#import "PlugsCtrlTitleHeader.h"
#import "DVDView.h"


@interface EngineerDVDViewController () <CustomPickerViewDelegate>{
    
}

@property (nonatomic, strong) VDVDPlayerSet *_currentObj;

@end

@implementation EngineerDVDViewController
@synthesize _dvdSysArray;
@synthesize _number;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([_dvdSysArray count]) {
        self._currentObj = [_dvdSysArray objectAtIndex:0];
    }
    
    if(_currentObj == nil) {
        self._currentObj = [[VDVDPlayerSet alloc] init];
    }
    
    [super showBasePluginName:self._currentObj chooseEnabled:NO];
    
    [super setTitleAndImage:@"video_corner_dvd.png" withTitle:@"DVD"];
    
    DVDView *dvd = [[DVDView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT) withColor:NEW_ER_BUTTON_GRAY_COLOR2 withSelColor:NEW_ER_BUTTON_BL_COLOR];
    
    [self.view addSubview:dvd];
    
    dvd._currentObj = self._currentObj;
    [dvd loadCurrentDeviceDriverProxys];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingsAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void) settingsAction:(id)sender{
    //检查是否需要创建
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
