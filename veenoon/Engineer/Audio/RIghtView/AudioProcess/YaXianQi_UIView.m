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
    
    UILabel *gainLabel;
    UILabel *qLabel;
    UILabel *sTimeLabel;
    UILabel *rTimeLabel;
    
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
    
    if(self = [super initWithFrame:frame])
    {
        self._proxys = proxys;
        
        if ([self._proxys count]) {
            self._curProxy = [self._proxys objectAtIndex:0];
        }
        
        channelBtn = [UIButton buttonWithColor:nil selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 300, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        channelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [channelBtn setTitle:_curProxy._rgsProxyObj.name forState:UIControlStateNormal];
        [channelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:channelBtn];
    
        int y = CGRectGetMaxY(channelBtn.frame)+10;
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
    
    [channelBtn setTitle:[NSString stringWithFormat:@"Out %d", tag] forState:UIControlStateNormal];
    
    for(UIButton * btn in _channelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
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
        gainLabel.text = zengyiDB;
    }
    
    //////
    NSString *xielv = [_curProxy getYaxianXielv];
    int xielvValue = [xielv floatValue];
    
    int maxR = (maxRadio- minRadio);
    if(maxR)
    {
        float f = (float)(xielvValue - minRadio)/maxR;
        f = fabsf(f);
        [xielvSlide setCircleValue:f];
    }
    
    [_limiter setRatioWithR:xielvValue];

    qLabel.text = xielv;
    
    
    NSString *startTime = [_curProxy getYaxianStartTime];
    float startTimeValue = [startTime floatValue];
    
    max = (maxStartDur - minStartDur);
    if(max)
    {
        float f = (startTimeValue - minStartDur)/max;
        f = fabsf(f);
        [qidongshijianSlide setCircleValue:f];
    }
    
    sTimeLabel.text = [NSString stringWithFormat:@"%0.0f", startTimeValue];
    
    
    NSString *huifuTime = [_curProxy getYaxianRecoveryTime];
    float huifuTimeValue = [huifuTime floatValue];
    
    max = (maxRecoveDur - minRecoveDur);
    if(max)
    {
        float f = (huifuTimeValue - minRecoveDur)/max;
        f = fabsf(f);
        [huifushijianSlide setCircleValue:f];
    }
    
    rTimeLabel.text = [NSString stringWithFormat:@"%0.0f", huifuTimeValue];
    
    BOOL isYaXianStarted = [_curProxy isYaXianStarted];
    
    if(isYaXianStarted)
    {
        [_enableStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [_enableStartBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

- (void) contentViewComps{
    
    int w = CGRectGetHeight(contentView.frame)*0.8;
    int m = w%5;
    w = w-m;
    
    int y = (CGRectGetHeight(contentView.frame) - w)/2;
    CGRect rc = CGRectMake(50, y+5, w, w);
    
    _limiter = [[LimiterView alloc] initWithFrame:rc];
    [contentView addSubview:_limiter];
    _limiter.backgroundColor = [UIColor clearColor];
    
    int x = CGRectGetMaxX(_limiter.frame);
    y = CGRectGetMinY(_limiter.frame)+30;
    x+=10;
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"阀值（dB）";
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
    

    gainLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+30, y+20+120, 60, 20)];
    gainLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:gainLabel];
    gainLabel.font = [UIFont systemFontOfSize:13];
    gainLabel.textColor = NEW_ER_BUTTON_SD_COLOR;
    gainLabel.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR2;
    gainLabel.layer.cornerRadius = 5;
    gainLabel.clipsToBounds=YES;
    
    UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(gainLabel.frame),
                               CGRectGetMinY(gainLabel.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editGainAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
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

    qLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+30, y+20+120, 60, 20)];
    qLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:qLabel];
    qLabel.font = [UIFont systemFontOfSize:13];
    qLabel.textColor = NEW_ER_BUTTON_SD_COLOR;
    qLabel.backgroundColor=NEW_ER_BUTTON_GRAY_COLOR2;
    qLabel.layer.cornerRadius = 5;
    qLabel.clipsToBounds=YES;
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(qLabel.frame),
                               CGRectGetMinY(qLabel.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editQAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
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
    
    sTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+30, y+20+120, 60, 20)];
    sTimeLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:sTimeLabel];
    sTimeLabel.font = [UIFont systemFontOfSize:13];
    sTimeLabel.textColor = YELLOW_COLOR;
    sTimeLabel.layer.cornerRadius=5;
    sTimeLabel.clipsToBounds=YES;
    sTimeLabel.backgroundColor=NEW_ER_BUTTON_GRAY_COLOR2;
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(sTimeLabel.frame),
                               CGRectGetMinY(sTimeLabel.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editSTAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
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
    
    rTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+30, y+20+120, 60, 20)];
    rTimeLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:rTimeLabel];
    rTimeLabel.font = [UIFont systemFontOfSize:13];
    rTimeLabel.textColor = YELLOW_COLOR;
    rTimeLabel.layer.cornerRadius=5;
    rTimeLabel.clipsToBounds=YES;
    rTimeLabel.backgroundColor=NEW_ER_BUTTON_GRAY_COLOR2;
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(rTimeLabel.frame),
                               CGRectGetMinY(rTimeLabel.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editRTAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    _enableStartBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:THEME_RED_COLOR];
    _enableStartBtn.frame = CGRectMake(contentView.frame.size.width/2 + 110,
                                       CGRectGetMaxY(rTimeLabel.frame)+30,
                                       50,
                                       30);
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


