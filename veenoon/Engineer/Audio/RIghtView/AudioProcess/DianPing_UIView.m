//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DianPing_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface DianPing_UIView() <SlideButtonDelegate, VAProcessorProxysDelegate>{
    
    UIButton *channelBtn;
    
    UILabel *labelL1;
    
    
    SlideButton *analogyDbSlider;
    
    float dbMax;
    float dbMin;
    
    UIButton *muteBtn;
    UIButton *invertBtn;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end


@implementation DianPing_UIView
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
        if (self._curProxy && self._curProxy._rgsProxyObj) {
            [channelBtn setTitle:self._curProxy._rgsProxyObj.name forState:UIControlStateNormal];
        } else {
            [channelBtn setTitle:@"Out 1" forState:UIControlStateNormal];
        }
        
        [channelBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+20;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
//
        dbMax = 70;
        dbMin = -70;
        
        [self contentViewComps];
    }
    
    return self;
}


- (void) channelBtnAction:(UIButton*)sender{
    
    int idx = (int)sender.tag;
    int tag = idx+1;
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
    
    
    if (idx < [self._proxys count]) {
        self._curProxy = [self._proxys objectAtIndex:idx];
        
        [self updateProxyCommandValIsLoaded];
    }
}


- (void) updateProxyCommandValIsLoaded {
    
    self._curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
}

- (void) didLoadedProxyCommand {
    
    _curProxy.delegate = nil;
    
    [self updateElecLevelUIVals];
}

- (void) updateElecLevelUIVals{
    
    NSDictionary *range = [_curProxy getAnalogyGainRange];
    dbMax = [[range objectForKey:@"max"] floatValue];
    dbMin = [[range objectForKey:@"min"] floatValue];
    
    if(dbMax - dbMin > 0)
    {
        float value = [_curProxy getAnalogyGain];
        NSString *valueStr= [NSString stringWithFormat:@"%0.1f dB", value];
        labelL1.text = valueStr;
        
        float percent = (value - dbMin)/(dbMax - dbMin);
        [analogyDbSlider setCircleValue:percent];
    }
    
    BOOL isMute = [_curProxy isProxyMute];
    if(isMute)
    {
        [muteBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [muteBtn changeNormalColor:RGB(75, 163, 202)];
    }
    
    BOOL isInvert = [_curProxy getInverted];
    if(isInvert)
    {
        [invertBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [invertBtn changeNormalColor:RGB(75, 163, 202)];
    }
}



- (void) contentViewComps{
    int btnStartX = 250;
    int btnY = 150;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"编组";
    addLabel2.font = [UIFont boldSystemFontOfSize: 14];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(btnStartX, btnY -30, 120, 20);
    [contentView addSubview:addLabel2];
    
    UIButton *lineBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    lineBtn.frame = CGRectMake(btnStartX, btnY, 120, 30);
    lineBtn.layer.cornerRadius = 5;
    lineBtn.layer.borderWidth = 2;
    lineBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lineBtn.clipsToBounds = YES;
    [lineBtn setTitle:@"  " forState:UIControlStateNormal];
    lineBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    lineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(lineBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [lineBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [lineBtn addTarget:self
                action:@selector(lineBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:lineBtn];
    
    invertBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    invertBtn.frame = CGRectMake(CGRectGetMaxX(lineBtn.frame)+20, btnY, 50, 30);
    invertBtn.layer.cornerRadius = 5;
    invertBtn.layer.borderWidth = 2;
    invertBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    invertBtn.clipsToBounds = YES;
    [invertBtn setTitle:@"  反相" forState:UIControlStateNormal];
    invertBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    invertBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contentView addSubview:invertBtn];
    [invertBtn addTarget:self
                action:@selector(invertBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    muteBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    muteBtn.frame = CGRectMake(CGRectGetMaxX(invertBtn.frame)+10, btnY, 50, 30);
    muteBtn.layer.cornerRadius = 5;
    muteBtn.layer.borderWidth = 2;
    muteBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    muteBtn.clipsToBounds = YES;
    [muteBtn setTitle:@"静音" forState:UIControlStateNormal];
    muteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [muteBtn addTarget:self
                action:@selector(muteBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:muteBtn];
    
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"增益 (dB)";
    addLabel.font = [UIFont boldSystemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(630, 120, 120, 20);
    [contentView addSubview:addLabel];
    
    analogyDbSlider = [[SlideButton alloc] initWithFrame:CGRectMake(600, 135, 120, 120)];
    analogyDbSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    analogyDbSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [analogyDbSlider enableValueSet:YES];
    analogyDbSlider.delegate = self;
    analogyDbSlider.tag = 3;
    [contentView addSubview:analogyDbSlider];
    
    labelL1 = [[UILabel alloc] initWithFrame:CGRectMake(600, 135+120, 120, 20)];
    labelL1.text = @"0";
    labelL1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelL1];
    labelL1.font = [UIFont systemFontOfSize:13];
    labelL1.textColor = YELLOW_COLOR;
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    if(dbMax - dbMin > 0)
    {
        float k = (value *(dbMax-dbMin)) + dbMin;
        NSString *valueStr= [NSString stringWithFormat:@"%0.1f dB", k];
        labelL1.text = valueStr;
    
        if(_curProxy)
        {
            [_curProxy controlDeviceDb:k force:YES];
        }
    }
    
    
}

-(void) bianzuAction:(id) sender {
    
}
-(void) lineBtnAction:(id) sender {
    
}


-(void) invertBtnAction:(UIButton*) sender {
    
    if(_curProxy)
    {
        BOOL isInvert = [_curProxy getInverted];
        [_curProxy controlInverted:!isInvert];
        
        
        isInvert = [_curProxy getInverted];
        if(isInvert)
        {
            [invertBtn changeNormalColor:THEME_RED_COLOR];
        }
        else
        {
            [invertBtn changeNormalColor:RGB(75, 163, 202)];
        }
    }
}

-(void) muteBtnAction:(UIButton*) sender {
    
    if(_curProxy)
    {
        BOOL isMute = [_curProxy isProxyMute];
        [_curProxy controlDeviceMute:!isMute];
        
        isMute = [_curProxy isProxyMute];
        if(isMute)
        {
            [muteBtn changeNormalColor:THEME_RED_COLOR];
        }
        else
        {
            [muteBtn changeNormalColor:RGB(75, 163, 202)];
        }
    }
}

- (void) onCopyData:(id)sender{
    
    [_curProxy copyElecLevelSet];
}
- (void) onPasteData:(id)sender{
    
    [_curProxy pasteElecLevelSet];
    [self updateElecLevelUIVals];
    
}
- (void) onClearData:(id)sender{
    
    [_curProxy clearElecLevelSet];
    [self updateElecLevelUIVals];
}

@end



