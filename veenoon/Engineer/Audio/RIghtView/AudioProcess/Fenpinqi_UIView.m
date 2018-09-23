//
//  Fenpinqi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "Fenpinqi_UIView.h"
#import "veenoon-Swift.h"
#import "SlideButton.h"


@interface Fenpinqi_UIView ()<SlideButtonDelegate, HLFilterGraphViewDelegate> {
    UILabel *_highFilterL;
    UILabel *_lowFilgerL;
    
    SlideButton *_highFilterSlider;
    SlideButton *_lowFilterSlider;
    
    int _highFilterMin;
    int _highFilterMax;
    int _lowFilterMin;
    int _lowFilterMax;
    
    HLFilterGraphView *fglm;
}
@end

@implementation Fenpinqi_UIView
@synthesize _currentObj;
@synthesize ctrl;


-(id) initWithFrame:(CGRect)frame withAudiMix:(AudioEMix*) audioMix {
   
    if(self = [super initWithFrame:frame]) {
        
        self._currentObj = audioMix;
        
        NSDictionary *highFilterDic = [_currentObj._proxyObj getHighFilterMinMax];
        _highFilterMin = [[highFilterDic objectForKey:@"min"] intValue];
        _highFilterMax = [[highFilterDic objectForKey:@"max"] intValue];
        
        
        NSDictionary *lowFilterDic = [_currentObj._proxyObj getLowFilterMinMax];
        _lowFilterMin = [[lowFilterDic objectForKey:@"min"] intValue];
        _lowFilterMax = [[lowFilterDic objectForKey:@"max"] intValue];
        
        
        CGRect rc = CGRectMake(0, 40, frame.size.width, 320);
        UIView *bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR;
        
        
        rc = CGRectMake(10, 50, frame.size.width-20, 300);
        fglm = [[HLFilterGraphView alloc] initWithFrame:rc];
        fglm.backgroundColor = [UIColor clearColor];
        [self addSubview:fglm];
        fglm.delegate = self;
        
        
        int startH = CGRectGetMaxY(fglm.frame) + 30;
        int startX = 180;
        
        UILabel *addLabel = [[UILabel alloc] init];
        addLabel.text = @"高通 (HP)";
        addLabel.font = [UIFont systemFontOfSize: 13];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.frame = CGRectMake(startX, startH+15, 120, 20);
        [self addSubview:addLabel];
        

        //50 - 250
        _highFilterSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33,
                                                                 CGRectGetMaxY(addLabel.frame),
                                                                 120, 120)];
        _highFilterSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
        _highFilterSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
        [_highFilterSlider enableValueSet:YES];
        _highFilterSlider.delegate = self;
        [self addSubview:_highFilterSlider];
        
        NSString *hightFilter = _currentObj._proxyObj._mixHighFilter;
        float highValue = [hightFilter floatValue];
        if(highValue < _highFilterMin)
            highValue = _highFilterMin;
        
        
        float highMax = (_highFilterMax - _highFilterMin);
        
        
        if(highMax)
        {
            float f = (highValue - _highFilterMin)/highMax;
            f = fabsf(f);
            [_highFilterSlider setCircleValue:f];
            
            [fglm setHPMaxMinFreqWithMaxfreq:_highFilterMax
                                     minfreq:_highFilterMin];
            
            [fglm setHPFilterWithFreq:highValue];
        }
        
        
        _highFilterL = [[UILabel alloc] init];
        //_highFilterL.text = [hightFilter stringByAppendingString:@" Hz"];
        _highFilterL.font = [UIFont systemFontOfSize: 13];
        _highFilterL.textColor = [UIColor whiteColor];
        _highFilterL.frame = CGRectMake(0, CGRectGetMaxY(_highFilterSlider.frame), 60, 20);
        [self addSubview:_highFilterL];
        _highFilterL.textAlignment = NSTextAlignmentCenter;
        _highFilterL.layer.cornerRadius = 5;
        _highFilterL.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR;
        _highFilterL.center = CGPointMake(_highFilterSlider.center.x, _highFilterL.center.y);
        _highFilterL.clipsToBounds = YES;
        
        UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnEdit];
        btnEdit.frame = CGRectMake(CGRectGetMinX(_highFilterL.frame),
                                   CGRectGetMinY(_highFilterL.frame)-15,
                                   60,
                                   50);
        [btnEdit addTarget:self
                    action:@selector(editHighFilterAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
        int gap = 450;
        
        UILabel *addLabel2 = [[UILabel alloc] init];
        addLabel2.text = @"低通 (LP)";
        addLabel2.font = [UIFont systemFontOfSize: 13];
        addLabel2.textColor = [UIColor whiteColor];
        addLabel2.frame = CGRectMake(startX+gap, startH+15, 120, 20);
        [self addSubview:addLabel2];
        
      
        //8 - 20
        _lowFilterSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33+gap,
                                                               CGRectGetMaxY(addLabel2.frame),
                                                               120, 120)];
        _lowFilterSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
        _lowFilterSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
        [_lowFilterSlider enableValueSet:YES];
        [self addSubview:_lowFilterSlider];
        _lowFilterSlider.delegate = self;
        
        NSString *lowFilter = _currentObj._proxyObj._mixLowFilter;
        int lowWalue = [lowFilter intValue]*1000;
        if(lowWalue < _lowFilterMin){
            lowWalue = _lowFilterMin;
            lowFilter = [NSString stringWithFormat:@"%d", _lowFilterMin];
        }
        float lowMax = (_lowFilterMax - _lowFilterMin);
        if(lowMax)
        {
            float f = (lowWalue - _lowFilterMin)/lowMax;
            f = fabsf(f);
            [_lowFilterSlider setCircleValue:f];
            
            [fglm setLPMaxMinFreqWithMaxfreq:_lowFilterMax
                                     minfreq:_lowFilterMin];
            
            [fglm setLPFilterWithFreq:lowWalue];
        }
        
        _lowFilgerL = [[UILabel alloc] init];
        _lowFilgerL.font = [UIFont systemFontOfSize: 13];
        _lowFilgerL.textColor = [UIColor whiteColor];
        _lowFilgerL.frame = CGRectMake(0, CGRectGetMaxY(_lowFilterSlider.frame), 60, 20);
        [self addSubview:_lowFilgerL];
        _lowFilgerL.textAlignment = NSTextAlignmentCenter;
        _lowFilgerL.layer.cornerRadius = 5;
        _lowFilgerL.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR;
        _lowFilgerL.center = CGPointMake(_lowFilterSlider.center.x, _lowFilgerL.center.y);
        _lowFilgerL.clipsToBounds = YES;
        
        btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnEdit];
        btnEdit.frame = CGRectMake(CGRectGetMinX(_lowFilgerL.frame),
                                   CGRectGetMinY(_lowFilgerL.frame)-15,
                                   60,
                                   50);
        [btnEdit addTarget:self
                    action:@selector(editLowFilterAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
        _highFilterL.text = [self fomartHzKHz:highValue];
        _lowFilgerL.text = [self fomartHzKHz:lowWalue];
        
    }
    
    return self;
}

