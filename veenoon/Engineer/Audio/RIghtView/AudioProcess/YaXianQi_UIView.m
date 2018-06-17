//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "YaXianQi_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "GradeLineView.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"
#import "veenoon-Swift.h"


@interface YaXianQi_UIView() <SlideButtonDelegate, VAProcessorProxysDelegate>
{
    UIButton *channelBtn;
    
    UILabel *lableL1;
    UILabel *lableL2;
    UILabel *lableL3;
    UILabel *lableL4;
    
    SlideButton *xielvSlide;
    SlideButton *qidongshijianSlide;
    SlideButton *huifushijianSlide;
    SlideButton *fazhiSlider;
    
    
    LimiterView *_limiter;
    
    int maxTh;
    int minTh;
    
    int minRadio;
    int maxRadio;
    
    int minStartDur;
    int maxStartDur;
    
    int minRecoveDur;
    int maxRecoveDur;
    
    UIButton  *_enableStartBtn;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end


@implementation YaXianQi_UIView
@synthesize _curProxy;
//@synthesize _channelBtns;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) dealloc
{
    _curProxy.delegate = nil;
}

- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys
{
    self._proxys = proxys;
    if(self = [super initWithFrame:frame])
    {
        if (self._curProxy == nil) {
            if (self._proxys) {
                self._curProxy = [self._proxys objectAtIndex:0];
            }
        }
        
        channelBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 70, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [channelBtn setTitle:_curProxy._rgsProxyObj.name forState:UIControlStateNormal];
        [channelBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [self addSubview:channelBtn];
    
        int y = CGRectGetMaxY(channelBtn.frame)+20;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
        
        maxTh = 0;
        minTh = -120;
        
        [self contentViewComps];
    }
    
    return self;
}

- (void) channelBtnAction:(UIButton*)sender{
    
    int idx = (int)sender.tag;
    int tag = idx + 1;
    
    [channelBtn setTitle:[NSString stringWithFormat:@"In %d", tag] forState:UIControlStateNormal];
    
    for(UIButton * btn in _channelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    self._curProxy = [self._proxys objectAtIndex:idx];
    
    NSString *name = _curProxy._rgsProxyObj.name;
    [channelBtn setTitle:name forState:UIControlStateNormal];
    
    [self updateProxyCommandValIsLoaded];
}

-(void) updateYaXianQi {
    
    NSString *zengyiDB = [_curProxy getYaxianFazhi];
    float value = [zengyiDB floatValue];
    float max = (maxTh - minTh);
    if(max)
    {
        float f = (value - minTh)/max;
        f = fabsf(f);
        [fazhiSlider setCircleValue:f];
    }
    
    [_limiter setThresHoldWithR:value];
    
    if (zengyiDB) {
        lableL1.text = [zengyiDB stringByAppendingString:@" dB"];
    }
    
    //////
    NSString *xielv = [_curProxy getYaxianXielv];
    float xielvValue = [xielv floatValue];
    
    float maxR = (maxRadio- minRadio);
    if(maxR)
    {
        float f = (xielvValue - minRadio)/maxR;
        f = fabsf(f);
        [xielvSlide setCircleValue:f];
    }
    
    [_limiter setRatioWithR:xielvValue];

    lableL2.text = xielv;
    
    
    NSString *startTime = [_curProxy getYaxianStartTime];
    float startTimeValue = [startTime floatValue];
    
    max = (maxStartDur - minStartDur);
    if(max)
    {
        float f = (startTimeValue - minStartDur)/max;
        f = fabsf(f);
        [qidongshijianSlide setCircleValue:f];
    }
    
    lableL3.text = [NSString stringWithFormat:@"%0.0f ms", startTimeValue];
    
    
    NSString *huifuTime = [_curProxy getYaxianRecoveryTime];
    float huifuTimeValue = [huifuTime floatValue];
    
    max = (maxRecoveDur - minRecoveDur);
    if(max)
    {
        float f = (huifuTimeValue - minRecoveDur)/max;
        f = fabsf(f);
        [huifushijianSlide setCircleValue:f];
    }
    
    lableL4.text = [NSString stringWithFormat:@"%0.0f ms", huifuTimeValue];
}

- (void) contentViewComps{
    
    int w = CGRectGetHeight(contentView.frame)*0.8;
    int m = w%5;
    w = w-m;
    
    int y = (CGRectGetHeight(contentView.frame) - w)/2;
    CGRect rc = CGRectMake(50, y+20, w, w);
    
    _limiter = [[LimiterView alloc] initWithFrame:rc];
    [contentView addSubview:_limiter];
    _limiter.backgroundColor = [UIColor clearColor];
    
    int x = CGRectGetMaxX(_limiter.frame);
    y = CGRectGetHeight(contentView.frame)/2-50;
    x+=10;
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"阀值（db）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    fazhiSlider = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    fazhiSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    fazhiSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [fazhiSlider enableValueSet:YES];
    fazhiSlider.delegate = self;
    fazhiSlider.tag = 1;
    [contentView addSubview:fazhiSlider];
    

    lableL1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL1];
    lableL1.font = [UIFont systemFontOfSize:13];
    lableL1.textColor = YELLOW_COLOR;
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"斜率";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];

    xielvSlide = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    xielvSlide._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlide._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlide enableValueSet:YES];
    xielvSlide.delegate = self;
    xielvSlide.tag = 2;
    [contentView addSubview:xielvSlide];

