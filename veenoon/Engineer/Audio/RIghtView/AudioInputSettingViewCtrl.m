//
//  AudioInputSettingViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioInputSettingViewCtrl.h"
#import "UIButton+Color.h"
#import "YaXianQi_UIView.h"
#import "ZengYi_UIView.h"
#import "ZaoShengMen_UIView.h"
#import "YanShiQi_UIView.h"
#import "HuiShengXiaoChu_UIView.h"
#import "LvBoJunHeng_UIView.h"
#import "YinPinProcessCodeUIView.h"
#import "ZiDongHunYin_UIView.h"
#import "AudioEProcessor.h"
#import "FanKuiYiZhiView.h"

@interface AudioInputSettingViewCtrl () <HuiShengXiaoChu_UIViewDelegate> {
    YaXianQi_UIView *yxq;
    ZengYi_UIView *zengyiView;
    ZaoShengMen_UIView *zaoshengView;
    YanShiQi_UIView *yanshiView;
    HuiShengXiaoChu_UIView *huishengView;
    ZiDongHunYin_UIView *zidonghunyinView;
    FanKuiYiZhiView *fankuiyizhiView;
    LvBoJunHeng_UIView *lvbo;
    
    UIButton *zengyiBtn;
    UIButton *yaxianBtn;
    UIButton *zaoshengmenBtn;
    UIButton *yanshiqiBtn;
    UIButton *huishengxiaochuBtn;
    UIButton *lvbojunhengBtn;
    UIButton *zidonghunyinBtn;
    UIButton *fankuiyizhiBtn;
}
@property (nonatomic, strong) UIButton *_curSelectBtn;

@end