- (NSString*) fomartHzKHz:(float)freq{
    
    NSString *hz = @"Hz";
    float showValue = freq;
    if(freq > 1000)
    {
        hz = @"KHz";
        showValue = freq/1000;
    }
    
   return [NSString stringWithFormat:@"%0.0f %@",
           showValue, hz];
}


- (void) editHighFilterAction:(id)sender{
    
    NSString *alert = [NSString stringWithFormat:@"高通频率，范围(%d ~ %d)",
                       _highFilterMin,
                       _highFilterMax];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"频率";
        textField.text = @"";//_highFilterL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(Fenpinqi_UIView);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetHighFilterValue:[val intValue]];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    
    [self.ctrl presentViewController:alertController
                            animated:YES
                          completion:nil];
}

- (void) doSetHighFilterValue:(int)val{
    
    if(val < _highFilterMin)
        val = _highFilterMin;
    if(val > _highFilterMax)
        val = _highFilterMax;
    
    float max = _highFilterMax - _highFilterMin;
    if(max)
    {
        float gtVal = (val - _highFilterMin)/max;
        [_highFilterSlider setCircleValue:gtVal];
    }
    
    _highFilterL.text = [self fomartHzKHz:val];
    
    [_currentObj._proxyObj controlHighFilter:[NSString stringWithFormat:@"%d", val]];
    [fglm setHPFilterWithFreq:val];
    
}


