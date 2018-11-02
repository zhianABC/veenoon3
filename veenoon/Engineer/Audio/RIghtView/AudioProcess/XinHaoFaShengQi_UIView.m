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
        channelBtn = [UIButton buttonWithColor:nil selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 70, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (self._currentSignalProxy && self._currentSignalProxy._rgsProxyObj) {
            [channelBtn setTitle:self._currentSignalProxy._rgsProxyObj.name forState:UIControlStateNormal];
        } else {
            [channelBtn setTitle:@"Out 1" forState:UIControlStateNormal];
        }
        
        [channelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        
        self._currentAudio = audioProcessor;
        self._currentSignalProxy = proxy;
        
        
        outputChanels = [NSMutableArray array];
        
        outputSelectedBtns = [NSMutableArray array];
        
        int y = CGRectGetMaxY(channelBtn.frame)+10;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
        
        [self contentViewComps];
        
        self.showOpMenus = NO;
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
        zengyiL.text = zengyiDB;
    }
    
    NSString *pinlvDB = [_currentSignalProxy getXinhaofashengPinlv];
    int value2 = [pinlvDB intValue];
    float max2 = (maxRate - minRate);
    if(max2)
    {
        float f2 = (value2 - minRate)/max2;
        f2 = fabsf(f2);
        [xinhaoPinlvSlider setCircleValue:f2];
    }
    
    if (pinlvDB) {
        zhengxuanboL.text = [NSString stringWithFormat:@"%d", value2];
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
        [xinhaoMuteBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    if([_currentSignalProxy._xinhaofashengOutputChanels count])
    {
        for(int idx = 0; idx < [_channelBtns count]; idx++)
        {
            int tag = idx+1;
            
            UIButton *btn = [_channelBtns objectAtIndex:idx];
            
            NSString *valName = [NSString stringWithFormat:@"Out%d", tag];
            
            BOOL isEnable = NO;
            
            id state = [_currentSignalProxy._xinhaofashengOutputChanels objectForKey:valName];
            if(state){
                isEnable = [state boolValue];
            }
            
            if(isEnable)
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
    }
}
- (void) contentViewComps{
    
    int btnY = 150;
    int btnX = 200;
    
    int topY = 100;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"频率 (Hz)";
    addLabel2.font = [UIFont boldSystemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(btnX+30, 120+topY, 120, 20);
    [self addSubview:addLabel2];
    
    xinhaoPinlvSlider = [[SlideButton alloc] initWithFrame:CGRectMake(btnX, 135+topY, 120, 120)];
    xinhaoPinlvSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xinhaoPinlvSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xinhaoPinlvSlider enableValueSet:YES];
    xinhaoPinlvSlider.delegate = self;
    xinhaoPinlvSlider.tag = 3;
    [self addSubview:xinhaoPinlvSlider];
    
    zhengxuanboL = [[UILabel alloc] initWithFrame:CGRectMake(btnX+30-10, 135+110+topY, 80, 20)];
    zhengxuanboL.text = @"0";
    zhengxuanboL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:zhengxuanboL];
    zhengxuanboL.font = [UIFont systemFontOfSize:13];
    zhengxuanboL.textColor = NEW_ER_BUTTON_SD_COLOR;
    zhengxuanboL.layer.cornerRadius=5;
    zhengxuanboL.clipsToBounds=YES;
    zhengxuanboL.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR2;
    
    UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(zhengxuanboL.frame),
                               CGRectGetMinY(zhengxuanboL.frame)-15,
                               80,
                               50);
    [btnEdit addTarget:self
                action:@selector(editFreqAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    zerodbBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    zerodbBtn.frame = CGRectMake(CGRectGetMaxX(zhengxuanboL.frame)+90, btnY+30+topY, 120, 30);
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
    
    
    xinhaoMuteBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    xinhaoMuteBtn.frame = CGRectMake(CGRectGetMaxX(zerodbBtn.frame)+10, btnY+30+topY, 50, 30);
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
    addLabel.frame = CGRectMake(660, 120+topY, 120, 20);
    [self addSubview:addLabel];
    
    xinhaoZengyiSlider = [[SlideButton alloc] initWithFrame:CGRectMake(630, 135+topY, 120, 120)];
    xinhaoZengyiSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xinhaoZengyiSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xinhaoZengyiSlider enableValueSet:YES];
    xinhaoZengyiSlider.delegate = self;
    xinhaoZengyiSlider.tag = 2;
    [self addSubview:xinhaoZengyiSlider];
    
    zengyiL = [[UILabel alloc] initWithFrame:CGRectMake(660, 135+110+topY, 60, 20)];
    zengyiL.text = @"1";
    zengyiL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:zengyiL];
    zengyiL.font = [UIFont systemFontOfSize:13];
    zengyiL.textColor = NEW_ER_BUTTON_SD_COLOR;
    zengyiL.layer.cornerRadius=5;
    zengyiL.clipsToBounds=YES;
    zengyiL.backgroundColor=NEW_ER_BUTTON_GRAY_COLOR2;
    
    btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnEdit];
    btnEdit.frame = CGRectMake(CGRectGetMinX(zengyiL.frame),
                               CGRectGetMinY(zengyiL.frame)-15,
                               60,
                               50);
    [btnEdit addTarget:self
                action:@selector(editDbAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) editFreqAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"频率，范围[%d ~ %d(Hz)]",
                       minRate,
                       maxRate];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"频率";
        textField.text = zhengxuanboL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(XinHaoFaShengQi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetFreqValue:[val intValue]];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
    
}

