//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "XinHaoFaShengQi_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"
#import "TeslariaComboChooser.h"
#import "AudioEProcessor.h"
#import "AudioEProcessorSignalProxy.h"

@interface XinHaoFaShengQi_UIView()<SlideButtonDelegate, AudioEProcessorSignalProxyDelegate> {
    
    UIButton *channelBtn;
    
    UILabel *zhengxuanboL;
    
    UILabel *zengyiL;
    
    UIPopoverController *_deviceSelector;
    
    TeslariaComboChooser *sel;
    
    UIButton *zerodbBtn;
    
    SlideButton *xinhaoZengyiSlider;
    
    SlideButton *xinhaoPinlvSlider;
    
    NSMutableArray *outputChanels;
    
    NSMutableArray *outputSelectedBtns;
    
    UIButton *xinhaoMuteBtn;
    
    int maxRate;
    int minRate;
    
    int maxZengyi;
    int minZengyi;
    
    NSArray *_zhengxuanboArray;
}
@property (nonatomic, strong) AudioEProcessorSignalProxy *_currentSignalProxy;
@property (nonatomic, strong) AudioEProcessor *_currentAudio;
@end


@implementation XinHaoFaShengQi_UIView
@synthesize _currentSignalProxy;
@synthesize _currentAudio;
//@synthesize _channelBtns;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrameProxy:(CGRect)frame withAudio:(AudioEProcessor*) audioProcessor withProxy:(AudioEProcessorSignalProxy*) proxy {
    
    if(self = [super initWithFrame:frame])
    {
    
        self._currentAudio = audioProcessor;
        self._currentSignalProxy = proxy;
        
        
        outputChanels = [NSMutableArray array];
        
        outputSelectedBtns = [NSMutableArray array];
        
        [self contentViewComps];
    }
    
    return self;
}

- (void) updateProxyCommandValIsLoaded {
    _currentSignalProxy.delegate = self;
    [_currentSignalProxy checkRgsProxyCommandLoad];
}

- (void) didLoadedProxyCommand {
    
    _currentSignalProxy.delegate = nil;
    
    _zhengxuanboArray = [_currentSignalProxy getSignalType];
    
    NSDictionary *rateDic = [_currentSignalProxy getSignalRateSettings];
    
    maxRate = [[rateDic objectForKey:@"max"] intValue];
    minRate = [[rateDic objectForKey:@"min"] intValue];
    
    NSDictionary *zengyiDic = [_currentSignalProxy getSignalGainSettings];
    
    maxZengyi = [[zengyiDic objectForKey:@"max"] intValue];
    minZengyi = [[zengyiDic objectForKey:@"min"] intValue];
    
    [self udpateXinhaofasheng];
}



