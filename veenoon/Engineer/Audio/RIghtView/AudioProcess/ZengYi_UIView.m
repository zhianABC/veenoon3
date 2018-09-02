//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ZengYi_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "RegulusSDK.h"
#import "VAProcessorProxys.h"
#import "TeslariaComboChooser.h"

@interface ZengYi_UIView() <SlideButtonDelegate,VAProcessorProxysDelegate>{
    
    UIButton *channelBtn;
    SlideButton *btnJH2;
    
    UIPopoverController *_deviceSelector;
    
    UILabel *zaoshengL;
    UIButton *muteBtn;
    UIButton *fanxiangBtn;
    UIButton *lineBtn;
    UIButton *foureivBtn;
    UIButton *bianzuBtn;
    UIButton *zerodbBtn;
    
    int _curSelectorIndex;
    
    int maxTh;
    int minTh;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;

@end


@implementation ZengYi_UIView
@synthesize _curProxy;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame withProxy:(NSArray *)proxys
{
    if(self = [super initWithFrame:frame])
    {
        self._proxys = proxys;
        
        if ([self._proxys count]) {
            self._curProxy = [self._proxys objectAtIndex:0];
        }
        
        channelBtn = [UIButton buttonWithColor:nil selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 300, 36);
        channelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [channelBtn setTitle:@"In 1" forState:UIControlStateNormal];
        [channelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+10;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
        
        maxTh = 12;
        minTh = -56;
       
        [self contentViewComps];
        
        [self createContentViewBtns];
    }
    
    return self;
}


- (void) onCopyData:(id)sender{
    
    [_curProxy copyZengYi];
}
- (void) onPasteData:(id)sender{
    
    [_curProxy pasteZengYi];
    [self updateCurrentStateData];
}
- (void) onClearData:(id)sender{
    
    [_curProxy clearZengYi];
    [self updateCurrentStateData];
}

- (void) channelBtnAction:(UIButton*)sender{
    
    int idx = (int)sender.tag;
    self._curProxy = [self._proxys objectAtIndex:idx];

    NSString *name = _curProxy._rgsProxyObj.name;
    [channelBtn setTitle:name forState:UIControlStateNormal];
    
    [_curProxy checkRgsProxyCommandLoad];
    
    for(UIButton * btn in _channelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
        }
    }
    
    
    [self updateCurrentStateData];
    
}

- (void) updateProxyCommandValIsLoaded {
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
}

- (void) didLoadedProxyCommand {
    
    _curProxy.delegate = nil;
    
    NSDictionary *result = [_curProxy getDeviceDigitalGain];
    
    maxTh = [[result objectForKey:@"max"] intValue];
    minTh = [[result objectForKey:@"min"] intValue];
    
    [self updateCurrentStateData];
}

- (void) updateCurrentStateData {
    float kdb = [_curProxy getDigitalGain];
    float max = (maxTh - minTh);
    if(max)
    {
        float f = (kdb - minTh)/max;
        f = fabsf(f);
        [btnJH2 setCircleValue:f];
    }
    
    NSString *valueStr= [NSString stringWithFormat:@"%0.1fdB", kdb];
    zaoshengL.text = valueStr;
    
    [lineBtn setTitle:_curProxy._mode
             forState:UIControlStateNormal];
    
    [self updateMuteButtonState];
    [self update48VButtonState];
    [self updateInvertButtonState];
    
    [zerodbBtn setTitle:_curProxy._micDb
               forState:UIControlStateNormal];
    NSString *mode = [_curProxy getDeviceMode];
    if([mode isEqualToString:@"MIC"])
    {
        foureivBtn.alpha = 1;
        foureivBtn.enabled = YES;
        
        zerodbBtn.alpha = 1;
        zerodbBtn.enabled = YES;
    }
    else
    {
        foureivBtn.alpha = 0.8;
        foureivBtn.enabled = NO;
        
        zerodbBtn.alpha = 0.8;
        zerodbBtn.enabled = NO;
    }
}

- (void) updateMuteButtonState{
    
    BOOL isMute = [_curProxy isProxyDigitalMute];
    
    if(isMute)
    {
        [muteBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [muteBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

- (void) updateInvertButtonState{
    
    BOOL isInverted = [_curProxy getInverted];
    
    if(isInverted)
    {
        [fanxiangBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [fanxiangBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

- (void) contentViewComps{
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"增益 (dB)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(735, 80, 120, 20);
    [contentView addSubview:addLabel];
    
    
    btnJH2 = [[SlideButton alloc] initWithFrame:CGRectMake(700, 205, 120, 120)];
    btnJH2._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    btnJH2._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [btnJH2 enableValueSet:YES];
    btnJH2.delegate = self;
    btnJH2.tag = 2;
    [self addSubview:btnJH2];
    
    zaoshengL = [[UILabel alloc] initWithFrame:CGRectMake(730, 135+100, 60, 20)];
    zaoshengL.text = @"-12dB";
    zaoshengL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:zaoshengL];
    zaoshengL.font = [UIFont systemFontOfSize:13];
    zaoshengL.textColor = NEW_ER_BUTTON_SD_COLOR;
    zaoshengL.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR2;
    zaoshengL.layer.cornerRadius = 5;
    zaoshengL.clipsToBounds=YES;
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float k = (value *(maxTh-minTh)) + minTh;
    NSString *valueStr= [NSString stringWithFormat:@"%0.1f dB", k];
    
    zaoshengL.text = valueStr;
    
    [_curProxy controlDeviceDigitalGain:[valueStr floatValue]];
}

- (void) createContentViewBtns {
    
    int btnStartX = 100;
    int btnY = 150;
    
    lineBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    lineBtn.frame = CGRectMake(btnStartX, btnY, 120, 30);
    lineBtn.layer.cornerRadius = 5;
    lineBtn.layer.borderWidth = 2;
    lineBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lineBtn.clipsToBounds = YES;
    //[lineBtn setTitle:@"线路" forState:UIControlStateNormal];
    [lineBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10,0,0)];
    
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
    
    
    muteBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    muteBtn.frame = CGRectMake(CGRectGetMaxX(lineBtn.frame)+10, btnY, 50, 30);
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
    
    
    zerodbBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_GRAY_COLOR3];
    zerodbBtn.frame = CGRectMake(CGRectGetMaxX(muteBtn.frame)+20, btnY, 120, 30);
    zerodbBtn.layer.cornerRadius = 5;
    zerodbBtn.layer.borderWidth = 2;
    zerodbBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zerodbBtn.clipsToBounds = YES;
    [zerodbBtn setTitle:@"0 dB" forState:UIControlStateNormal];
    [zerodbBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,10,0,0)];
    zerodbBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    zerodbBtn.alpha = 0.8;
    zerodbBtn.enabled = NO;
    zerodbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon2 = [[UIImageView alloc]
                         initWithFrame:CGRectMake(zerodbBtn.frame.size.width - 20, 10, 10, 10)];
    icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
    [zerodbBtn addSubview:icon2];
    icon2.layer.contentsGravity = kCAGravityResizeAspect;
    [contentView addSubview:zerodbBtn];
    
    [zerodbBtn addTarget:self
                action:@selector(micDbBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    foureivBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_GRAY_COLOR3];
    foureivBtn.frame = CGRectMake(CGRectGetMaxX(zerodbBtn.frame)+10, btnY, 50, 30);
    foureivBtn.layer.cornerRadius = 5;
    foureivBtn.layer.borderWidth = 2;
    foureivBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    foureivBtn.clipsToBounds = YES;
    [foureivBtn setTitle:@"  48V" forState:UIControlStateNormal];
    foureivBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    foureivBtn.alpha = 0.8;
    foureivBtn.enabled = NO;
    foureivBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contentView addSubview:foureivBtn];
    
    [foureivBtn addTarget:self
                action:@selector(f48vBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    bianzuBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    bianzuBtn.frame = CGRectMake(CGRectGetMaxX(foureivBtn.frame)+20, btnY, 120, 30);
    bianzuBtn.layer.cornerRadius = 5;
    bianzuBtn.layer.borderWidth = 2;
    bianzuBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    bianzuBtn.clipsToBounds = YES;
    [bianzuBtn setTitle:@"  编组" forState:UIControlStateNormal];
    bianzuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bianzuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon3 = [[UIImageView alloc]
                         initWithFrame:CGRectMake(bianzuBtn.frame.size.width - 20, 10, 10, 10)];
    icon3.image = [UIImage imageNamed:@"remote_video_down.png"];
    [bianzuBtn addSubview:icon3];
    icon3.layer.contentsGravity = kCAGravityResizeAspect;
    [bianzuBtn addTarget:self
                action:@selector(bianzuAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:bianzuBtn];
    
    
    fanxiangBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    fanxiangBtn.frame = CGRectMake(CGRectGetMaxX(bianzuBtn.frame)+10, btnY, 50, 30);
    fanxiangBtn.layer.cornerRadius = 5;
    fanxiangBtn.layer.borderWidth = 2;
    fanxiangBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    fanxiangBtn.clipsToBounds = YES;
    [fanxiangBtn setTitle:@"反相" forState:UIControlStateNormal];
    fanxiangBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [fanxiangBtn addTarget:self
                action:@selector(fanxiangAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:fanxiangBtn];
}

- (void) update48VButtonState{
    
    BOOL is48V = _curProxy._is48V;
    
    if(is48V)
    {
        [foureivBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [foureivBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

- (void) f48vBtnAction:(UIButton*)sender{
    
    if(_curProxy == nil)
        return;
    
    BOOL is48v = _curProxy._is48V;
    
    [_curProxy control48V:!is48v];
    
    [self update48VButtonState];

}

-(void) fanxiangAction:(id) sender {
    
    if(_curProxy == nil)
        return;
    
    BOOL isInverted = [_curProxy getInverted];
    
    [_curProxy controlInverted:!isInverted];
    
    [self updateInvertButtonState];
    
}
-(void) bianzuAction:(id) sender {
    
}

- (void) micDbBtnAction:(UIButton*) sender {

    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    TeslariaComboChooser *sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = [_curProxy getMicDbOptions];;
    sel._type = 6;
    
    int h = (int)[sel._dataArray count]*30 + 50;
    
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(ZengYi_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseMic:object idx:index];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:[sender superview]];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void) chooseMic:(NSString*)device idx:(int)index {
    [zerodbBtn setTitle:device forState:UIControlStateNormal];
    
    if(_curProxy)
    {
        [_curProxy controlDeviceMicDb:device];
    }
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
}



-(void) lineBtnAction:(UIButton*) sender {
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    TeslariaComboChooser *sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = [_curProxy getModeOptions];;
    sel._type = 5;
    
    int h = (int)[sel._dataArray count]*30 + 50;
    
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(ZengYi_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseLine:object idx:index];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:[sender superview]];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseLine:(NSString*)device idx:(int)index {
    [zerodbBtn setTitle:device forState:UIControlStateNormal];
    
    [lineBtn setTitle:device forState:UIControlStateNormal];
    
    if(_curProxy)
    {
        [_curProxy controlDeviceMode:device];
    }
    
    if([device isEqualToString:@"MIC"])
    {
        foureivBtn.alpha = 1;
        foureivBtn.enabled = YES;
        
        zerodbBtn.alpha = 1;
        zerodbBtn.enabled = YES;
    }
    else
    {
        foureivBtn.alpha = 0.8;
        foureivBtn.enabled = NO;
        
        zerodbBtn.alpha = 0.8;
        zerodbBtn.enabled = NO;
    }
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
}

-(void) muteBtnAction:(id) sender {
    
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy isProxyDigitalMute];
    
    [_curProxy controlDigtalMute:!isMute];
    
    [self updateMuteButtonState];
}

@end

