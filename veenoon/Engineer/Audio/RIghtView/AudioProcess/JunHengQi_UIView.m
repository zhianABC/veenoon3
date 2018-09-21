//
//  JunHengQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "JunHengQi_UIView.h"
#import "veenoon-Swift.h"
#import "SlideButton.h"

@interface JunHengQi_UIView ()<SlideButtonDelegate, MixFilterGraphViewDelegate> {
   
    UILabel *jhGainLabel;
   
    SlideButton *btnJH;
    
    NSMutableArray *_peqRateArray;
    int _peqMin;
    int _peqMax;
    
    MixFilterGraphView *fglm;
    
    int _curIndex;
}
@end

@implementation JunHengQi_UIView
@synthesize _currentObj;
@synthesize ctrl;

-(id) initWithFrame:(CGRect)frame withAudiMix:(AudioEMix*) audioMix
{
    if(self = [super initWithFrame:frame])
    {
       self._currentObj = audioMix;
        
        CGRect rc = CGRectMake(0, 40, frame.size.width, 320);
        UIView *bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR;
        
        
        rc = CGRectMake(10, 50, frame.size.width-20, 300);
        fglm = [[MixFilterGraphView alloc] initWithFrame:rc];
        fglm.backgroundColor = [UIColor clearColor];
        [self addSubview:fglm];
        fglm.delegate = self;
        
        int startH = CGRectGetMaxY(fglm.frame);
        int startX = 420;
        
        btnJH = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33,
                                                                 startH+30,
                                                                 120, 120)];
        btnJH._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
        btnJH._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
        [btnJH enableValueSet:YES];
        btnJH.delegate = self;
        [self addSubview:btnJH];
        
        NSMutableDictionary *peqDic = [_currentObj._proxyObj getPEQMinMax];
        _peqRateArray = [peqDic objectForKey:@"RATE"];
        
        _curIndex = 0;
        
        _peqMax = [[peqDic objectForKey:@"max"] intValue];
        _peqMin = [[peqDic objectForKey:@"min"] intValue];
        
        [fglm setValidGainRangeWithMax:_peqMax min:_peqMin];
        
        NSString *peqStr = _currentObj._proxyObj._mixPEQ;
        float highValue = [peqStr floatValue];
        float highMax = (_peqMax - _peqMin);
        if(highMax)
        {
            float f = (highValue - _peqMin)/highMax;
            f = fabsf(f);
            [btnJH setCircleValue:f];
        }
        
        jhGainLabel = [[UILabel alloc] init];
        jhGainLabel.text = [NSString stringWithFormat:@"%0.1f dB", [peqStr floatValue]];
        jhGainLabel.font = [UIFont systemFontOfSize: 13];
        jhGainLabel.textColor = [UIColor whiteColor];
        jhGainLabel.frame = CGRectMake(0, CGRectGetMaxY(btnJH.frame), 60, 20);
        [self addSubview:jhGainLabel];
        jhGainLabel.textAlignment = NSTextAlignmentCenter;
        jhGainLabel.layer.cornerRadius = 5;
        jhGainLabel.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR;
        jhGainLabel.center = CGPointMake(btnJH.center.x, jhGainLabel.center.y);
        jhGainLabel.clipsToBounds = YES;
     
        UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnEdit];
        btnEdit.frame = CGRectMake(CGRectGetMinX(jhGainLabel.frame),
                                   CGRectGetMinY(jhGainLabel.frame)-15,
                                   60,
                                   50);
        [btnEdit addTarget:self
                    action:@selector(editGainAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self drawGraphic];
    }
    
    return self;
}

- (void) editGainAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"增益，范围(%d ~ %d)",
                       _peqMin,
                       _peqMax];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"增益";
        textField.text = @"";//jhGainLabel.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(JunHengQi_UIView);

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetJHGainValue:[val floatValue]];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    
    [self.ctrl presentViewController:alertController
                            animated:YES
                          completion:nil];
}

