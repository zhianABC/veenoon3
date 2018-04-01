//
//  EngineerPlayerSettingsViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPlayerSettingsViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "PlayerRightView.h"

@interface EngineerPlayerSettingsViewCtrl () <CustomPickerViewDelegate>{
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
    
    UIButton *_luboBtn;
    UIButton *_tanchuBtn;
    
    BOOL isSettings;
    
    PlayerRightView *_psv;
    UIButton *okBtn;
}
@end

@implementation EngineerPlayerSettingsViewCtrl
@synthesize _playerSysArray;
@synthesize _number;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    [super setTitleAndImage:@"audio_corner_bofangqi.png" withTitle:@"CD"];
    
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
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _selectSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSysBtn.frame = CGRectMake(50, 100, 80, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"001" forState:UIControlStateNormal];
    _selectSysBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,_selectSysBtn.imageView.bounds.size.width)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width+35,0,0)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    int height = SCREEN_HEIGHT - 200;
    int width = 80;
    
    _volumnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    _volumnMinus.frame = CGRectMake(0, 0, width, width);
    _volumnMinus.center = CGPointMake(SCREEN_WIDTH/2 - 200, height);
    [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_r_minus_n.png"] forState:UIControlStateNormal];
    [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_minus_s.png"] forState:UIControlStateHighlighted];
    [_volumnMinus addTarget:self action:@selector(volumnMinusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumnMinus];
    
    _lastSing = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastSing.frame = CGRectMake(0, 0, width, width);
    _lastSing.center = CGPointMake(SCREEN_WIDTH/2 - 100, height);
    [_lastSing setImage:[UIImage imageNamed:@"audio_player_r_last_n.png"] forState:UIControlStateNormal];
    [_lastSing setImage:[UIImage imageNamed:@"audio_player_last_s.png"] forState:UIControlStateHighlighted];
    [_lastSing addTarget:self action:@selector(lastSingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lastSing];
    
    isplay = NO;
    _playOrHold = [UIButton buttonWithType:UIButtonTypeCustom];
    _playOrHold.frame = CGRectMake(0, 0, width, width);
    _playOrHold.center = CGPointMake(SCREEN_WIDTH/2, height);
    [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateNormal];
    [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateHighlighted];
    [_playOrHold addTarget:self action:@selector(audioPlayHoldAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playOrHold];
    
    _nextSing = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextSing.frame = CGRectMake(0, 0, width, width);
    _nextSing.center = CGPointMake(SCREEN_WIDTH/2 + 100, height);
    [_nextSing setImage:[UIImage imageNamed:@"audio_player_r_next_n.png"] forState:UIControlStateNormal];
    [_nextSing setImage:[UIImage imageNamed:@"audio_player_next_s.png"] forState:UIControlStateHighlighted];
    [_nextSing addTarget:self action:@selector(nextSingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextSing];
    
    _volumnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _volumnAdd.frame = CGRectMake(0, 0, width, width);
    _volumnAdd.center = CGPointMake(SCREEN_WIDTH/2 + 200, height);
    [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_r_next_n.png"] forState:UIControlStateNormal];
    [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_next_s.png"] forState:UIControlStateHighlighted];
    [_volumnAdd addTarget:self action:@selector(nextSingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumnAdd];
    
    UIImageView *playerIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_player_title_s.png"]];
    [self.view addSubview:playerIndicator];
    playerIndicator.frame = CGRectMake(0, 0, 322, 322);
    playerIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 450);
    
    playerIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_player_title_n2.png"]];
//    [self.view addSubview:playerIndicator];
    playerIndicator.frame = CGRectMake(0, 0, 15, 19);
    playerIndicator.center = CGPointMake(SCREEN_WIDTH/2+48-8, SCREEN_HEIGHT - 500+100-10);
    
    _luboBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    _luboBtn.frame = CGRectMake(70, SCREEN_HEIGHT-140, 60, 60);
    _luboBtn.layer.cornerRadius = 5;
    _luboBtn.layer.borderWidth = 2;
    _luboBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _luboBtn.clipsToBounds = YES;
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_luboBtn];
    
    [_luboBtn addTarget:self
                       action:@selector(luboAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    _tanchuBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    _tanchuBtn.frame = CGRectMake(150, SCREEN_HEIGHT-140, 60, 60);
    _tanchuBtn.layer.cornerRadius = 5;
    _tanchuBtn.layer.borderWidth = 2;
    _tanchuBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _tanchuBtn.clipsToBounds = YES;
    [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_tanchu_n.png"] forState:UIControlStateNormal];
    [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_tanchu_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_tanchuBtn];
    
    [_tanchuBtn addTarget:self
                       action:@selector(tanchuAction:)
             forControlEvents:UIControlEventTouchUpInside];
}
- (void) luboAction:(id)sender{
}

- (void) tanchuAction:(id)sender{
    
}
- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 100) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 2; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"00%d", i]];
    }
    
    _customPicker._pickerDataArray = @[@{@"values":arr}];
    
    
    _customPicker._selectColor = [UIColor orangeColor];
    _customPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_customPicker];
    _customPicker.delegate_ = self;
}

- (void) didConfirmPickerValue:(NSString*) pickerValue {
    if (_customPicker) {
        [_customPicker removeFromSuperview];
    }
    NSString *title =  [@"" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}

- (void) nextSingAction:(id)sender{
    
}

- (void) audioPlayHoldAction:(id)sender{
    if (isplay) {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateNormal];
        isplay = NO;
    } else {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateNormal];
        isplay = YES;
    }
}

- (void) lastSingAction:(id)sender{
    
}

- (void) volumnMinusAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    if (!isSettings) {
        _psv = [[PlayerRightView alloc]
                initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                         64, 300, SCREEN_HEIGHT-114)];
        [self.view addSubview:_psv];
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_psv) {
            [_psv removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
