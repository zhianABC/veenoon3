//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ZaoShengYaXian_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "GradeLineView.h"
#import "veenoon-Swift.h"

@interface ZaoShengYaXian_UIView()<SlideButtonDelegate>
{
    UIButton *channelBtn;
    
    UIView   *contentView;
    
    UILabel *yaxianL;
    UILabel *zaoshengL;
    
    SlideButton *btnJH1;
    SlideButton *btnJH2;
    
    int _pressMin;
    int _pressMax;
    int _noiseMin;
    int _noiseMax;
    
    LimiterView *_limiter;
}
@property (nonatomic, strong) NSMutableArray *_channelBtns;

@end


@implementation ZaoShengYaXian_UIView
@synthesize _channelBtns;
@synthesize _currentObj;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id) initWithFrame:(CGRect)frame withAudiMix:(AudioEMix*) audioMix
{
    if(self = [super initWithFrame:frame])
    {
        _currentObj = audioMix;
        
        channelBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 70, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [channelBtn setTitle:@"In 1" forState:UIControlStateNormal];
        [channelBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
//        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+20;
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 340)];
        [self addSubview:contentView];
        contentView.layer.cornerRadius = 5;
        contentView.clipsToBounds = YES;
        contentView.backgroundColor = RGB(0, 89, 118);
        
//        [self layoutChannelBtns:16];
        [self contentViewComps];
    }
    
    return self;
}

- (void) layoutChannelBtns:(int)num{
    
    self._channelBtns = [NSMutableArray array];
    
    float x = 0;
    int y = CGRectGetHeight(self.frame)-60;
    
    float spx = (CGRectGetWidth(self.frame) - num*50.0)/(num-1);
    if(spx > 10)
        spx = 10;
    for(int i = 0; i < num; i++)
    {
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        btn.frame = CGRectMake(x, y, 50, 50);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        btn.tag = i;
        [self addSubview:btn];
        
        if(i == 0)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        }
        
        [btn addTarget:self
                action:@selector(channelBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        x+=50;
        x+=spx;
        
        [_channelBtns addObject:btn];
    }
    
}

- (void) channelBtnAction:(UIButton*)sender{
    
    int tag = (int)sender.tag+1;
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
}

- (void) contentViewComps{
    
    int w = CGRectGetHeight(contentView.frame)*0.8;
    int m = w%5;
    w = w-m;
    
    int y = (CGRectGetHeight(contentView.frame) - w)/2;
    CGRect rc = CGRectMake(120, y+20, w, w);
    
    _limiter = [[LimiterView alloc] initWithFrame:rc];
    [contentView addSubview:_limiter];
    _limiter.backgroundColor = [UIColor clearColor];
    
    int x = CGRectGetMaxX(_limiter.frame);
    
    y = CGRectGetHeight(contentView.frame)/2-50;
    x+=30;
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y-20, 120, 20)];
    tL.text = @"压限器 (PS)";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont boldSystemFontOfSize:16];
    tL.textColor = [UIColor whiteColor];
    
    btnJH1 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+125, 120, 120)];
    btnJH1._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    btnJH1._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [btnJH1 enableValueSet:YES];
    btnJH1.delegate = self;
    btnJH1.tag = 1;
    [self addSubview:btnJH1];
    
    NSMutableDictionary *pressDic = [_currentObj._proxyObj getPressMinMax];
    _pressMax = [[pressDic objectForKey:@"max"] intValue];
    _pressMin = [[pressDic objectForKey:@"min"] intValue];
    
    
    NSString *pressStr = _currentObj._proxyObj._mixPress;
    float pressValue = [pressStr floatValue];
    float pressMax = (_pressMax - _pressMin);
    if(pressMax)
    {
        float f = (pressValue - _pressMin)/pressMax;
        f = fabsf(f);
        [btnJH1 setCircleValue:f];
        
        [_limiter setMaxThresholdWithThreshold:_pressMax];
        [_limiter setMinThresholdWithThreshold:_pressMin];
        
        [_limiter setThresHoldWithR:pressValue];
    }
    
    yaxianL = [[UILabel alloc] initWithFrame:CGRectMake(x, y+100, 120, 120)];
    yaxianL.text = [pressStr stringByAppendingString:@" dB"];
    yaxianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:yaxianL];
    yaxianL.font = [UIFont systemFontOfSize:13];
    yaxianL.textColor = YELLOW_COLOR;
    
    x+=200;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y-20, 120, 20)];
    tL.text = @"噪声门 (NS)";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont boldSystemFontOfSize:16];
    tL.textColor = [UIColor whiteColor];
    
    btnJH2 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+125, 120, 120)];
    btnJH2._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    btnJH2._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [btnJH2 enableValueSet:YES];
    btnJH2.delegate = self;
    btnJH2.tag = 2;
    [self addSubview:btnJH2];
    
    NSMutableDictionary *noiseDic = [_currentObj._proxyObj getNoiseMinMax];
    _noiseMax = [[noiseDic objectForKey:@"max"] intValue];
    _noiseMin = [[noiseDic objectForKey:@"min"] intValue];
    
    
    NSString *noiseStr = _currentObj._proxyObj._mixNoise;
    float noiseValue = [noiseStr floatValue];
    float noiseMax = (_noiseMax - _noiseMin);
    if(noiseMax)
    {
        float f = (noiseValue - _pressMin)/noiseMax;
        f = fabsf(f);
        [btnJH2 setCircleValue:f];
    }
    
    zaoshengL = [[UILabel alloc] initWithFrame:CGRectMake(x, y+100, 120, 120)];
    zaoshengL.text = [noiseStr stringByAppendingString:@" dB"];
    zaoshengL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:zaoshengL];
    zaoshengL.font = [UIFont systemFontOfSize:13];
    zaoshengL.textColor = YELLOW_COLOR;
    
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        int k = (value *(_pressMax-_pressMin)) + _pressMin;
        NSString *valueStr= [NSString stringWithFormat:@"%d dB", k];
        yaxianL.text = valueStr;
        
        [_currentObj._proxyObj controlMixPress:[NSString stringWithFormat:@"%d", k]];
        
        [_limiter setThresHoldWithR:k];
        
    } else {
        int k = (value *(_noiseMax-_noiseMin)) + _noiseMin;
        NSString *valueStr= [NSString stringWithFormat:@"%d dB", k];
        zaoshengL.text = valueStr;
        
        [_currentObj._proxyObj controlMixNoise:[NSString stringWithFormat:@"%d", k]];
    }
}

@end