- (void) doSetFreqValue:(int)val{
    
    int freq = val;
    
    if(freq < minRate)
        freq = minRate;
    if(freq > maxRate)
        freq = maxRate;
    
    if(maxRate - minRate)
    {
        float gtVal = (float)(freq - minRate)/(maxRate - minRate);
        [xinhaoPinlvSlider setCircleValue:gtVal];
    }
    
    NSString *freqStr = [NSString stringWithFormat:@"%d", freq];
    
    zhengxuanboL.text = freqStr;
    [_currentSignalProxy controlXinhaofashengZengYi:freqStr];
    
}

- (void) editDbAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"增益，范围[%d ~ %d(dB)]",
                       minZengyi,
                       maxZengyi];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"增益";
        textField.text = zengyiL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(XinHaoFaShengQi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetDbValue:[val intValue]];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) doSetDbValue:(int)val{
    
    int db = val;
    
    if(db < minZengyi)
        db = minZengyi;
    if(db > maxZengyi)
        db = maxZengyi;
    
    if(maxZengyi - minZengyi)
    {
        float gtVal = (float)(db - minZengyi)/(maxZengyi - minZengyi);
        [xinhaoZengyiSlider setCircleValue:gtVal];
    }
    
    NSString *dbStr = [NSString stringWithFormat:@"%d", db];
    
    zengyiL.text = dbStr;
    [_currentSignalProxy controlXinhaofashengZengYi:dbStr];
    
}


- (void) channelBtnAction:(UIButton*)sender{
    
    int idx = (int)sender.tag;
    int tag = idx+1;
    
    NSString *show = [NSString stringWithFormat:@"Out %d", tag];
    NSString *valName = [NSString stringWithFormat:@"Out%d", tag];
    
    [channelBtn setTitle:show forState:UIControlStateNormal];
    
    BOOL isEnable = NO;
    
    id state = [_currentSignalProxy._xinhaofashengOutputChanels objectForKey:valName];
    if(state){
       isEnable = [state boolValue];
    }
    
    isEnable = !isEnable;
    
    [_currentSignalProxy controlSignalWithOutState:valName
                                         withState:isEnable];
    
    if(isEnable)
    {
        [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
        [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    }
    else
    {
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
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
    BOOL isEnable = NO;
    if (selectedBtn) {
        [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [selectedBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
        [outputSelectedBtns removeObject:selectedBtn];
        
        isEnable = NO;
    } else {
        [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        [outputSelectedBtns addObject:sender];
        
        isEnable = YES;
    }
    
    NSString *proxyName = sender.titleLabel.text;
    
    [_currentSignalProxy controlSignalWithOutState:proxyName
                                         withState:isEnable];
}


- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    int tag = (int) slbtn.tag;
    if (tag == 2) {
        float k = roundf((value *(maxZengyi-minZengyi)) + minZengyi);
        NSString *valueStr= [NSString stringWithFormat:@"%.f", k];
        
        zengyiL.text = valueStr;
        
        [_currentSignalProxy controlXinhaofashengZengYi:[NSString stringWithFormat:@"%.f", k]];
    } else {
        float k = roundf((value *(maxRate-minRate)) + minRate);
        NSString *valueStr= [NSString stringWithFormat:@"%.f", k];
        
        zhengxuanboL.text = valueStr;
        
        [_currentSignalProxy controlXinhaofashengPinlv:[NSString stringWithFormat:@"%.f", k]];
    }
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        [self didSlideButtonValueChanged:value slbtn:slbtn];
    });
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
        [xinhaoMuteBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

@end


