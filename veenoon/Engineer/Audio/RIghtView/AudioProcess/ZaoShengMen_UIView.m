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
        fazhiL.text = zengyiDB;
    }
    
    NSString *startTime = [_curProxy getZaoshengStartTime];
    int startTimeV = [startTime intValue];
    
    float maxS = (maxStartDur- minStartDur);
    if(maxS)
    {
        float f = (startTimeV - minStartDur)/maxS;
        f = fabsf(f);
        [qidongshijianSlider setCircleValue:f];
    }
    
    qidongshijianL.text = startTime;
    
    NSString *huifuTime = [_curProxy getZaoshengRecoveryTime];
    int huifuTimeValue = [huifuTime floatValue];
    
    max = (maxRecoveDur - minRecoveDur);
    if(max)
    {
        float f = (huifuTimeValue - minRecoveDur)/max;
        f = fabsf(f);
        [huifushijianSlider setCircleValue:f];
    }
    
    huifushijianL.text = [NSString stringWithFormat:@"%d", huifuTimeValue];
    
    BOOL isFanKuiYiZhi = [_curProxy isZaoshengStarted];
    
    if(isFanKuiYiZhi)
    {
        [qiyongBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [qiyongBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
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
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
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
    
    
    fazhiL = [[UILabel alloc] initWithFrame:CGRectMake(startX+30, labelY+labelBtnGap+120, 60, 20)];
    fazhiL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:fazhiL];
    fazhiL.font = [UIFont systemFontOfSize:13];
    fazhiL.textColor = NEW_ER_BUTTON_SD_COLOR;
    fazhiL.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR2;
    fazhiL.layer.cornerRadius = 5;
    fazhiL.clipsToBounds=YES;
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(fazhiL.frame),
                               CGRectGetMinY(fazhiL.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editGainAction:)
      forControlEvents:UIControlEventTouchUpInside];

    
    
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
    
    qidongshijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap+30, labelY+labelBtnGap+120, 60, 20)];
    qidongshijianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:qidongshijianL];
    qidongshijianL.font = [UIFont systemFontOfSize:13];
    qidongshijianL.textColor = NEW_ER_BUTTON_SD_COLOR;
    qidongshijianL.layer.cornerRadius=5;
    qidongshijianL.clipsToBounds=YES;
    qidongshijianL.backgroundColor=NEW_ER_BUTTON_GRAY_COLOR2;
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(qidongshijianL.frame),
                               CGRectGetMinY(qidongshijianL.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editSTAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
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
    
    huifushijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap*2+30, labelY+labelBtnGap+120, 60, 20)];
    huifushijianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:huifushijianL];
    huifushijianL.font = [UIFont systemFontOfSize:13];
    huifushijianL.textColor = NEW_ER_BUTTON_SD_COLOR;
    huifushijianL.layer.cornerRadius=5;
    huifushijianL.clipsToBounds=YES;
    huifushijianL.backgroundColor=NEW_ER_BUTTON_GRAY_COLOR2;
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(huifushijianL.frame),
                               CGRectGetMinY(huifushijianL.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editRTAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    qiyongBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:THEME_RED_COLOR];
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


- (void) editGainAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"设置增益，范围[%d ~ %d(dB)]", minTh, maxTh];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"增益";
        textField.text = fazhiL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    
    IMP_BLOCK_SELF(ZaoShengMen_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetGainValue:[val floatValue]];
        }
    }]];
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) editSTAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"启动时间，范围[%d ~ %d(ms)]", minStartDur, maxStartDur];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"启动时间";
        textField.text = qidongshijianL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    
    IMP_BLOCK_SELF(ZaoShengMen_UIView);
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetSTValue:[val floatValue]];
        }
    }]];
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) editRTAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"设置回复时间，范围[%d ~ %d(dB)]", minRecoveDur, maxRecoveDur];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"恢复时间";
        textField.text = huifushijianL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    
    IMP_BLOCK_SELF(ZaoShengMen_UIView);
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetRTValue:[val floatValue]];
        }
    }]];
    
    [self.ctrl presentViewController:alertController
                            animated:YES
                          completion:nil];
}

- (void) doSetGainValue:(float)val{
    
    int fv = val;
    if(fv < minTh)
        fv = minTh;
    else if(fv > maxTh)
        fv = maxTh;
    
    float max = (maxTh - minTh);
    if(max)
    {
        float f = (fv - minTh)/max;
        f = fabsf(f);
        [fazhiSlider setCircleValue:f];
    }
    
    NSString *valueStr= [NSString stringWithFormat:@"%d", fv];
    fazhiL.text = valueStr;
    [_curProxy controlZaoshengFazhi:[NSString stringWithFormat:@"%d", fv]];
}

- (void) doSetSTValue:(float)val{
    
    int fv = val;
    if(fv < minStartDur)
        fv = minStartDur;
    else if(fv > maxStartDur)
        fv = maxStartDur;
    
    float max = (maxStartDur - minStartDur);
    if(max)
    {
        float f = (fv - minStartDur)/max;
        f = fabsf(f);
        [qidongshijianSlider setCircleValue:f];
    }
    
    NSString *valueStr = [NSString stringWithFormat:@"%d", fv];
    qidongshijianL.text = [NSString stringWithFormat:@"%@",valueStr];;
    [_curProxy controlZaoshengStartTime:valueStr];
}

- (void) doSetRTValue:(float)val{
    
    int fv = val;
    if(fv < minRecoveDur)
        fv = minRecoveDur;
    else if(fv > maxRecoveDur)
        fv = maxRecoveDur;
    
    float max = (maxRecoveDur - minRecoveDur);
    if(max)
    {
        float f = (fv - minRecoveDur)/max;
        f = fabsf(f);
        [huifushijianSlider setCircleValue:f];
    }
    
    NSString *valueStr = [NSString stringWithFormat:@"%d", fv];
    huifushijianL.text = [NSString stringWithFormat:@"%@",valueStr];;
    [_curProxy controlZaoshengRecoveryTime:valueStr];
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        
        int k = (value *(maxTh-minTh)) + minTh;
        NSString *valueStr = [NSString stringWithFormat:@"%d", k];
        fazhiL.text = valueStr;
        [_curProxy controlZaoshengFazhi:[NSString stringWithFormat:@"%d", k]];
        
    } else if (tag == 2) {
        
        int k = (value *(maxStartDur-minStartDur)) + minStartDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        qidongshijianL.text = [NSString stringWithFormat:@"%@",valueStr];;
        
        [_curProxy controlZaoshengStartTime:valueStr];
    } else {
        int k = (value *(maxRecoveDur-minRecoveDur)) + minRecoveDur;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        huifushijianL.text = [NSString stringWithFormat:@"%@",valueStr];;
        
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
        [qiyongBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

- (void) onCopyData:(id)sender{
    
    [_curProxy copyNosieGate];
}
- (void) onPasteData:(id)sender{
    
    [_curProxy pasteNosieGate];
    
    [self updateZaoShengMen];
}
- (void) onClearData:(id)sender{
    
    [_curProxy clearNosieGate];
    [self updateZaoShengMen];
}


@end