- (void) editGainAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"阀值，范围[%d ~ %d(dB)]",
                       minTh,
                       maxTh];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"阀值";
        textField.text = gainLabel.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(YaXianQi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetGainValue:[val intValue]];
        }
    }]];
    
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) doSetGainValue:(int)val{
    
    int gain = val;

    if(maxTh - minTh)
    {
        float gtVal = (float)(gain - minTh)/(maxTh - minTh);
        [fazhiSlider setCircleValue:gtVal];
    }
    
    gainLabel.text = [NSString stringWithFormat:@"%d", gain];
    
    [_limiter setThresHoldWithR:gain];
    [_curProxy controlYaxianFazhi:[NSString stringWithFormat:@"%d", gain]];
}

- (void) editQAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"斜率，范围(%d ~ %d)",
                       minRadio,
                       maxRadio];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"斜率";
        textField.text = qLabel.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(YaXianQi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetQValue:[val intValue]];
        }
    }]];
    
    
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) doSetQValue:(int)val{
    
    float max = maxRadio - minRadio;
    if(max)
    {
        float gtVal = (val - minRadio)/max;
        [xielvSlide setCircleValue:gtVal];
    }
    
    NSString *valueStr = [NSString stringWithFormat:@"%d", val];
    qLabel.text = valueStr;
    
    [_limiter setRatioWithR:val];
    [_curProxy controlYaxianXielv:valueStr];
    
}


- (void) editSTAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"启动时间，范围(%d ~ %d)",
                       minStartDur,
                       maxStartDur];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"启动时间";
        textField.text = sTimeLabel.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(YaXianQi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetSTValue:[val intValue]];
        }
    }]];
    
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) doSetSTValue:(int)val{
    
    float max = maxStartDur - minStartDur;
    if(max)
    {
        float gtVal = (val - minStartDur)/max;
        [qidongshijianSlide setCircleValue:gtVal];
    }
    
    NSString *valueStr = [NSString stringWithFormat:@"%d", val];
    sTimeLabel.text = valueStr;
    
    [_curProxy controlYaxianStartTime:valueStr];

}


- (void) editRTAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"恢复时间，范围(%d ~ %d)",
                       minRecoveDur,
                       maxRecoveDur];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"恢复时间";
        textField.text = rTimeLabel.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(YaXianQi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetRTValue:[val intValue]];
        }
    }]];
    
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) doSetRTValue:(int)val{
    
    float max = maxRecoveDur - minRecoveDur;
    if(max)
    {
        float gtVal = (val - minRecoveDur)/max;
        [huifushijianSlide setCircleValue:gtVal];
    }
    
    NSString *valueStr = [NSString stringWithFormat:@"%d", val];
    rTimeLabel.text = valueStr;
    
   [_curProxy controlYaxianRecoveryTime:valueStr];
    
}

- (void) enableStartBtnAction:(id) sender {
    BOOL isYaXianStarted = [_curProxy isYaXianStarted];
    
    isYaXianStarted = !isYaXianStarted;
    
    if(isYaXianStarted)
    {
        [_enableStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [_enableStartBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
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

#pragma mark -- SlideButton Delegate ----

- (void) processSlideValue:(float)value tag:(int)tag{
    
    if (tag == 1)
    {
        float k = (value *(maxTh-minTh)) + minTh;
        NSString *valueStr= [NSString stringWithFormat:@"%0.1f", k];
        
        gainLabel.text = valueStr;
        [_limiter setThresHoldWithR:k];
        [_curProxy controlYaxianFazhi:valueStr];
    }
    else if (tag == 2)
    {
        int k = (value * (maxRadio - minRadio)) + minRadio;
        NSString *valueStr = [NSString stringWithFormat:@"%d", k];
        
        qLabel.text = valueStr;
        [_limiter setRatioWithR:k];
        [_curProxy controlYaxianXielv:valueStr];
        
    }
    else if (tag == 3)
    {
        int k = (value *(maxStartDur - minStartDur)) + minStartDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        sTimeLabel.text = valueStr;
        [_curProxy controlYaxianStartTime:valueStr];
        
    }
    else
    {
        int k = (value *(maxRecoveDur - minRecoveDur)) + minRecoveDur;
        NSString *valueStr = [NSString stringWithFormat:@"%d", k];
        
        rTimeLabel.text = valueStr;
        [_curProxy controlYaxianRecoveryTime:valueStr];
    }
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    
    [self processSlideValue:value tag:tag];
}


- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    IMP_BLOCK_SELF(YaXianQi_UIView);
    
    int tag = (int) slbtn.tag;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(200.0 * NSEC_PER_MSEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [block_self processSlideValue:value tag:tag];
                   });
}


- (void) onCopyData:(id)sender{
    
    [_curProxy copyCompressorLimiter];
}
- (void) onPasteData:(id)sender{
    
    [_curProxy pasteCompressorLimiter];
    [self updateYaXianQi];
}
- (void) onClearData:(id)sender{
    
    [_curProxy clearCompressorLimiter];
    [self updateYaXianQi];
}

@end
