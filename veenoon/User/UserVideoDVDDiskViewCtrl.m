//
//  EngineerDVDViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoDVDDiskViewCtrl.h"
#import "UIButton+Color.h"
#import "VDVDPlayerSet.h"
#import "DVDView.h"

@interface UserVideoDVDDiskViewCtrl () {
    
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
    
    UIButton *_luboBtn;
    UIButton *_tanchuBtn;
    UIButton *_addressBtn;
    VDVDPlayerSet *_currentObj;
}
@property (nonatomic, strong) VDVDPlayerSet *_currentObj;
@end

@implementation UserVideoDVDDiskViewCtrl
@synthesize _currentProcessor;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"video_corner_dvd.png" withTitle:@"DVD播放器"];
    
    DVDView *dvd = [[DVDView alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT) withColor:NEW_UR_BUTTON_GRAY_COLOR withSelColor:NEW_ER_BUTTON_SD_COLOR];
    
    [self.view addSubview:dvd];
    
    dvd._currentObj = self._currentProcessor;
    [dvd loadCurrentDeviceDriverProxys];
    
    //缺切图，把切图贴上即可。
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    

}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