- (void) editLowFilterAction:(id)sender{
 
    NSString *alert = [NSString stringWithFormat:@"低通频率，范围(%d ~ %d)",
                       _lowFilterMin,
                       _lowFilterMax];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"频率";
        textField.text = @"";//_lowFilgerL.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(Fenpinqi_UIView);

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetLowFilterValue:[val intValue]];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    
    [self.ctrl presentViewController:alertController
                            animated:YES
                          completion:nil];
}


- (void) doSetLowFilterValue:(int)val{
    
    if(val < _lowFilterMin)
        val = _lowFilterMin;
    if(val > _lowFilterMax)
        val = _lowFilterMax;
    
    float max = _lowFilterMax - _lowFilterMin;
    if(max)
    {
        float gtVal = (val - _lowFilterMin)/max;
        [_lowFilterSlider setCircleValue:gtVal];
    }
    
    _lowFilgerL.text = [self fomartHzKHz:val];
    
    int ctrlVal = val/1000;
    [_currentObj._proxyObj controlHighFilter:[NSString stringWithFormat:@"%d", ctrlVal]];
    
    [fglm setHPFilterWithFreq:val];
    
}

#pragma mark --- SlideButton Delegate ---

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    if(slbtn == _highFilterSlider)
    {
        float freq = (value *(_highFilterMax-_highFilterMin)) + _highFilterMin;
        
        _highFilterL.text = [self fomartHzKHz:freq];
        
        [_currentObj._proxyObj controlHighFilter:[NSString stringWithFormat:@"%0.0f", freq]];
        
        [fglm setHPFilterWithFreq:freq];
    }
    else
        if(slbtn == _lowFilterSlider)
        {
            float freq = (value *(_lowFilterMax-_lowFilterMin)) + _lowFilterMin;
            
            _lowFilgerL.text = [self fomartHzKHz:freq];
            
            NSString *ctrlVal = [NSString stringWithFormat:@"%0.0f", freq/1000.0];
            //单位是KHz
            [_currentObj._proxyObj controlLowFilter:ctrlVal];
            
            [fglm setLPFilterWithFreq:freq];
        }
}


- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    IMP_BLOCK_SELF(Fenpinqi_UIView);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(200.0 * NSEC_PER_MSEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [block_self didSlideButtonValueChanged:value slbtn:slbtn];
                   });
}



#pragma mark --- Filter Gaphic View Deleagte ---

- (void)filterGraphViewPEQFilterBandChoosedWithBand:(NSInteger)band{
    
    
}

- (void)filterGraphViewHPFilterChangedWithFreq:(float)freq{

    _highFilterL.text = [self fomartHzKHz:freq];
     [_currentObj._proxyObj controlHighFilter:[NSString stringWithFormat:@"%0.0f", freq]];
    
    float highValue = freq;
    float highMax = (_highFilterMax - _highFilterMin);
    if(highMax)
    {
        float f = (highValue - _highFilterMin)/highMax;
        f = fabsf(f);
        [_highFilterSlider setCircleValue:f];
    }
}
- (void)filterGraphViewLPFilterChangedWithFreq:(float)freq{
    
    _lowFilgerL.text = [self fomartHzKHz:freq];
    

    float showValue = freq;
    if(freq > 1000)
    {
        showValue = freq/1000;
    }
    [_currentObj._proxyObj controlLowFilter:[NSString stringWithFormat:@"%0.0f", showValue]];
    
    float lowWalue = freq;
    float lowMax = (_lowFilterMax - _lowFilterMin);
    if(lowMax)
    {
        float f = (lowWalue - _lowFilterMin)/lowMax;
        f = fabsf(f);
        [_lowFilterSlider setCircleValue:f];
    }
}

@end
