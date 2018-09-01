//
//  ZiDongHunYin_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ZiDongHunYin_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"
#import "AudioEProcessorAutoMixProxy.h"
#import "AudioEProcessor.h"

@interface ZiDongHunYin_UIView() <SlideButtonDelegate, AudioEProcessorAutoMixProxyDelegate> {
    UIButton *channelBtn;
    
    SlideButton *zengyi;
    
    UILabel *labelL1;
    
    NSMutableArray *inputChanels;
    NSMutableArray *outputChanels;
    
    
    NSMutableArray *inputSelectedBtns;
    NSMutableArray *outputSelectedBtns;
    
    int valueMax;
    int valueMin;
}
@property (nonatomic, strong) AudioEProcessorAutoMixProxy *_currentProxy;
@property (nonatomic, strong) AudioEProcessor *_currentAodio;
@end

@implementation ZiDongHunYin_UIView
@synthesize _currentProxy;

- (id)initWithFrameProxy:(CGRect)frame withAudio:(AudioEProcessor*) audioProcessor withProxy:(AudioEProcessorAutoMixProxy*) proxy
{
    if(self = [super initWithFrame:frame]) {
        
        self._currentProxy = proxy;
        self._currentAodio = audioProcessor;
        
        inputChanels = [NSMutableArray array];
        outputChanels = [NSMutableArray array];
        
        inputSelectedBtns = [NSMutableArray array];
        outputSelectedBtns = [NSMutableArray array];
        
        [self contentViewComps];
    }
    
    return self;
}

- (void) contentViewComps {
    int startX = 140;
    int gap = 250;
    int labelY = 220;
    int labelBtnGap = 0;
    int weiYi = 30;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"增益 (dB)";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(startX+gap+weiYi, labelY-10, 120, 20);
    [self addSubview:addLabel2];
    
    zengyi = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    zengyi._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    zengyi._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [zengyi enableValueSet:YES];
    zengyi.delegate = self;
    zengyi.tag = 3;
    [self addSubview:zengyi];
    
    
    labelL1 = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap+50, 120, 120)];
    labelL1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelL1];
    labelL1.font = [UIFont systemFontOfSize:13];
    labelL1.textColor = YELLOW_COLOR;
    
    [self createInPutComps];
    
    [self createOutPutComps];
}

- (void) updateProxyCommandValIsLoaded
{
    _currentProxy.delegate = self;
    [_currentProxy checkRgsProxyCommandLoad];
    
}

