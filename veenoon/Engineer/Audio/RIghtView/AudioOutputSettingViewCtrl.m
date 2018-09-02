//
//  AudioOutputSettingViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioOutputSettingViewCtrl.h"
#import "UIButton+Color.h"
#import "XinHaoFaShengQi_UIView.h"
#import "DianPing_UIView.h"
#import "LvBoJunHeng_UIView.h"
#import "YaXianQi_UIView.h"
#import "YanShiQi_UIView.h"
#import "AudioEProcessor.h"

@interface AudioOutputSettingViewCtrl () {
    
    XinHaoFaShengQi_UIView *xinhaoView;
    UIButton *xinhaofashengqiBtn;
    
    DianPing_UIView *dianpingView;
    UIButton *dianpingBtn;
    
    LvBoJunHeng_UIView *lvbojunhengView;
    UIButton *lvbojunhengBtn;
    
    YaXianQi_UIView *yaxianView;
    UIButton *yaxianBtn;
    
    YanShiQi_UIView *yanshiView;
    UIButton *yanshiqiBtn;
    
    UIButton *_curSelectBtn;
}

@end

@implementation AudioOutputSettingViewCtrl
@synthesize _processor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleAndImage:@"audio_corner_yinpinchuli.png" withTitle:@"音频处理器"];
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int startX = 60;
    int startY = 100;
    int gap = 10;
    int bw = 80;
    int bh = 30;
    
    xinhaofashengqiBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    _curSelectBtn = xinhaofashengqiBtn;
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    xinhaofashengqiBtn.frame = CGRectMake(startX, startY, bw, bh);
    xinhaofashengqiBtn.clipsToBounds = YES;
    xinhaofashengqiBtn.layer.cornerRadius = 5;
    xinhaofashengqiBtn.layer.borderWidth = 2;
    xinhaofashengqiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    xinhaofashengqiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [xinhaofashengqiBtn setTitle:@"信号发生器" forState:UIControlStateNormal];
    [xinhaofashengqiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [xinhaofashengqiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:xinhaofashengqiBtn];
    [xinhaofashengqiBtn addTarget:self
                  action:@selector(xinhaofashengqiAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    dianpingBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    dianpingBtn.frame = CGRectMake(CGRectGetMaxX(xinhaofashengqiBtn.frame) + gap, startY, bw, bh);
    dianpingBtn.clipsToBounds = YES;
    dianpingBtn.layer.cornerRadius = 5;
    dianpingBtn.layer.borderWidth = 2;
    dianpingBtn.layer.borderColor = [UIColor clearColor].CGColor;
    dianpingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dianpingBtn setTitle:@"电平" forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:dianpingBtn];
    [dianpingBtn addTarget:self
                       action:@selector(dianpingAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    lvbojunhengBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    lvbojunhengBtn.frame = CGRectMake(CGRectGetMaxX(dianpingBtn.frame) + gap, startY, bw, bh);
    lvbojunhengBtn.clipsToBounds = YES;
    lvbojunhengBtn.layer.cornerRadius = 5;
    lvbojunhengBtn.layer.borderWidth = 2;
    lvbojunhengBtn.layer.borderColor = [UIColor clearColor].CGColor;
    lvbojunhengBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lvbojunhengBtn setTitle:@"滤波/均衡" forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:lvbojunhengBtn];
    [lvbojunhengBtn addTarget:self
                       action:@selector(lvbojunhengAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    yaxianBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    yaxianBtn.frame = CGRectMake(CGRectGetMaxX(lvbojunhengBtn.frame) + gap, startY, bw, bh);
    yaxianBtn.clipsToBounds = YES;
    yaxianBtn.layer.cornerRadius = 5;
    yaxianBtn.layer.borderWidth = 2;
    yaxianBtn.layer.borderColor = [UIColor clearColor].CGColor;
    yaxianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [yaxianBtn setTitle:@"压限器" forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:yaxianBtn];
    [yaxianBtn addTarget:self
                  action:@selector(yaxianqiAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    yanshiqiBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    yanshiqiBtn.frame = CGRectMake(CGRectGetMaxX(yaxianBtn.frame) + gap, startY, bw, bh);
    yanshiqiBtn.clipsToBounds = YES;
    yanshiqiBtn.layer.cornerRadius = 5;
    yanshiqiBtn.layer.borderWidth = 2;
    yanshiqiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    yanshiqiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [yanshiqiBtn setTitle:@"延时器" forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:yanshiqiBtn];
    [yanshiqiBtn addTarget:self
                    action:@selector(yanshiqiAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    int numProxys = (int)[_processor._outAudioProxys count];
    
    CGRect vrc = CGRectMake(60, 140, SCREEN_WIDTH-120, SCREEN_HEIGHT-140-60);
    xinhaoView = [[XinHaoFaShengQi_UIView alloc] initWithFrameProxy:vrc withAudio:_processor withProxy:self._processor._singalProxy];
    [self.view addSubview:xinhaoView];
    xinhaoView.hidden = NO;
    
    [xinhaoView updateProxyCommandValIsLoaded];
    xinhaoView._proxys = _processor._outAudioProxys;
    [xinhaoView layoutChannelBtns:numProxys selectedIndex:-1];
    
    dianpingView = [[DianPing_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._outAudioProxys];
    [self.view addSubview:dianpingView];
    dianpingView.hidden = YES;
    
    dianpingView._proxys = _processor._outAudioProxys;
    [dianpingView layoutChannelBtns:numProxys selectedIndex:0];
    
    lvbojunhengView = [[LvBoJunHeng_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._outAudioProxys];
    [self.view addSubview:lvbojunhengView];
    lvbojunhengView.hidden = YES;
    
    lvbojunhengView._proxys = _processor._outAudioProxys;
    [lvbojunhengView layoutChannelBtns:numProxys selectedIndex:0];
    
    yaxianView = [[YaXianQi_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._outAudioProxys];
    [self.view addSubview:yaxianView];
    yaxianView.hidden = YES;
    
    yaxianView._proxys = _processor._outAudioProxys;
    [yaxianView layoutChannelBtns:numProxys selectedIndex:0];
    
    yanshiView = [[YanShiQi_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._outAudioProxys];
    [self.view addSubview:yanshiView];
    yanshiView.hidden = YES;
    
    yanshiView._proxys = _processor._outAudioProxys;
    [yanshiView layoutChannelBtns:numProxys selectedIndex:0];
}
- (void) yanshiqiAction:(UIButton*)sender{
    [xinhaofashengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    _curSelectBtn = sender;
    
    xinhaoView.hidden=YES;
    yanshiView.hidden = NO;
    yaxianView.hidden = YES;
    lvbojunhengView.hidden = YES;
    dianpingView.hidden = YES;
    
    [yanshiView updateProxyCommandValIsLoaded];
}
- (void) yaxianqiAction:(UIButton*)sender{
    [xinhaofashengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    _curSelectBtn = sender;
    
    xinhaoView.hidden=YES;
    yanshiView.hidden = YES;
    yaxianView.hidden = NO;
    lvbojunhengView.hidden = YES;
    dianpingView.hidden = YES;
    
    [yaxianView updateProxyCommandValIsLoaded];
}
- (void) lvbojunhengAction:(UIButton*)sender{
    [xinhaofashengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    _curSelectBtn = sender;
    
    xinhaoView.hidden=YES;
    yanshiView.hidden = YES;
    yaxianView.hidden = YES;
    lvbojunhengView.hidden = NO;
    dianpingView.hidden = YES;
    
    [lvbojunhengView updateProxyCommandValIsLoaded];
}
- (void) dianpingAction:(UIButton*)sender{
    
    [xinhaofashengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    _curSelectBtn = sender;
    
    xinhaoView.hidden=YES;
    yanshiView.hidden = YES;
    yaxianView.hidden = YES;
    lvbojunhengView.hidden = YES;
    dianpingView.hidden = NO;
    
    [dianpingView updateProxyCommandValIsLoaded];
}
- (void) xinhaofashengqiAction:(UIButton*)sender{
    
    [xinhaofashengqiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dianpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    _curSelectBtn = sender;
    
    xinhaoView.hidden=NO;
    yanshiView.hidden = YES;
    yaxianView.hidden = YES;
    lvbojunhengView.hidden = YES;
    dianpingView.hidden = YES;
    
    [xinhaoView updateProxyCommandValIsLoaded];
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