@implementation AudioInputSettingViewCtrl
@synthesize _curSelectBtn;
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
//    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int startX = 60;
    int startY = 100;
    int gap = 10;
    int bw = 80;
    int bh = 30;
    
    zengyiBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    zengyiBtn.frame = CGRectMake(startX, startY, bw, bh);
    zengyiBtn.clipsToBounds = YES;
    zengyiBtn.layer.cornerRadius = 5;
    self._curSelectBtn = zengyiBtn;
    zengyiBtn.layer.borderWidth = 2;
    zengyiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zengyiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zengyiBtn setTitle:@"增益" forState:UIControlStateNormal];
    [zengyiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [zengyiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zengyiBtn];
    [zengyiBtn addTarget:self
                    action:@selector(zengyiAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    zaoshengmenBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    zaoshengmenBtn.frame = CGRectMake(CGRectGetMaxX(zengyiBtn.frame) + gap, startY, bw, bh);
    zaoshengmenBtn.clipsToBounds = YES;
    zaoshengmenBtn.layer.cornerRadius = 5;
    zaoshengmenBtn.layer.borderWidth = 2;
    zaoshengmenBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zaoshengmenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zaoshengmenBtn setTitle:@"噪声门" forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zaoshengmenBtn];
    [zaoshengmenBtn addTarget:self
                  action:@selector(zaoshengmenAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    lvbojunhengBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    lvbojunhengBtn.frame = CGRectMake(CGRectGetMaxX(zaoshengmenBtn.frame) + gap, startY, bw, bh);
    lvbojunhengBtn.clipsToBounds = YES;
    lvbojunhengBtn.layer.cornerRadius = 5;
    lvbojunhengBtn.layer.borderWidth = 2;
    lvbojunhengBtn.layer.borderColor = [UIColor clearColor].CGColor;
    lvbojunhengBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lvbojunhengBtn setTitle:@"滤波/均衡" forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
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
    [yaxianBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
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
    [yanshiqiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:yanshiqiBtn];
    [yanshiqiBtn addTarget:self
                       action:@selector(yanshiqiAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    huishengxiaochuBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    huishengxiaochuBtn.frame = CGRectMake(CGRectGetMaxX(yanshiqiBtn.frame) + gap, startY, bw, bh);
    huishengxiaochuBtn.clipsToBounds = YES;
    huishengxiaochuBtn.layer.cornerRadius = 5;
    huishengxiaochuBtn.layer.borderWidth = 2;
    huishengxiaochuBtn.layer.borderColor = [UIColor clearColor].CGColor;
    huishengxiaochuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [huishengxiaochuBtn setTitle:@"回声消除" forState:UIControlStateNormal];
    [huishengxiaochuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [huishengxiaochuBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:huishengxiaochuBtn];
    [huishengxiaochuBtn addTarget:self
                       action:@selector(huishengxiaochuAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    zidonghunyinBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    zidonghunyinBtn.frame = CGRectMake(CGRectGetMaxX(huishengxiaochuBtn.frame) + gap, startY, bw, bh);
    zidonghunyinBtn.clipsToBounds = YES;
    zidonghunyinBtn.layer.cornerRadius = 5;
    zidonghunyinBtn.layer.borderWidth = 2;
    zidonghunyinBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zidonghunyinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zidonghunyinBtn setTitle:@"自动混音" forState:UIControlStateNormal];
    [zidonghunyinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zidonghunyinBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zidonghunyinBtn];
    [zidonghunyinBtn addTarget:self
                       action:@selector(zidonghunyinAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    fankuiyizhiBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    fankuiyizhiBtn.frame = CGRectMake(CGRectGetMaxX(zidonghunyinBtn.frame) + gap, startY, bw, bh);
    fankuiyizhiBtn.clipsToBounds = YES;
    fankuiyizhiBtn.layer.cornerRadius = 5;
    fankuiyizhiBtn.layer.borderWidth = 2;
    fankuiyizhiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    fankuiyizhiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fankuiyizhiBtn setTitle:@"反馈抑制" forState:UIControlStateNormal];
    [fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fankuiyizhiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:fankuiyizhiBtn];
    [fankuiyizhiBtn addTarget:self
                        action:@selector(fankuiyizhiAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect vrc = CGRectMake(60, 140, SCREEN_WIDTH-120, SCREEN_HEIGHT-140-60);
    int numProxys = (int)[_processor._inAudioProxys count];
    
    zengyiView = [[ZengYi_UIView alloc] initWithFrame:vrc withProxy:_processor._inAudioProxys];
    [self.view addSubview:zengyiView];
    zengyiView.hidden = NO;
    zengyiView.ctrl = self;
    [zengyiView updateProxyCommandValIsLoaded];
    zengyiView._proxys = _processor._inAudioProxys;
    [zengyiView layoutChannelBtns:numProxys selectedIndex:0];

    zaoshengView = [[ZaoShengMen_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._inAudioProxys];
    [self.view addSubview:zaoshengView];
    zaoshengView.hidden = YES;
    zaoshengView.ctrl = self;
    zaoshengView._proxys = _processor._inAudioProxys;
    [zaoshengView layoutChannelBtns:numProxys selectedIndex:0];
    
    yanshiView = [[YanShiQi_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._inAudioProxys];
    [self.view addSubview:yanshiView];
    yanshiView.hidden = YES;
    yanshiView.ctrl = self;
    yanshiView._proxys = _processor._inAudioProxys;
    [yanshiView layoutChannelBtns:numProxys selectedIndex:0];
    
    lvbo = [[LvBoJunHeng_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._inAudioProxys];
    [self.view addSubview:lvbo];
    lvbo.hidden = YES;
    lvbo.ctrl = self;
    lvbo._proxys = _processor._inAudioProxys;
    [lvbo layoutChannelBtns:numProxys selectedIndex:0];
    
    huishengView = [[HuiShengXiaoChu_UIView alloc] initWithFrameProxys:vrc withProxys:_processor];
    huishengView.delegate_ = self;
    [self.view addSubview:huishengView];
    huishengView.hidden = YES;
    
    yxq = [[YaXianQi_UIView alloc] initWithFrameProxys:vrc withProxys:_processor._inAudioProxys];
    [self.view addSubview:yxq];
    yxq.hidden = YES;
    yxq.ctrl = self;
    yxq._proxys = _processor._inAudioProxys;
    [yxq layoutChannelBtns:numProxys selectedIndex:0];
    
    zidonghunyinView = [[ZiDongHunYin_UIView alloc] initWithFrameProxy:vrc withAudio:_processor withProxy:_processor._autoMixProxy];
    [self.view addSubview:zidonghunyinView];
    zidonghunyinView.hidden = YES;
    
    fankuiyizhiView = [[FanKuiYiZhiView alloc] initWithFrameProxys:vrc withProxys:_processor._inAudioProxys];
    [self.view addSubview:fankuiyizhiView];
    fankuiyizhiView.hidden = YES;
    
    [fankuiyizhiView layoutChannelBtns:numProxys selectedIndex:0];
    
    self._curSelectBtn = zengyiBtn;
    [zengyiBtn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
}
- (void) zidonghunyinAction:(UIButton*)sender{
   
    if(_curSelectBtn == sender)
    {
        return;
    }

    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden = YES;
    zidonghunyinView.hidden=NO;
    fankuiyizhiView.hidden=YES;
    
    [zidonghunyinView updateProxyCommandValIsLoaded];
}

- (void) fankuiyizhiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden = YES;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=NO;
    
    [fankuiyizhiView updateProxyCommandValIsLoaded];
}

- (void) huishengxiaochuAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = NO;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=YES;
    
    
    [huishengView updateProxyCommandValIsLoaded];
}
- (void) yanshiqiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = NO;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=YES;
    
    [yanshiView updateProxyCommandValIsLoaded];
}
- (void) yaxianqiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = NO;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=YES;
    
    //将插件数据匹配到UI控件
    [yxq updateProxyCommandValIsLoaded];
    
}
- (void) lvbojunhengAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=NO;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=YES;
    
    
    [lvbo updateProxyCommandValIsLoaded];
}
- (void) zaoshengmenAction:(UIButton*)sender{
   
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = NO;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=YES;
    
    [zaoshengView updateProxyCommandValIsLoaded];
}
- (void) zengyiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = NO;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
    fankuiyizhiView.hidden=YES;
    
}
- (void) didAecButtonAction {
    YinPinProcessCodeUIView *uiView = [[YinPinProcessCodeUIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:uiView];
}
- (void) okAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