- (void) createInPutComps {
    
    UILabel *labelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 120, 120)];
    labelL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:labelL];
    labelL.font = [UIFont systemFontOfSize:13];
    labelL.textColor = YELLOW_COLOR;
    
    labelL.text = @"输入";
    
    int num = (int) [self._currentAodio._inAudioProxys count];
    if (num <= 0) {
        return;
    }
    
    if(inputChanels && [inputChanels count])
    {
        [inputChanels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    inputChanels = [NSMutableArray array];
    
    if(inputSelectedBtns && [inputSelectedBtns count])
    {
        [inputSelectedBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    inputSelectedBtns = [NSMutableArray array];
    
    float x = 0;
    int y = CGRectGetHeight(self.frame)-460;
    
    float spx = (CGRectGetWidth(self.frame) - num*50.0)/(num-1);
    if(spx > 10)
        spx = 10;
    for(int i = 0; i < num; i++)
    {
        //VAProcessorProxys *vProxy = [self._currentAodio._inAudioProxys objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        btn.frame = CGRectMake(x, y, 50, 50);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        //[btn setTitle:vProxy._rgsProxyObj.name forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"In %d", i+1]
             forState:UIControlStateNormal];
        btn.tag = i;
        [self addSubview:btn];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn addTarget:self
                action:@selector(inputChanelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        x+=50;
        x+=spx;
        
        [inputChanels addObject:btn];
    }
    
}

- (void) didLoadedProxyCommand {
    _currentProxy.delegate = nil;
    
    NSDictionary *result = [_currentProxy getAutoMixCmdSettings];
    
    valueMax = [[result objectForKey:@"max"] intValue];
    valueMin = [[result objectForKey:@"min"] intValue];
    
    [self updateZidonghunyin];
}

- (void) updateZidonghunyin {
    
    NSString *zengyiDB = [_currentProxy getZidonghuiyinZengYi];
    float value = [zengyiDB floatValue];
    float max = (valueMax - valueMin);
    if(max)
    {
        float f = (value - valueMin)/max;
        f = fabsf(f);
        [zengyi setCircleValue:f];
    }
    
    if (zengyiDB) {
        labelL1.text = [zengyiDB stringByAppendingString:@" dB"];
    }
    
}

- (void) inputChanelBtnAction:(UIButton*) sender {
    int btnIndex = (int) sender.tag;
    
    UIButton *selectedBtn = nil;
    for (UIButton *btn in inputSelectedBtns) {
        if (btnIndex == btn.tag) {
            selectedBtn = btn;
            break;
        }
    }
    BOOL isEnable;
    if (selectedBtn) {
        [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [inputSelectedBtns removeObject:selectedBtn];
        
        isEnable = NO;
    } else {
        [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        
        [inputSelectedBtns addObject:sender];
        isEnable = YES;
    }
    
    NSString *proxyName = sender.titleLabel.text;
    
    [_currentProxy controlZidongHunyinBtn:proxyName withType:0 withState:isEnable];
}

- (void) createOutPutComps {
    
    UILabel *labelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 120, 120)];
    labelL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:labelL];
    labelL.font = [UIFont systemFontOfSize:13];
    labelL.textColor = YELLOW_COLOR;
    
    labelL.text = @"输出";
    
    int num = (int) [self._currentAodio._outAudioProxys count];
    if (num <= 0) {
        return;
    }
    
    if(outputChanels && [outputChanels count])
    {
        [outputChanels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    outputChanels = [NSMutableArray array];
    
    if(outputSelectedBtns && [outputSelectedBtns count])
    {
        [outputSelectedBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    outputSelectedBtns = [NSMutableArray array];
    
    float x = 0;
    int y = CGRectGetHeight(self.frame)-150;
    
    float spx = (CGRectGetWidth(self.frame) - num*50.0)/(num-1);
    if(spx > 10)
        spx = 10;
    for(int i = 0; i < num; i++)
    {
        //VAProcessorProxys *vProxy = [self._currentAodio._outAudioProxys objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        btn.frame = CGRectMake(x, y, 50, 50);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        //[btn setTitle:vProxy._rgsProxyObj.name forState:UIControlStateNormal];
        
        [btn setTitle:[NSString stringWithFormat:@"Out %d", i+1]
             forState:UIControlStateNormal];
        
        btn.tag = i;
        [self addSubview:btn];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        
        [btn addTarget:self
                action:@selector(outputChanelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        x+=50;
        x+=spx;
        
        [outputChanels addObject:btn];
    }
}

- (void) outputChanelBtnAction:(UIButton*) sender {
    int btnIndex = (int) sender.tag;
    
    UIButton *selectedBtn = nil;
    for (UIButton *btn in outputSelectedBtns) {
        if (btnIndex == btn.tag) {
            selectedBtn = btn;
            break;
        }
    }
    BOOL isEnable;
    if (selectedBtn) {
        [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [outputSelectedBtns removeObject:selectedBtn];
        
        isEnable = NO;
    } else {
        [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        
        [outputSelectedBtns addObject:sender];
        
        isEnable = YES;
    }
    
    NSString *proxyName = sender.titleLabel.text;
    
    [_currentProxy controlZidongHunyinBtn:proxyName withType:1 withState:isEnable];
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn {
    float k = roundf((value *(valueMax-valueMin)) + valueMin);
    NSString *valueStr= [NSString stringWithFormat:@"%.f dB", k];
    
    labelL1.text = valueStr;
    
    [_currentProxy controlZiDongHunYinZengYi:[NSString stringWithFormat:@"%f", k]];
}

@end