-(void) udpateXinhaofasheng {
    
    NSString *zengyiDB = [_currentSignalProxy getXinhaofashengZengYi];
    float value = [zengyiDB floatValue];
    float max = (maxZengyi - minZengyi);
    if(max)
    {
        float f = (value - minZengyi)/max;
        f = fabsf(f);
        [xinhaoZengyiSlider setCircleValue:f];
    }
    
    if (zengyiDB) {
        zengyiL.text = [zengyiDB stringByAppendingString:@" dB"];
    }
    
    NSString *pinlvDB = [_currentSignalProxy getXinhaofashengPinlv];
    float value2 = [pinlvDB floatValue];
    float max2 = (maxRate - minRate);
    if(max2)
    {
        float f2 = (value2 - minRate)/max2;
        f2 = fabsf(f2);
        [xinhaoZengyiSlider setCircleValue:f2];
    }
    
    if (pinlvDB) {
        zhengxuanboL.text = [pinlvDB stringByAppendingString:@" Hz"];
    }
    
    NSString *zhengxuan = [_currentSignalProxy getXinhaofashengZhengXuan];
    [zerodbBtn setTitle:[@" " stringByAppendingString:zhengxuan] forState:UIControlStateNormal];
    
    BOOL isXinhaofashengMute = [_currentSignalProxy isXinhaofashengMute];
    
    if(isXinhaofashengMute)
    {
        [xinhaoMuteBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [xinhaoMuteBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
- (void) contentViewComps{
    
    int btnY = 150;
    int btnX = 200;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"频率 (Hz)";
    addLabel2.font = [UIFont boldSystemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(btnX+30, 120, 120, 20);
    [self addSubview:addLabel2];
    
    xinhaoPinlvSlider = [[SlideButton alloc] initWithFrame:CGRectMake(btnX, 135, 120, 120)];
    xinhaoPinlvSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xinhaoPinlvSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xinhaoPinlvSlider enableValueSet:YES];
    xinhaoPinlvSlider.delegate = self;
    xinhaoPinlvSlider.tag = 3;
    [self addSubview:xinhaoPinlvSlider];
    
    zhengxuanboL = [[UILabel alloc] initWithFrame:CGRectMake(btnX, 135+100, 120, 20)];
    zhengxuanboL.text = @"0";
    zhengxuanboL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:zhengxuanboL];
    zhengxuanboL.font = [UIFont systemFontOfSize:13];
    zhengxuanboL.textColor = YELLOW_COLOR;
    
    
    zerodbBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zerodbBtn.frame = CGRectMake(CGRectGetMaxX(zhengxuanboL.frame)+40, btnY+30, 120, 30);
    zerodbBtn.layer.cornerRadius = 5;
    zerodbBtn.layer.borderWidth = 2;
    zerodbBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zerodbBtn.clipsToBounds = YES;
    [zerodbBtn setTitle:@"  正弦波" forState:UIControlStateNormal];
    zerodbBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    zerodbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon2 = [[UIImageView alloc]
                          initWithFrame:CGRectMake(zerodbBtn.frame.size.width - 20, 10, 10, 10)];
    icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
    [zerodbBtn addSubview:icon2];
    [zerodbBtn addTarget:self
                       action:@selector(zhengxuanboAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    icon2.alpha = 0.8;
    icon2.layer.contentsGravity = kCAGravityResizeAspect;
    [self addSubview:zerodbBtn];
    
    
    xinhaoMuteBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    xinhaoMuteBtn.frame = CGRectMake(CGRectGetMaxX(zerodbBtn.frame)+10, btnY+30, 50, 30);
    xinhaoMuteBtn.layer.cornerRadius = 5;
    xinhaoMuteBtn.layer.borderWidth = 2;
    xinhaoMuteBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    xinhaoMuteBtn.clipsToBounds = YES;
    [xinhaoMuteBtn setTitle:@"静音" forState:UIControlStateNormal];
    xinhaoMuteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [xinhaoMuteBtn addTarget:self
                action:@selector(muteBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:xinhaoMuteBtn];
    
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"增益 (dB)";
    addLabel.font = [UIFont boldSystemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(660, 120, 120, 20);
    [self addSubview:addLabel];
    
    xinhaoZengyiSlider = [[SlideButton alloc] initWithFrame:CGRectMake(630, 135, 120, 120)];
    xinhaoZengyiSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xinhaoZengyiSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xinhaoZengyiSlider enableValueSet:YES];
    xinhaoZengyiSlider.delegate = self;
    xinhaoZengyiSlider.tag = 2;
    [self addSubview:xinhaoZengyiSlider];
    
    zengyiL = [[UILabel alloc] initWithFrame:CGRectMake(630, 135+100, 120, 20)];
    zengyiL.text = @"1";
    zengyiL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:zengyiL];
    zengyiL.font = [UIFont systemFontOfSize:13];
    zengyiL.textColor = YELLOW_COLOR;
    
    [self createOutPutComps];
}


- (void) createOutPutComps {
    
    UILabel *labelL = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 120, 120)];
    labelL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:labelL];
    labelL.font = [UIFont systemFontOfSize:13];
    labelL.textColor = YELLOW_COLOR;
    
    labelL.text = @"输出通道";
    
    int num = (int) [self._currentAudio._outAudioProxys count];
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
        //VAProcessorProxys *vProxy = [self._currentAudio._outAudioProxys objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:nil];
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
        [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        
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
    
    [_currentSignalProxy controlSignalWithOutState:proxyName withState:isEnable];
}


- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    int tag = (int) slbtn.tag;
    if (tag == 2) {
        float k = roundf((value *(maxZengyi-minZengyi)) + minZengyi);
        NSString *valueStr= [NSString stringWithFormat:@"%.f dB", k];
        
        zengyiL.text = valueStr;
        
        [_currentSignalProxy controlXinhaofashengZengYi:[NSString stringWithFormat:@"%.f", k]];
    } else {
        float k = roundf((value *(maxRate-minRate)) + minRate);
        NSString *valueStr= [NSString stringWithFormat:@"%.f Hz", k];
        
        zhengxuanboL.text = valueStr;
        
        [_currentSignalProxy controlXinhaofashengPinlv:[NSString stringWithFormat:@"%.f", k]];
    }
}

-(void) zhengxuanboAction:(UIButton*) sender {
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = [_currentSignalProxy getSignalType];
    sel._type = 2;
    
    int h = (int)[sel._dataArray count] * 30 + 50;
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(XinHaoFaShengQi_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseXinhaoZhengxuan:object];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:[sender superview]];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseXinhaoZhengxuan:(NSString*)device{
    if (device == nil) {
        return;
    }
    NSString *dispaly = [@"   " stringByAppendingString:device];
    
    [zerodbBtn setTitle:dispaly forState:UIControlStateNormal];
    
    [_currentSignalProxy controlXinhaofashengZhengxuan:device];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}


-(void) muteBtnAction:(id) sender {
    if(_currentSignalProxy == nil)
        return;
    
    BOOL isMute = [_currentSignalProxy isXinhaofashengMute];
    
    isMute = !isMute;
    
    [_currentSignalProxy controlXinhaofashengMute:isMute];
    
    [self updateMuteButtonState];
}
- (void) updateMuteButtonState{
    
    BOOL isXinhaoMute = [_currentSignalProxy isXinhaofashengMute];
    
    if(isXinhaoMute)
    {
        [xinhaoMuteBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [xinhaoMuteBtn changeNormalColor:RGB(75, 163, 202)];
    }
}

@end