    lableL2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL2.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL2];
    lableL2.font = [UIFont systemFontOfSize:13];
    lableL2.textColor = YELLOW_COLOR;
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"启动时间（ms）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    qidongshijianSlide = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    qidongshijianSlide._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    qidongshijianSlide._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [qidongshijianSlide enableValueSet:YES];
    qidongshijianSlide.delegate = self;
    qidongshijianSlide.tag = 3;
    [contentView addSubview:qidongshijianSlide];
    
    lableL3 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL3.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL3];
    lableL3.font = [UIFont systemFontOfSize:13];
    lableL3.textColor = YELLOW_COLOR;
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"恢复时间（ms）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    huifushijianSlide = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    huifushijianSlide._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    huifushijianSlide._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [huifushijianSlide enableValueSet:YES];
    huifushijianSlide.delegate = self;
    huifushijianSlide.tag = 4;
    [contentView addSubview:huifushijianSlide];
    
    lableL4 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL4.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL4];
    lableL4.font = [UIFont systemFontOfSize:13];
    lableL4.textColor = YELLOW_COLOR;
    
    _enableStartBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    _enableStartBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height - 40, 50, 30);
    _enableStartBtn.layer.cornerRadius = 5;
    _enableStartBtn.layer.borderWidth = 2;
    _enableStartBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _enableStartBtn.clipsToBounds = YES;
    [_enableStartBtn setTitle:@"启用" forState:UIControlStateNormal];
    _enableStartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_enableStartBtn addTarget:self
                        action:@selector(enableStartBtnAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_enableStartBtn];
}

-(void) enableStartBtnAction:(id) sender {
    BOOL isYaXianStarted = [_curProxy isYaXianStarted];
    
    isYaXianStarted = !isYaXianStarted;
    
    if(isYaXianStarted)
    {
        [_enableStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [_enableStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
    
    [_curProxy controlYaXianStarted:isYaXianStarted];
}

- (void) updateProxyCommandValIsLoaded
{
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];

}

- (void) didLoadedProxyCommand{
    
    _curProxy.delegate = nil;
 
    NSDictionary *result = [_curProxy getPressLimitOptions];
    
    maxTh = [[result objectForKey:@"TH_max"] intValue];
    minTh = [[result objectForKey:@"TH_min"] intValue];
    [_limiter setMaxThresholdWithThreshold:maxTh];
    [_limiter setMinThresholdWithThreshold:minTh];
    
    NSString *zengyiDB = [_curProxy getYaxianFazhi];
    int value = [zengyiDB intValue];
    [_limiter setThresHoldWithR:value];
    
    /////
    maxRadio = [[result objectForKey:@"SL_max"] intValue];
    minRadio = [[result objectForKey:@"SL_min"] intValue];
    
    NSString *xielv = [_curProxy getYaxianXielv];
    float xielvValue = [xielv floatValue];
    [_limiter setRatioWithR:xielvValue];
    
    ////
    maxStartDur = [[result objectForKey:@"START_DUR_max"] intValue];
    minStartDur = [[result objectForKey:@"START_DUR_min"] intValue];

    
    ////
    maxRecoveDur = [[result objectForKey:@"RECOVER_DUR_max"] intValue];
    minRecoveDur = [[result objectForKey:@"RECOVER_DUR_min"] intValue];

    [self updateYaXianQi];
    
}
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        float k = (value *(maxTh-minTh)) + minTh;
        NSString *valueStr= [NSString stringWithFormat:@"%0.1f dB", k];
        
        lableL1.text = valueStr;
        
        [_limiter setThresHoldWithR:k];
        
        [_curProxy controlYaxianFazhi:[NSString stringWithFormat:@"%0.1f", k]];

    } else if (tag == 2) {
        float k = (value * (maxRadio - minRadio)) + minRadio;
        NSString *valueStr = [NSString stringWithFormat:@"%0.1f", k];
        
        lableL2.text = valueStr;
        
        if(maxRadio > 0)
            [_limiter setRatioWithR:k];
        
        [_curProxy controlYaxianXielv:valueStr];
        
    } else if (tag == 3) {
        
        int k = (value *(maxStartDur - minStartDur)) + minStartDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        lableL3.text = [NSString stringWithFormat:@"%@ ms",valueStr];
        
        [_curProxy controlYaxianStartTime:valueStr];
    } else {
        int k = (value *(maxRecoveDur - minRecoveDur)) + minRecoveDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        lableL4.text = [NSString stringWithFormat:@"%@ ms",valueStr];
        
        [_curProxy controlYaxianRecoveryTime:valueStr];
    }
}
@end
