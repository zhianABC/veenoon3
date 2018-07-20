//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ZaoShengMen_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface ZaoShengMen_UIView() <SlideButtonDelegate, VAProcessorProxysDelegate>{
    
    UIButton *channelBtn;
    
    SlideButton *fazhiSlider;
    SlideButton *qidongshijianSlider;
    SlideButton *huifushijianSlider;
    
    UILabel *fazhiL;
    UILabel *qidongshijianL;
    UILabel *huifushijianL;
    
    UIButton *qiyongBtn;
    
    int maxTh;
    int minTh;
    int maxStartDur;
    int minStartDur;
    int maxRecoveDur;
    int minRecoveDur;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end


@implementation ZaoShengMen_UIView
@synthesize _curProxy;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys
{
    if(self = [super initWithFrame:frame])
    {
        self._proxys = proxys;
        
        if ([self._proxys count]) {
            self._curProxy = [self._proxys objectAtIndex:0];
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
        maxStartDur = 1000;
        minStartDur = 20;
        maxRecoveDur = 1000;
        minRecoveDur = 20;
        
        [self contentViewComps];
    }
    
    return self;
}

- (void) didLoadedProxyCommand{
    
    _curProxy.delegate = nil;
    
    NSDictionary *result = [_curProxy getPressLimitOptions];
    
    maxTh = [[result objectForKey:@"TH_max"] intValue];
    minTh = [[result objectForKey:@"TH_min"] intValue];
    
    ////
    maxStartDur = [[result objectForKey:@"START_DUR_max"] intValue];
    minStartDur = [[result objectForKey:@"START_DUR_min"] intValue];
    
    
    ////
    maxRecoveDur = [[result objectForKey:@"RECOVER_DUR_max"] intValue];
    minRecoveDur = [[result objectForKey:@"RECOVER_DUR_min"] intValue];
    
    [self updateZaoShengMen];
}

-(void) updateZaoShengMen {
    
    NSString *zengyiDB = [_curProxy getZaoshengFazhi];
    float value = [zengyiDB floatValue];
    float max = (maxTh - minTh);
    if(max)
    {
        float f = (value - minTh)/max;
        f = fabsf(f);
        [fazhiSlider setCircleValue:f];
    }
    
    if (zengyiDB) {
        fazhiL.text = [zengyiDB stringByAppendingString:@" dB"];
    }
    
    NSString *startTime = [_curProxy getZaoshengStartTime];
    float startTimeV = [startTime floatValue];
    
    float maxS = (maxStartDur- minStartDur);
    if(maxS)
    {
        float f = (startTimeV - minStartDur)/maxStartDur;
        f = fabsf(f);
        [qidongshijianSlider setCircleValue:f];
    }
    
    qidongshijianL.text = [startTime stringByAppendingString:@" ms"];
    
    NSString *huifuTime = [_curProxy getZaoshengRecoveryTime];
    float huifuTimeValue = [huifuTime floatValue];
    
    max = (maxRecoveDur - minRecoveDur);
    if(max)
    {
        float f = (huifuTimeValue - minRecoveDur)/max;
        f = fabsf(f);
        [huifushijianSlider setCircleValue:f];
    }
    
    huifushijianL.text = [NSString stringWithFormat:@"%f ms", huifuTimeValue];
    
    BOOL isFanKuiYiZhi = [_curProxy isZaoshengStarted];
    
    if(isFanKuiYiZhi)
    {
        [qiyongBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [qiyongBtn changeNormalColor:RGB(75, 163, 202)];
    }
}

- (void) updateProxyCommandValIsLoaded {
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
    
}

- (void) channelBtnAction:(UIButton*)sender{
    
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
    
    int idx = (int)sender.tag;
    self._curProxy = [self._proxys objectAtIndex:idx];
    
    NSString *name = _curProxy._rgsProxyObj.name;
    [channelBtn setTitle:name forState:UIControlStateNormal];
    
    [self updateProxyCommandValIsLoaded];
}

- (void) contentViewComps{
    int startX = 140;
    int gap = 250;
    int labelY = 100;
    int labelBtnGap = 25;
    int weiYi = 20;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"阀值 (dB)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(startX+weiYi+12, labelY, 120, 20);
    [contentView addSubview:addLabel];
    
    fazhiSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap, 120, 120)];
    fazhiSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    fazhiSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [fazhiSlider enableValueSet:YES];
    fazhiSlider.delegate = self;
    fazhiSlider.tag = 1;
    [contentView addSubview:fazhiSlider];
    
    fazhiL = [[UILabel alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap+120, 120, 20)];
    fazhiL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:fazhiL];
    fazhiL.font = [UIFont systemFontOfSize:13];
    fazhiL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"启动时间 (ms)";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(startX+gap+weiYi, labelY, 120, 20);
    [contentView addSubview:addLabel2];
    
    qidongshijianSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    qidongshijianSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    qidongshijianSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [qidongshijianSlider enableValueSet:YES];
    qidongshijianSlider.delegate = self;
    qidongshijianSlider.tag = 2;
    [contentView addSubview:qidongshijianSlider];
    
    qidongshijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap+120, 120, 20)];
    qidongshijianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:qidongshijianL];
    qidongshijianL.font = [UIFont systemFontOfSize:13];
    qidongshijianL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"恢复时间 (ms)";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(startX+gap*2+weiYi, labelY, 120, 20);
    [contentView addSubview:addLabel22];
    
    huifushijianSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap, 120, 120)];
    huifushijianSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    huifushijianSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [huifushijianSlider enableValueSet:YES];
    huifushijianSlider.delegate = self;
    huifushijianSlider.tag = 3;
    [contentView addSubview:huifushijianSlider];
    
    huifushijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap+120, 120, 20)];
    huifushijianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:huifushijianL];
    huifushijianL.font = [UIFont systemFontOfSize:13];
    huifushijianL.textColor = YELLOW_COLOR;
    
    
    qiyongBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    qiyongBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height - 40, 50, 30);
    qiyongBtn.layer.cornerRadius = 5;
    qiyongBtn.layer.borderWidth = 2;
    qiyongBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    qiyongBtn.clipsToBounds = YES;
    [qiyongBtn setTitle:@"启用" forState:UIControlStateNormal];
    qiyongBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [qiyongBtn addTarget:self
                action:@selector(zhitongBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:qiyongBtn];
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        int k = (value *(maxTh-minTh)) + minTh;
        NSString *valueStr= [NSString stringWithFormat:@"%d dB", k];
        
        fazhiL.text = valueStr;
        
        [_curProxy controlZaoshengFazhi:[NSString stringWithFormat:@"%d", k]];
    } else if (tag == 2) {
        int k = (value *(maxStartDur-minStartDur)) + minStartDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        qidongshijianL.text = [NSString stringWithFormat:@"%@ ms",valueStr];;
        
        [_curProxy controlZaoshengStartTime:valueStr];
    } else {
        int k = (value *(maxRecoveDur-minRecoveDur)) + minRecoveDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        huifushijianL.text = [NSString stringWithFormat:@"%@ ms",valueStr];;
        
        [_curProxy controlZaoshengRecoveryTime:valueStr];
    }
}
- (void) zhitongBtnAction:(id) sender {
    if(_curProxy == nil)
        return;
    
    BOOL isZaoshengStarted = [_curProxy isZaoshengStarted];
    
    isZaoshengStarted = !isZaoshengStarted;
    
    [_curProxy controlZaoshengStarted:isZaoshengStarted];
    
    if(isZaoshengStarted)
    {
        [qiyongBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [qiyongBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
@end