- (void) doSetJHGainValue:(float)val{
    
    if(val < _peqMin)
        val = _peqMin;
    if(val > _peqMax)
        val = _peqMax;
    
    float max = _peqMax - _peqMin;
    if(max)
    {
        float gtVal = (val - _peqMin)/max;
        [btnJH setCircleValue:gtVal];
    }
    
    int gv = val;
    jhGainLabel.text = [NSString stringWithFormat:@"%d dB", gv];
    
    if(_curIndex < [_peqRateArray count])
    {
        id rateKey = [_peqRateArray objectAtIndex:_curIndex];
        [_currentObj._proxyObj controlMixPEQ:[NSString stringWithFormat:@"%0.0f", val]
                                    withRate:rateKey];
    }
    
    [fglm setPEQWithBand:_curIndex
                    gain:val];
    
}



- (void) drawGraphic{
    
    NSDictionary *waves16_feq_gain_q = _currentObj._proxyObj._pointsData;
    for(id band in [waves16_feq_gain_q allKeys])
    {
        int gain = [[waves16_feq_gain_q objectForKey:band] intValue];
       
        int idx =  (int)[_peqRateArray indexOfObject:band];
       
        if(idx < [_peqRateArray count] && idx >= 0)
        {
            [fglm setPEQWithBand:idx
                            gain:gain];
        }
    }
    
   // [fglm refreshUI];
}

#pragma mark -- SlideButton delegate ---

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float k = (value *(_peqMax-_peqMin)) + _peqMin;
    int gv = k;
    jhGainLabel.text = [NSString stringWithFormat:@"%d dB", gv];
    
    if(_curIndex < [_peqRateArray count])
    {
        id rateKey = [_peqRateArray objectAtIndex:_curIndex];
        [_currentObj._proxyObj controlMixPEQ:[NSString stringWithFormat:@"%d", gv]
                                    withRate:rateKey];
    }
    
    [fglm setPEQWithBand:_curIndex
                    gain:k];
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    IMP_BLOCK_SELF(JunHengQi_UIView);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(200.0 * NSEC_PER_MSEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [block_self didSlideButtonValueChanged:value slbtn:slbtn];
                   });
}


#pragma mark --- filterGraphView --
- (void)filterGraphViewPEQFilterBandChoosedWithBand:(NSInteger)band{
    
    _curIndex = (int)band;
    
    if(_curIndex < [_peqRateArray count])
    {
        id rateKey = [_peqRateArray objectAtIndex:_curIndex];
        float gain = [[_currentObj._proxyObj gainWithPEQWithBand:rateKey] floatValue];
    
        float highMax = (_peqMax - _peqMin);
        if(highMax)
        {
            float f = (gain - _peqMin)/highMax;
            f = fabsf(f);
            [btnJH setCircleValue:f];
            
            int gv = gain;
            jhGainLabel.text = [NSString stringWithFormat:@"%d dB", gv];
        }
    }
    
    
}
- (void)filterGraphViewPEQFilterChangedWithBand:(NSInteger)band freq:(float)freq gain:(float)gain{
    
    _curIndex = (int)band;
    
    if(_curIndex < [_peqRateArray count])
    {
        id rateKey = [_peqRateArray objectAtIndex:_curIndex];

        int gv = gain;
        [_currentObj._proxyObj controlMixPEQ:[NSString stringWithFormat:@"%d", gv]
                                    withRate:rateKey];
        
        float highMax = (_peqMax - _peqMin);
        if(highMax)
        {
            float f = (gain - _peqMin)/highMax;
            f = fabsf(f);
            [btnJH setCircleValue:f];
            
            
            jhGainLabel.text = [NSString stringWithFormat:@"%d dB", gv];
        }
    }
}

- (void)filterGraphViewPEQFilterChangedWithBand:(NSInteger)band qIndex:(NSInteger)qIndex qValue:(float)qValue{
    
    
}

@end
