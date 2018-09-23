//
//  UserElectronicAutoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/2.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserElectronicAutoViewCtrl.h"
#import "IconCenterTextButton.h"
#import "BlindPluginProxy.h"
#import "UIButton+Color.h"
#import "BasePlugElement.h"
#import "BlindPlugin.h"
#import "Scenario.h"

@interface UserElectronicAutoViewCtrl () {

    NSMutableArray *btnArray_;
    
    UIButton *upBtn;
    UIButton *playBtn;
    UIButton *downBtn;
    
    int currentSelected;
    
    UIButton *_previvousBtn;
}
@end

@implementation UserElectronicAutoViewCtrl
@synthesize _currentBlind;
@synthesize _blindArray;
@synthesize _scenario;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _blindArray = [NSMutableArray array];
    
    for(BasePlugElement *plug in _scenario._envDevices)
    {
        if([plug isKindOfClass:[BlindPlugin class]]){
            [_blindArray addObject:plug];
        }
    }
    

    if ([_blindArray count]) {
        self._currentBlind = [_blindArray objectAtIndex:0];
    }

    btnArray_ = [NSMutableArray array];
    
    [super setTitleAndImage:@"env_corner_diandongmada.png" withTitle:@"驱动马达"];

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


    
    
    if(self._currentBlind)
    {
        [self layoutElecAutoUI];
        
    }
}

- (void) layoutElecAutoUI{
    
    int height = 260;
    int width = 100;
    int rowGap = 70;
    
    
    int number = [self._currentBlind._proxyObj getChannelNumber];
    
    int startX = SCREEN_WIDTH/2 - number*width/2-(number-1)*rowGap/2+10;
    
    for (int i = 0; i < number; i++) {
        IconCenterTextButton *diandongchuanglianBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(startX+(rowGap+width)*i, height, width, width)];
        
        NSString *name = [@"Channel " stringByAppendingString:[NSString stringWithFormat:@"%d", i+1]];
        [diandongchuanglianBtn  buttonWithIcon:[UIImage imageNamed:@"user_diandongchuanglian_n.png"] selectedIcon:[UIImage imageNamed:@"user_diandongchuanglian_s.png"] text:name normalColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
        
        diandongchuanglianBtn.tag = i+1;
        
        [diandongchuanglianBtn addTarget:self action:@selector(dianchuanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:diandongchuanglianBtn];
        
        [btnArray_ addObject:diandongchuanglianBtn];
    }
    
    int playerHeight = 270;
    
    int btnGap = 80;
    int buttonSX = SCREEN_WIDTH/2 - btnGap - 120;
    
    upBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    upBtn.frame = CGRectMake(buttonSX, SCREEN_HEIGHT-playerHeight, 80, 80);
    upBtn.layer.cornerRadius = 5;
    upBtn.layer.borderWidth = 2;
    upBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    upBtn.clipsToBounds = YES;
    [upBtn setImage:[UIImage imageNamed:@"user_electronic_up.png"] forState:UIControlStateNormal];
    [upBtn setImage:[UIImage imageNamed:@"user_electronic_up.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:upBtn];
    
    [upBtn addTarget:self
              action:@selector(upAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    playBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    playBtn.frame = CGRectMake(buttonSX + btnGap + 80, SCREEN_HEIGHT-playerHeight, 80, 80);
    playBtn.layer.cornerRadius = 5;
    playBtn.layer.borderWidth = 2;
    playBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    playBtn.clipsToBounds = YES;
    [playBtn setImage:[UIImage imageNamed:@"user_electronic_play.png"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"user_electronic_play.png"] forState:UIControlStateHighlighted];
    playBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:playBtn];
    
    [playBtn addTarget:self action:@selector(playAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    downBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    downBtn.frame = CGRectMake(buttonSX + btnGap*2 + 80*2, SCREEN_HEIGHT-playerHeight, 80, 80);
    downBtn.layer.cornerRadius = 5;
    downBtn.layer.borderWidth = 2;
    downBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    downBtn.clipsToBounds = YES;
    [downBtn setImage:[UIImage imageNamed:@"user_electronic_down.png"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"user_electronic_down.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:downBtn];
    
    [downBtn addTarget:self
                action:@selector(downAction:)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void) upAction:(UIButton*)sender{
    
    int statue = 1;
    [upBtn changeNormalColor:NEW_ER_BUTTON_SD_COLOR];
    [playBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    [downBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    
    if (currentSelected <= 0) {
        return;
    }
    
    [_currentBlind._proxyObj controlStatue:statue withCh:currentSelected];
    
    _previvousBtn = sender;
}
- (void) playAction:(UIButton*)sender{
    int statue = 2;
    
    [upBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    [playBtn changeNormalColor:NEW_ER_BUTTON_SD_COLOR];
    [downBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    
    if (currentSelected <= 0) {
        return;
    }
    
    [_currentBlind._proxyObj controlStatue:statue withCh:currentSelected];
    
    _previvousBtn = sender;
}
- (void) downAction:(UIButton*)sender{
    int statue = 3;
    
    [upBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    [playBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    [downBtn changeNormalColor:NEW_ER_BUTTON_SD_COLOR];
    
    if (currentSelected <= 0) {
        return;
    }
    
    [_currentBlind._proxyObj controlStatue:statue withCh:currentSelected];
    _previvousBtn = sender;
}
- (void) dianchuanBtnAction:(IconCenterTextButton*)sender{
    int selectTag = (int) sender.tag;
    
    if (currentSelected == selectTag) {
        return;
    }
    
    for (IconCenterTextButton *btn in btnArray_) {
        if (btn.tag == selectTag) {
            [btn setBtnHighlited:YES];
        } else {
            [btn setBtnHighlited:NO];
        }
    }
    
    currentSelected = selectTag;
    
    [upBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    [playBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
    [downBtn changeNormalColor:NEW_UR_BUTTON_GRAY_COLOR];
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
