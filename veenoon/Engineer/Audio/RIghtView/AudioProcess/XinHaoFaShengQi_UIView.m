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

@interface XinHaoFaShengQi_UIView()<SlideButtonDelegate, VAProcessorProxysDelegate> {
    
    UIButton *channelBtn;
    
    UILabel *labelL1;
    
    UIPopoverController *_deviceSelector;
    
    UIButton *xinhaoPinLvBtn;
    
    UIButton *zerodbBtn;
    
    SlideButton *xinhaoZengyiSlider;
    
    UIButton *xinhaoMuteBtn;
    
    int maxTH;
    int minTH;
    int maxDuration;
    int minDuration;
    
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end


@implementation XinHaoFaShengQi_UIView
@synthesize _curProxy;
//@synthesize _channelBtns;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

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
        [channelBtn setTitle:self._curProxy._rgsProxyObj.name forState:UIControlStateNormal];
        [channelBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+20;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
        
        [self contentViewComps];
    }
    
    return self;
}

- (void) updateProxyCommandValIsLoaded {
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
}

- (void) didLoadedProxyCommand {
    
    _curProxy.delegate = nil;
    
    NSDictionary *result = [_curProxy getSetDelayOptions];
    
    maxDuration = [[result objectForKey:@"max"] intValue];
    minDuration = [[result objectForKey:@"min"] intValue];
    
    [self udpateXinhaofasheng];
}

- (void) channelBtnAction:(UIButton*)sender{
    
    int tag = (int)sender.tag+1;
    [channelBtn setTitle:[NSString stringWithFormat:@"Out %d", tag] forState:UIControlStateNormal];
    
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

-(void) udpateXinhaofasheng {
    [xinhaoPinLvBtn setTitle:@"  1000" forState:UIControlStateNormal];
    [zerodbBtn setTitle:@"  正弦波" forState:UIControlStateNormal];
    
    BOOL isXinhaoMute = [_curProxy isXinhaofashengMute];
    
    if(isXinhaoMute)
    {
        [xinhaoMuteBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [xinhaoMuteBtn changeNormalColor:RGB(75, 163, 202)];
    }
    
    NSString *zengyiDB = [_curProxy getZidonghuiyinZengYi];
    float value = [zengyiDB floatValue];
    float f = (value+12.0)/24.0;
    [xinhaoZengyiSlider setCircleValue:f];
    
    labelL1.text = [[_curProxy getZidonghuiyinZengYi] stringByAppendingString:@" dB"];
    
    
}
- (void) contentViewComps{
    int btnStartX = 250;
    int btnY = 150;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"频率 (Hz)";
    addLabel2.font = [UIFont boldSystemFontOfSize: 14];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(btnStartX, btnY -30, 120, 20);
    [contentView addSubview:addLabel2];
    
    xinhaoPinLvBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    xinhaoPinLvBtn.frame = CGRectMake(btnStartX, btnY, 120, 30);
    xinhaoPinLvBtn.layer.cornerRadius = 5;
    xinhaoPinLvBtn.layer.borderWidth = 2;
    xinhaoPinLvBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    xinhaoPinLvBtn.clipsToBounds = YES;
    [xinhaoPinLvBtn setTitle:@"  1000" forState:UIControlStateNormal];
    xinhaoPinLvBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    xinhaoPinLvBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(xinhaoPinLvBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [xinhaoPinLvBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [xinhaoPinLvBtn addTarget:self
                action:@selector(xinhaoPinLvBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:xinhaoPinLvBtn];
    
    zerodbBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zerodbBtn.frame = CGRectMake(CGRectGetMaxX(xinhaoPinLvBtn.frame)+20, btnY, 120, 30);
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
    [contentView addSubview:zerodbBtn];
    
    
    xinhaoMuteBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    xinhaoMuteBtn.frame = CGRectMake(CGRectGetMaxX(zerodbBtn.frame)+10, btnY, 50, 30);
    xinhaoMuteBtn.layer.cornerRadius = 5;
    xinhaoMuteBtn.layer.borderWidth = 2;
    xinhaoMuteBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    xinhaoMuteBtn.clipsToBounds = YES;
    [xinhaoMuteBtn setTitle:@"静音" forState:UIControlStateNormal];
    xinhaoMuteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [xinhaoMuteBtn addTarget:self
                action:@selector(muteBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:xinhaoMuteBtn];
    
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"增益 (dB)";
    addLabel.font = [UIFont boldSystemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(630, 120, 120, 20);
    [contentView addSubview:addLabel];
    
    xinhaoZengyiSlider = [[SlideButton alloc] initWithFrame:CGRectMake(600, 135, 120, 120)];
    xinhaoZengyiSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xinhaoZengyiSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xinhaoZengyiSlider enableValueSet:YES];
    xinhaoZengyiSlider.delegate = self;
    xinhaoZengyiSlider.tag = 3;
    [contentView addSubview:xinhaoZengyiSlider];
    
    labelL1 = [[UILabel alloc] initWithFrame:CGRectMake(600, 135+120, 120, 20)];
    labelL1.text = @"0";
    labelL1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelL1];
    labelL1.font = [UIFont systemFontOfSize:13];
    labelL1.textColor = YELLOW_COLOR;
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int k = (value *24)-12;
    NSString *valueStr= [NSString stringWithFormat:@"%d", k];
    
    [_curProxy controlXinhaofashengZengyi:valueStr];
    
    labelL1.text = valueStr;
}

-(void) zhengxuanboAction:(UIButton*) sender {
    TeslariaComboChooser *sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = [_curProxy getXinhaofashengZhengxuanArray];
    sel._type = 1;
    
    sel.preferredContentSize = CGSizeMake(150, 350);
    sel._size = CGSizeMake(150, 350);
    
    IMP_BLOCK_SELF(XinHaoFaShengQi_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseXinhaoZhengxuan:object];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:sender];
    
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
    
    [_curProxy controlXinhaoZhengxuanbo:device];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

-(void) xinhaoPinLvBtnAction:(UIButton*) sender {
    TeslariaComboChooser *sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = [_curProxy getXinhaofashengPinlvArray];
    sel._type = 0;
    
    sel.preferredContentSize = CGSizeMake(150, 350);
    sel._size = CGSizeMake(150, 350);
    
    IMP_BLOCK_SELF(XinHaoFaShengQi_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseXinhaoPinLv:object];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:sender];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseXinhaoPinLv:(NSString*)device{
    if (device == nil) {
        return;
    }
    NSString *dispaly = [@"   " stringByAppendingString:device];
    
    [xinhaoPinLvBtn setTitle:dispaly forState:UIControlStateNormal];
    
    [_curProxy controlXinHaofashengPinlv:device];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

-(void) muteBtnAction:(id) sender {
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy isXinhaofashengMute];
    
    [_curProxy controlXinhaofashengMute:!isMute];
    
    [self updateMuteButtonState];
}
- (void) updateMuteButtonState{
    
    BOOL isXinhaoMute = [_curProxy isXinhaofashengMute];
    
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


