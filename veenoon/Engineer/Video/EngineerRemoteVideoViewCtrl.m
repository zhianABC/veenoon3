//
//  EngineerRemoteVideoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerRemoteVideoViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "VRemoteSettingsSet.h"
#import "BrandCategoryNoUtil.h"
#import "PlugsCtrlTitleHeader.h"
#import "VRemoteVideoSet.h"

@interface EngineerRemoteVideoViewCtrl () <CustomPickerViewDelegate>{
    UIButton *_luboBtn;
    UIButton *_tanchuBtn;
    UIButton *_addressBtn;
    UIButton *_yuanchengBtn;
    
    UILabel *_telephoneNumberL;
    
    UIButton *_backWorkdBtn;
    NSMutableArray *_cameraBtnArray;
    
    BOOL isSettings;
    UIButton *okBtn;
}

@end

@implementation EngineerRemoteVideoViewCtrl
@synthesize _cameraArray;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_cameraArray count]) {
        self._currentObj = [_cameraArray objectAtIndex:0];
    }
    
    if (_currentObj == nil) {
        self._currentObj = [[VRemoteSettingsSet alloc] init];
    }
    
    [super setTitleAndImage:@"video_corner_yuancheng.png" withTitle:@"远程视讯"];
    
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
    
    _luboBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _luboBtn.frame = CGRectMake(70, SCREEN_HEIGHT-140, 60, 60);
    _luboBtn.layer.cornerRadius = 5;
    _luboBtn.layer.borderWidth = 2;
    _luboBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _luboBtn.clipsToBounds = YES;
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_remote_video_n.png"] forState:UIControlStateNormal];
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_remote_video_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_luboBtn];
    
    [_luboBtn addTarget:self
                 action:@selector(luboAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    _tanchuBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _tanchuBtn.frame = CGRectMake(150, SCREEN_HEIGHT-140, 60, 60);
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
    
    _addressBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _addressBtn.frame = CGRectMake(230, SCREEN_HEIGHT-140, 60, 60);
    _addressBtn.layer.cornerRadius = 5;
    _addressBtn.layer.borderWidth = 2;
    _addressBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _addressBtn.clipsToBounds = YES;
    [_addressBtn setImage:[UIImage imageNamed:@"engineer_remote_tv_n.png"] forState:UIControlStateNormal];
    [_addressBtn setImage:[UIImage imageNamed:@"engineer_remote_tv_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_addressBtn];
    
    [_addressBtn addTarget:self
                    action:@selector(addressAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    _yuanchengBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _yuanchengBtn.frame = CGRectMake(310, SCREEN_HEIGHT-140, 60, 60);
    _yuanchengBtn.layer.cornerRadius = 5;
    _yuanchengBtn.layer.borderWidth = 2;
    _yuanchengBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _yuanchengBtn.clipsToBounds = YES;
    [_yuanchengBtn setImage:[UIImage imageNamed:@"engineer_remote_pepole_n.png"] forState:UIControlStateNormal];
    [_yuanchengBtn setImage:[UIImage imageNamed:@"engineer_remote_pepole_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_yuanchengBtn];
    
    [_yuanchengBtn addTarget:self
                    action:@selector(yuanchengAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    int labelHeight = SCREEN_HEIGHT - 620;
    int leftSpace = 200;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, labelHeight, 190, 33)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"拨号";
    
    UIImageView *textBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"engineer_remote_tx.png"]];
    [self.view addSubview:textBGView];
    textBGView.frame = CGRectMake(leftSpace, labelHeight+40, 190, 33);
    
    _telephoneNumberL = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+5, labelHeight+40, 180, 33)];
    _telephoneNumberL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_telephoneNumberL];
    _telephoneNumberL.font = [UIFont boldSystemFontOfSize:16];
    _telephoneNumberL.textColor  = [UIColor whiteColor];
    _telephoneNumberL.text = @"";
    
    _backWorkdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backWorkdBtn.frame = CGRectMake(leftSpace + 190 - 32, labelHeight+40, 32, 32);
    [_backWorkdBtn setImage:[UIImage imageNamed:@"engineer_backWord_n.png"] forState:UIControlStateNormal];
    [_backWorkdBtn setImage:[UIImage imageNamed:@"engineer_backWord_s.png"] forState:UIControlStateHighlighted];
    [_backWorkdBtn addTarget:self action:@selector(backWordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backWorkdBtn];
    
    labelHeight+=40;
    
    UIButton *dialPhoneBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    dialPhoneBtn.frame = CGRectMake(leftSpace, labelHeight+60, 60, 60);
    dialPhoneBtn.layer.cornerRadius = 5;
    dialPhoneBtn.layer.borderWidth = 2;
    dialPhoneBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    dialPhoneBtn.clipsToBounds = YES;
    [dialPhoneBtn setImage:[UIImage imageNamed:@"engineer_dial_phone_n.png"] forState:UIControlStateNormal];
    [dialPhoneBtn setImage:[UIImage imageNamed:@"engineer_dial_phone_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:dialPhoneBtn];
    
    [dialPhoneBtn addTarget:self
                     action:@selector(dialPHoneAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mutePhoneBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    mutePhoneBtn.frame = CGRectMake(leftSpace+65, labelHeight+60, 60, 60);
    mutePhoneBtn.layer.cornerRadius = 5;
    mutePhoneBtn.layer.borderWidth = 2;
    mutePhoneBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    mutePhoneBtn.clipsToBounds = YES;
    [mutePhoneBtn setImage:[UIImage imageNamed:@"engineer_mute_n.png"] forState:UIControlStateNormal];
    [mutePhoneBtn setImage:[UIImage imageNamed:@"engineer_mute_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:mutePhoneBtn];
    
    [mutePhoneBtn addTarget:self
                     action:@selector(mutePHoneAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hangPhoneBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    hangPhoneBtn.frame = CGRectMake(leftSpace+130, labelHeight+60, 60, 60);
    hangPhoneBtn.layer.cornerRadius = 5;
    hangPhoneBtn.layer.borderWidth = 2;
    hangPhoneBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    hangPhoneBtn.clipsToBounds = YES;
    [hangPhoneBtn setImage:[UIImage imageNamed:@"engineer_hangphone_n.png"] forState:UIControlStateNormal];
    [hangPhoneBtn setImage:[UIImage imageNamed:@"engineer_hangphone_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:hangPhoneBtn];
    
    [hangPhoneBtn addTarget:self
                     action:@selector(hangPHoneAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone1Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone1Btn.frame = CGRectMake(leftSpace, labelHeight+60+65, 60, 60);
    phone1Btn.layer.cornerRadius = 5;
    phone1Btn.layer.borderWidth = 2;
    phone1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone1Btn.clipsToBounds = YES;
    [phone1Btn setTitle:@"1" forState:UIControlStateNormal];
    [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone1Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone1Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone1Btn];
    [phone1Btn addTarget:self
                  action:@selector(phone1Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone2Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone2Btn.frame = CGRectMake(leftSpace+65, labelHeight+60+65, 60, 60);
    phone2Btn.layer.cornerRadius = 5;
    phone2Btn.layer.borderWidth = 2;
    phone2Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone2Btn.clipsToBounds = YES;
    [phone2Btn setTitle:@"2" forState:UIControlStateNormal];
    [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone2Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone2Btn];
    [phone2Btn addTarget:self
                  action:@selector(phone2Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone3Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone3Btn.frame = CGRectMake(leftSpace+65+65, labelHeight+60+65, 60, 60);
    phone3Btn.layer.cornerRadius = 5;
    phone3Btn.layer.borderWidth = 2;
    phone3Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone3Btn.clipsToBounds = YES;
    [phone3Btn setTitle:@"3" forState:UIControlStateNormal];
    [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone3Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone3Btn];
    [phone3Btn addTarget:self
                  action:@selector(phone3Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone4Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone4Btn.frame = CGRectMake(leftSpace, labelHeight+60+65+65, 60, 60);
    phone4Btn.layer.cornerRadius = 5;
    phone4Btn.layer.borderWidth = 2;
    phone4Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone4Btn.clipsToBounds = YES;
    [phone4Btn setTitle:@"4" forState:UIControlStateNormal];
    [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone4Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone4Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone4Btn];
    [phone4Btn addTarget:self
                  action:@selector(phone4Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone5Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone5Btn.frame = CGRectMake(leftSpace+65, labelHeight+60+65+65, 60, 60);
    phone5Btn.layer.cornerRadius = 5;
    phone5Btn.layer.borderWidth = 2;
    phone5Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone5Btn.clipsToBounds = YES;
    [phone5Btn setTitle:@"5" forState:UIControlStateNormal];
    [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone5Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone5Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone5Btn];
    [phone5Btn addTarget:self
                  action:@selector(phone5Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone6Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone6Btn.frame = CGRectMake(leftSpace+65+65, labelHeight+60+65+65, 60, 60);
    phone6Btn.layer.cornerRadius = 5;
    phone6Btn.layer.borderWidth = 2;
    phone6Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone6Btn.clipsToBounds = YES;
    [phone6Btn setTitle:@"6" forState:UIControlStateNormal];
    [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone6Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone6Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone6Btn];
    [phone6Btn addTarget:self
                  action:@selector(phone6Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone7Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone7Btn.frame = CGRectMake(leftSpace, labelHeight+60+65+65+65, 60, 60);
    phone7Btn.layer.cornerRadius = 5;
    phone7Btn.layer.borderWidth = 2;
    phone7Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone7Btn.clipsToBounds = YES;
    [phone7Btn setTitle:@"7" forState:UIControlStateNormal];
    [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone7Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone7Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone7Btn];
    [phone7Btn addTarget:self
                  action:@selector(phone7Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone8Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone8Btn.frame = CGRectMake(leftSpace+65, labelHeight+60+65+65+65, 60, 60);
    phone8Btn.layer.cornerRadius = 5;
    phone8Btn.layer.borderWidth = 2;
    phone8Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone8Btn.clipsToBounds = YES;
    [phone8Btn setTitle:@"8" forState:UIControlStateNormal];
    [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone8Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone8Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone8Btn];
    [phone8Btn addTarget:self
                  action:@selector(phone8Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone9Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone9Btn.frame = CGRectMake(leftSpace+65+65, labelHeight+60+65+65+65, 60, 60);
    phone9Btn.layer.cornerRadius = 5;
    phone9Btn.layer.borderWidth = 2;
    phone9Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone9Btn.clipsToBounds = YES;
    [phone9Btn setTitle:@"9" forState:UIControlStateNormal];
    [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone9Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone9Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone9Btn];
    [phone9Btn addTarget:self
                  action:@selector(phone9Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phonedotBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phonedotBtn.frame = CGRectMake(leftSpace, labelHeight+60+65+65+65+65, 60, 60);
    phonedotBtn.layer.cornerRadius = 5;
    phonedotBtn.layer.borderWidth = 2;
    phonedotBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    phonedotBtn.clipsToBounds = YES;
    [phonedotBtn setTitle:@"." forState:UIControlStateNormal];
    [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phonedotBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phonedotBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phonedotBtn];
    [phonedotBtn addTarget:self
                    action:@selector(phonedotAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone0Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phone0Btn.frame = CGRectMake(leftSpace+65, labelHeight+60+65+65+65+65, 60, 60);
    phone0Btn.layer.cornerRadius = 5;
    phone0Btn.layer.borderWidth = 2;
    phone0Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone0Btn.clipsToBounds = YES;
    [phone0Btn setTitle:@"0" forState:UIControlStateNormal];
    [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone0Btn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phone0Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone0Btn];
    [phone0Btn addTarget:self
                  action:@selector(phone0Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phoneStarBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    phoneStarBtn.frame = CGRectMake(leftSpace+65+65, labelHeight+60+65+65+65+65, 60, 60);
    phoneStarBtn.layer.cornerRadius = 5;
    phoneStarBtn.layer.borderWidth = 2;
    phoneStarBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    phoneStarBtn.clipsToBounds = YES;
    [phoneStarBtn setTitle:@"#" forState:UIControlStateNormal];
    [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneStarBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    phoneStarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phoneStarBtn];
    [phoneStarBtn addTarget:self
                     action:@selector(phoneStarAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    labelHeight = SCREEN_HEIGHT - 620;
    leftSpace-=50;
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+450, labelHeight, 250, 33)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = video_camera_name;
    
    int cellHeight = 60;
    int space = 5;
    int leftRight = leftSpace+150+250;
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight+50, labelHeight+40, 255+135, 70)];
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    int viewWidth = (int) [_currentObj._cameraVideoArray count] * 65;
    scroolView.contentSize = CGSizeMake(viewWidth, 65);
    int index = 0;
    
    for (VRemoteVideoSet *vSet in _currentObj._cameraVideoArray) {
        int startX = index*cellHeight+index*space;
        
        UIButton *cameraBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
        cameraBtn.frame = CGRectMake(startX, 5, cellHeight, cellHeight);
        cameraBtn.layer.cornerRadius = 5;
        cameraBtn.layer.borderWidth = 2;
        cameraBtn.tag = index;
        cameraBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        cameraBtn.clipsToBounds = YES;
        [cameraBtn setTitle:vSet._name forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cameraBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [scroolView addSubview:cameraBtn];
        [cameraBtn addTarget:self
                      action:@selector(cameraBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [_cameraBtnArray addObject:cameraBtn];
        
        index++;
    }
    
    int playerLeft = 405;
    int playerHeight = 100;
    
    UIButton *lastVideoUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    lastVideoUpBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 60, 60);
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
    okPlayerBtn.frame = CGRectMake(295+playerLeft, SCREEN_HEIGHT-500+playerHeight, 60, 60);
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
    volumnUpBtn.frame = CGRectMake(295+playerLeft, SCREEN_HEIGHT-565+playerHeight, 60, 60);
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
    nextPlayBtn.frame = CGRectMake(360+playerLeft, SCREEN_HEIGHT-500+playerHeight, 60, 60);
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
    volumnDownBtn.frame = CGRectMake(295+playerLeft, SCREEN_HEIGHT-435+playerHeight, 60, 60);
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
- (void) cameraBtnAction:(id) sender {
    UIButton *btn = (UIButton*) sender;
    int tag = (int) btn.tag;
    for (UIButton *button in _cameraBtnArray) {
        if (button.tag == tag) {
            [button setTitleColor:RGB(255, 180, 0) forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
- (void) phoneStarAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"#"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone0Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"0"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phonedotAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"."];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone9Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"9"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone8Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"8"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone7Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"7"];
    
    _telephoneNumberL.text = newTextStr;
}

- (void) phone6Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"6"];
    
    _telephoneNumberL.text = newTextStr;
}

- (void) phone5Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"5"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone4Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"4"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone3Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"3"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone2Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"2"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone1Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"1"];
    
    _telephoneNumberL.text = newTextStr;
}

- (void) hangPHoneAction:(id)sender{
    
}

- (void) mutePHoneAction:(id)sender{
    
}

- (void) dialPHoneAction:(id)sender{
    
}

- (void) backWordAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    if (textStr && [textStr length] > 0) {
        NSString *backStr = [textStr substringToIndex:[textStr length]-1];
        _telephoneNumberL.text = backStr;
    }
}
- (void) luboAction:(id)sender{
}

- (void) tanchuAction:(id)sender{
    
}
- (void) addressAction:(id)sender{
    
}
- (void) yuanchengAction:(id)sender{
    
}

- (void) settingsAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
