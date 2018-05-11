//
//  EngineerTVViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerTVViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "VTVSet.h"
#import "PlugsCtrlTitleHeader.h"
#import "BrandCategoryNoUtil.h"

@interface EngineerTVViewController () <CustomPickerViewDelegate>{
    PlugsCtrlTitleHeader *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    NSMutableArray *_inPutBtnArray;
    
    UIButton *_tanchuBtn;
    
    BOOL isSettings;
    UIButton *okBtn;
}
@end

@implementation EngineerTVViewController
@synthesize _videoTVArray;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_videoTVArray count]) {
        self._currentObj = [_videoTVArray objectAtIndex:0];
    }
    
    if(_currentObj == nil) {
        self._currentObj = [[VTVSet alloc] init];
    }
    
    [super setTitleAndImage:@"video_corner_dianshi.png" withTitle:@"液晶电视"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingsAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    if (_currentObj) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
        [_selectSysBtn setShowText:nameStr];
    }
    
    _tanchuBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _tanchuBtn.frame = CGRectMake(70, SCREEN_HEIGHT-140, 60, 60);
    _tanchuBtn.layer.cornerRadius = 5;
    _tanchuBtn.layer.borderWidth = 2;
    _tanchuBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _tanchuBtn.clipsToBounds = YES;
    [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_address_n.png"] forState:UIControlStateNormal];
    [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_address_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_tanchuBtn];
    
    [_tanchuBtn addTarget:self
                   action:@selector(tanchuAction:)
         forControlEvents:UIControlEventTouchUpInside];

    int playerLeft = 165;
    int playerHeight = 60;
    
    UIButton *lastVideoUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    lastVideoUpBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    lastVideoUpBtn.layer.cornerRadius = 5;
    lastVideoUpBtn.layer.borderWidth = 2;
    lastVideoUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lastVideoUpBtn.clipsToBounds = YES;
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"engineer_left_n.png"] forState:UIControlStateNormal];
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"engineer_left_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:lastVideoUpBtn];
    
    [lastVideoUpBtn addTarget:self
                       action:@selector(lastSingAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okPlayerBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    okPlayerBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    okPlayerBtn.layer.cornerRadius = 5;
    okPlayerBtn.layer.borderWidth = 2;
    okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    okPlayerBtn.clipsToBounds = YES;
    [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:okPlayerBtn];
    
    [okPlayerBtn addTarget:self action:@selector(audioPlayHoldAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    volumnUpBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    volumnUpBtn.layer.cornerRadius = 5;
    volumnUpBtn.layer.borderWidth = 2;
    volumnUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnUpBtn.clipsToBounds = YES;
    [volumnUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [volumnUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnUpBtn];
    
    [volumnUpBtn addTarget:self
                    action:@selector(volumnAddAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextPlayBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    nextPlayBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    nextPlayBtn.layer.cornerRadius = 5;
    nextPlayBtn.layer.borderWidth = 2;
    nextPlayBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    nextPlayBtn.clipsToBounds = YES;
    [nextPlayBtn setImage:[UIImage imageNamed:@"engineer_next_n.png"] forState:UIControlStateNormal];
    [nextPlayBtn setImage:[UIImage imageNamed:@"engineer_next_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:nextPlayBtn];
    
    [nextPlayBtn addTarget:self
                    action:@selector(nextSingAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnDownBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    volumnDownBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    volumnDownBtn.layer.cornerRadius = 5;
    volumnDownBtn.layer.borderWidth = 2;
    volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnDownBtn.clipsToBounds = YES;
    [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnDownBtn];
    
    [volumnDownBtn addTarget:self
                      action:@selector(volumnMinusAction:)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void) nextSingAction:(id)sender{
    
}

- (void) audioPlayHoldAction:(id)sender{
    
}

- (void) lastSingAction:(id)sender{
    
}

- (void) volumnMinusAction:(id)sender{
    
}

- (void) volumnAddAction:(id)sender{
    
}

- (void) tanchuAction:(id)sender{
    
}

- (void) selectCurrentMike:(VTVSet*)mike{
    
    
    self._currentObj = mike;
    
    
    [self updateCurrentMikeState:mike._deviceno];
}

- (void) updateCurrentMikeState:(NSString *)deviceno{
    
    NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
    [_selectSysBtn setShowText:nameStr];
    
    
}

- (void) sysSelectAction:(id)sender{
    
    [self.view addSubview:_dActionView];
    
    IMP_BLOCK_SELF(EngineerTVViewController);
    _dActionView._callback = ^(int tagIndex, id obj)
    {
        [block_self selectCurrentMike:obj];
    };
    
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(VTVSet *mike in _videoTVArray) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:mike._brand withCategory:mike._type withNo:mike._deviceno];
        [arr addObject:@{@"object":mike,@"name":nameStr}];
    }
    
    _dActionView._selectIndex = _currentObj._index;
    [_dActionView setSelectDatas:arr];
}

- (void) chooseDeviceAtIndex:(int)idx{
    
    self._currentObj = [_videoTVArray objectAtIndex:idx];
    
    [self updateCurrentMikeState:_currentObj._deviceno];
    
}

- (void) settingsAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
