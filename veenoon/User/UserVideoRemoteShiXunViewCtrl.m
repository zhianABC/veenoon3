//
//  UserVideoDVDDiskViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/30.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoRemoteShiXunViewCtrl.h"
#import "UIButton+Color.h"

@interface UserVideoRemoteShiXunViewCtrl () {
    UILabel *_telephoneNumberL;
    
    UIButton *_backWorkdBtn;
}
@property (nonatomic, strong) NSMutableArray *_cameraArray;
@property (nonatomic, strong) NSMutableArray *_cameraBtnArray;
@end

@implementation UserVideoRemoteShiXunViewCtrl
@synthesize _cameraArray;
@synthesize _cameraBtnArray;

- (void) initData {
    if (_cameraArray) {
        [_cameraArray removeAllObjects];
    } else {
        
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"name",
                                    nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2", @"name",
                                    nil];
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3", @"name",
                                    nil];
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4", @"name",
                                    nil];
        self._cameraArray = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    if (_cameraBtnArray) {
        [_cameraBtnArray removeAllObjects];
    } else {
        _cameraBtnArray = [[NSMutableArray alloc] init];
    }
    
    [super setTitleAndImage:@"user_corner_remote.png" withTitle:@"远程视讯会议"];
    
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
    
    int labelHeight = SCREEN_HEIGHT - 670;
    int leftSpace = 200;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, labelHeight, 250, 33)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"拨号";
    
    UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+150+250, labelHeight, 255, 33)];
    titleL2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL2];
    titleL2.font = [UIFont boldSystemFontOfSize:16];
    titleL2.textColor  = [UIColor whiteColor];
    titleL2.textAlignment=NSTextAlignmentCenter;
    titleL2.text = video_camera_name;
    
    UIImageView *textBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remote_video_filed_bg.png"]];
    [self.view addSubview:textBGView];
    textBGView.frame = CGRectMake(leftSpace, labelHeight+40, 250, 33);
    
    _telephoneNumberL = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+5, labelHeight+40, 240, 33)];
    _telephoneNumberL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_telephoneNumberL];
    _telephoneNumberL.font = [UIFont boldSystemFontOfSize:16];
    _telephoneNumberL.textColor  = [UIColor whiteColor];
    _telephoneNumberL.text = @"";
    
    _backWorkdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backWorkdBtn.frame = CGRectMake(leftSpace + 250 - 32, labelHeight+40, 32, 32);
    [_backWorkdBtn setImage:[UIImage imageNamed:@"remote_video_back_n.png"] forState:UIControlStateNormal];
    [_backWorkdBtn setImage:[UIImage imageNamed:@"remote_video_back_s.png"] forState:UIControlStateHighlighted];
    [_backWorkdBtn addTarget:self action:@selector(backWordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backWorkdBtn];
    
    UIButton *dialPhoneBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    dialPhoneBtn.frame = CGRectMake(leftSpace, labelHeight+80, 80, 80);
    dialPhoneBtn.layer.cornerRadius = 5;
    dialPhoneBtn.layer.borderWidth = 2;
    dialPhoneBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    dialPhoneBtn.clipsToBounds = YES;
    [dialPhoneBtn setImage:[UIImage imageNamed:@"remote_video_dialphone.png"] forState:UIControlStateNormal];
    [dialPhoneBtn setImage:[UIImage imageNamed:@"remote_video_dialphone.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:dialPhoneBtn];
    
    [dialPhoneBtn addTarget:self
                       action:@selector(dialPHoneAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mutePhoneBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    mutePhoneBtn.frame = CGRectMake(leftSpace+85, labelHeight+80, 80, 80);
    mutePhoneBtn.layer.cornerRadius = 5;
    mutePhoneBtn.layer.borderWidth = 2;
    mutePhoneBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    mutePhoneBtn.clipsToBounds = YES;
    [mutePhoneBtn setImage:[UIImage imageNamed:@"remote_video_mutephone.png"] forState:UIControlStateNormal];
    [mutePhoneBtn setImage:[UIImage imageNamed:@"remote_video_mutephone.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:mutePhoneBtn];
    
    [mutePhoneBtn addTarget:self
                     action:@selector(mutePHoneAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hangPhoneBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    hangPhoneBtn.frame = CGRectMake(leftSpace+170, labelHeight+80, 80, 80);
    hangPhoneBtn.layer.cornerRadius = 5;
    hangPhoneBtn.layer.borderWidth = 2;
    hangPhoneBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    hangPhoneBtn.clipsToBounds = YES;
    [hangPhoneBtn setImage:[UIImage imageNamed:@"remote_video_hangphone.png"] forState:UIControlStateNormal];
    [hangPhoneBtn setImage:[UIImage imageNamed:@"remote_video_hangphone.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:hangPhoneBtn];
    
    [hangPhoneBtn addTarget:self
                     action:@selector(hangPHoneAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone1Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone1Btn.frame = CGRectMake(leftSpace, labelHeight+80+85, 80, 80);
    phone1Btn.layer.cornerRadius = 5;
    phone1Btn.layer.borderWidth = 2;
    phone1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone1Btn.clipsToBounds = YES;
    [phone1Btn setTitle:@"1" forState:UIControlStateNormal];
    [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone1Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone1Btn];
    [phone1Btn addTarget:self
                     action:@selector(phone1Action:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone2Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone2Btn.frame = CGRectMake(leftSpace+85, labelHeight+80+85, 80, 80);
    phone2Btn.layer.cornerRadius = 5;
    phone2Btn.layer.borderWidth = 2;
    phone2Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone2Btn.clipsToBounds = YES;
    [phone2Btn setTitle:@"2" forState:UIControlStateNormal];
    [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone2Btn];
    [phone2Btn addTarget:self
                  action:@selector(phone2Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone3Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone3Btn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85, 80, 80);
    phone3Btn.layer.cornerRadius = 5;
    phone3Btn.layer.borderWidth = 2;
    phone3Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone3Btn.clipsToBounds = YES;
    [phone3Btn setTitle:@"3" forState:UIControlStateNormal];
    [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone3Btn];
    [phone3Btn addTarget:self
                  action:@selector(phone3Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone4Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone4Btn.frame = CGRectMake(leftSpace, labelHeight+80+85+85, 80, 80);
    phone4Btn.layer.cornerRadius = 5;
    phone4Btn.layer.borderWidth = 2;
    phone4Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone4Btn.clipsToBounds = YES;
    [phone4Btn setTitle:@"4" forState:UIControlStateNormal];
    [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone4Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone4Btn];
    [phone4Btn addTarget:self
                  action:@selector(phone4Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone5Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone5Btn.frame = CGRectMake(leftSpace+85, labelHeight+80+85+85, 80, 80);
    phone5Btn.layer.cornerRadius = 5;
    phone5Btn.layer.borderWidth = 2;
    phone5Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone5Btn.clipsToBounds = YES;
    [phone5Btn setTitle:@"5" forState:UIControlStateNormal];
    [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone5Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone5Btn];
    [phone5Btn addTarget:self
                  action:@selector(phone5Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone6Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone6Btn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85+85, 80, 80);
    phone6Btn.layer.cornerRadius = 5;
    phone6Btn.layer.borderWidth = 2;
    phone6Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone6Btn.clipsToBounds = YES;
    [phone6Btn setTitle:@"6" forState:UIControlStateNormal];
    [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone6Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone6Btn];
    [phone6Btn addTarget:self
                  action:@selector(phone6Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone7Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone7Btn.frame = CGRectMake(leftSpace, labelHeight+80+85+85+85, 80, 80);
    phone7Btn.layer.cornerRadius = 5;
    phone7Btn.layer.borderWidth = 2;
    phone7Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone7Btn.clipsToBounds = YES;
    [phone7Btn setTitle:@"7" forState:UIControlStateNormal];
    [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone7Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone7Btn];
    [phone7Btn addTarget:self
                  action:@selector(phone7Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone8Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone8Btn.frame = CGRectMake(leftSpace+85, labelHeight+80+85+85+85, 80, 80);
    phone8Btn.layer.cornerRadius = 5;
    phone8Btn.layer.borderWidth = 2;
    phone8Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone8Btn.clipsToBounds = YES;
    [phone8Btn setTitle:@"8" forState:UIControlStateNormal];
    [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone8Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone8Btn];
    [phone8Btn addTarget:self
                  action:@selector(phone8Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone9Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone9Btn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85+85+85, 80, 80);
    phone9Btn.layer.cornerRadius = 5;
    phone9Btn.layer.borderWidth = 2;
    phone9Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone9Btn.clipsToBounds = YES;
    [phone9Btn setTitle:@"9" forState:UIControlStateNormal];
    [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone9Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone9Btn];
    [phone9Btn addTarget:self
                  action:@selector(phone9Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phonedotBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phonedotBtn.frame = CGRectMake(leftSpace, labelHeight+80+85+85+85+85, 80, 80);
    phonedotBtn.layer.cornerRadius = 5;
    phonedotBtn.layer.borderWidth = 2;
    phonedotBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    phonedotBtn.clipsToBounds = YES;
    [phonedotBtn setTitle:@"." forState:UIControlStateNormal];
    [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phonedotBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phonedotBtn];
    [phonedotBtn addTarget:self
                  action:@selector(phonedotAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone0Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone0Btn.frame = CGRectMake(leftSpace+85, labelHeight+80+85+85+85+85, 80, 80);
    phone0Btn.layer.cornerRadius = 5;
    phone0Btn.layer.borderWidth = 2;
    phone0Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone0Btn.clipsToBounds = YES;
    [phone0Btn setTitle:@"0" forState:UIControlStateNormal];
    [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone0Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone0Btn];
    [phone0Btn addTarget:self
                    action:@selector(phone0Action:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phoneStarBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phoneStarBtn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85+85+85+85, 80, 80);
    phoneStarBtn.layer.cornerRadius = 5;
    phoneStarBtn.layer.borderWidth = 2;
    phoneStarBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    phoneStarBtn.clipsToBounds = YES;
    [phoneStarBtn setTitle:@"*" forState:UIControlStateNormal];
    [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phoneStarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phoneStarBtn];
    [phoneStarBtn addTarget:self
                  action:@selector(phoneStarAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *homeBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    homeBtn.frame = CGRectMake(100, SCREEN_HEIGHT-140, 50, 50);
    homeBtn.layer.cornerRadius = 5;
    homeBtn.layer.borderWidth = 2;
    homeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    homeBtn.clipsToBounds = YES;
    [homeBtn setImage:[UIImage imageNamed:@"remote_video_home.png"] forState:UIControlStateNormal];
    [homeBtn setImage:[UIImage imageNamed:@"remote_video_home.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:homeBtn];
    [homeBtn addTarget:self action:@selector(homeAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addressBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    addressBtn.frame = CGRectMake(100+55, SCREEN_HEIGHT-140, 50, 50);
    addressBtn.layer.cornerRadius = 5;
    addressBtn.layer.borderWidth = 2;
    addressBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    addressBtn.clipsToBounds = YES;
    [addressBtn setImage:[UIImage imageNamed:@"remote_video_address.png"] forState:UIControlStateNormal];
    [addressBtn setImage:[UIImage imageNamed:@"remote_video_address.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:addressBtn];
    [addressBtn addTarget:self action:@selector(addressAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mackBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    mackBtn.frame = CGRectMake(100+55+55, SCREEN_HEIGHT-140, 50, 50);
    mackBtn.layer.cornerRadius = 5;
    mackBtn.layer.borderWidth = 2;
    mackBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    mackBtn.clipsToBounds = YES;
    [mackBtn setImage:[UIImage imageNamed:@"remote_video_mack.png"] forState:UIControlStateNormal];
    [mackBtn setImage:[UIImage imageNamed:@"remote_video_mack.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:mackBtn];
    [mackBtn addTarget:self action:@selector(mackAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *anniuBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    anniuBtn.frame = CGRectMake(100+55+55+55, SCREEN_HEIGHT-140, 50, 50);
    anniuBtn.layer.cornerRadius = 5;
    anniuBtn.layer.borderWidth = 2;
    anniuBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    anniuBtn.clipsToBounds = YES;
    [anniuBtn setImage:[UIImage imageNamed:@"remote_video_ssss.png"] forState:UIControlStateNormal];
    [anniuBtn setImage:[UIImage imageNamed:@"remote_video_ssss.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:anniuBtn];
    [anniuBtn addTarget:self action:@selector(anniuAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    int cellHeight = 60;
    int space = 5;
    int leftRight = leftSpace+150+250;
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight, labelHeight+40, 255, 70)];
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    scroolView.contentSize = CGSizeMake(255, 70);
    int index = 0;
    for (id dic in _cameraArray) {
        int row = index/4;
        int col = index%4;
        int startX = col*cellHeight+col*space;
        int startY = row*cellHeight+space*row;
        
        UIButton *cameraBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
        cameraBtn.frame = CGRectMake(startX, startY, cellHeight, cellHeight);
        cameraBtn.layer.cornerRadius = 5;
        cameraBtn.layer.borderWidth = 2;
        cameraBtn.tag = index;
        cameraBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        cameraBtn.clipsToBounds = YES;
        [cameraBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [scroolView addSubview:cameraBtn];
        [cameraBtn addTarget:self
                      action:@selector(cameraBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [_cameraBtnArray addObject:cameraBtn];
        
        index++;
    }
    
    int playerLeft = 370;
    int playerHeight = 60;
    
    UIButton *lastVideoUpBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    lastVideoUpBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    lastVideoUpBtn.layer.cornerRadius = 5;
    lastVideoUpBtn.layer.borderWidth = 2;
    lastVideoUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lastVideoUpBtn.clipsToBounds = YES;
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"remote_video_left.png"] forState:UIControlStateNormal];
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"remote_video_left.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:lastVideoUpBtn];
    
    [lastVideoUpBtn addTarget:self
                       action:@selector(lastVideoUpBtnAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okPlayerBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    okPlayerBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    okPlayerBtn.layer.cornerRadius = 5;
    okPlayerBtn.layer.borderWidth = 2;
    okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    okPlayerBtn.clipsToBounds = YES;
    [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:okPlayerBtn];
    
    [okPlayerBtn addTarget:self action:@selector(okPlayerAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnUpBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    volumnUpBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    volumnUpBtn.layer.cornerRadius = 5;
    volumnUpBtn.layer.borderWidth = 2;
    volumnUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnUpBtn.clipsToBounds = YES;
    [volumnUpBtn setImage:[UIImage imageNamed:@"remote_video_up.png"] forState:UIControlStateNormal];
    [volumnUpBtn setImage:[UIImage imageNamed:@"remote_video_up.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnUpBtn];
    
    [volumnUpBtn addTarget:self
                    action:@selector(volumnUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextPlayBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    nextPlayBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    nextPlayBtn.layer.cornerRadius = 5;
    nextPlayBtn.layer.borderWidth = 2;
    nextPlayBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    nextPlayBtn.clipsToBounds = YES;
    [nextPlayBtn setImage:[UIImage imageNamed:@"remote_video_right.png"] forState:UIControlStateNormal];
    [nextPlayBtn setImage:[UIImage imageNamed:@"remote_video_right.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:nextPlayBtn];
    
    [nextPlayBtn addTarget:self
                    action:@selector(nextPlayBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnDownBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    volumnDownBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    volumnDownBtn.layer.cornerRadius = 5;
    volumnDownBtn.layer.borderWidth = 2;
    volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnDownBtn.clipsToBounds = YES;
    [volumnDownBtn setImage:[UIImage imageNamed:@"remote_video_down.png"] forState:UIControlStateNormal];
    [volumnDownBtn setImage:[UIImage imageNamed:@"remote_video_down.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnDownBtn];
    
    [volumnDownBtn addTarget:self
                      action:@selector(volumnDownAction:)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void) nextPlayBtnAction:(id)sender{
    
}
- (void) volumnDownAction:(id)sender{
    
}
- (void) volumnUpAction:(id)sender{
    
}
- (void) okPlayerAction:(id)sender{
    
}

- (void) lastVideoUpBtnAction:(id)sender{
    
}
- (void) cameraBtnAction:(id) sender {
    UIButton *btn = (UIButton*) sender;
    int tag = (int) btn.tag;
    btn.selected = YES;
    btn.highlighted = YES;
    for (UIButton *button in self._cameraBtnArray) {
        if (button.tag == tag) {
            continue;
        }
        button.selected = NO;
        button.highlighted = NO;
    }
}
- (void) homeAction:(id)sender{
    
}
- (void) addressAction:(id)sender{
    
}
- (void) mackAction:(id)sender{
    
}
- (void) anniuAction:(id)sender{
   
}
- (void) phoneStarAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"*"];
    
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
- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

