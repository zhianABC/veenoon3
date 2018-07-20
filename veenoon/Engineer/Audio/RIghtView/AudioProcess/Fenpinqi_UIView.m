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
        bgv.backgroundColor = RGB(0, 89, 118);
        
        
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
        float highMax = (_highFilterMax - _highFilterMin);
        if(highMax)
        {
            float f = (highValue - _highFilterMin)/highMax;
            f = fabsf(f);
            [_highFilterSlider setCircleValue:f];
            
            [fglm setHPMaxMinFreqWithMaxfreq:_highFilterMax
                                     minfreq:_highFilterMin];
            
            [fglm setHPFilterWithFreq:_highFilterMin];
        }
        
        
        _highFilterL = [[UILabel alloc] init];
        _highFilterL.text = [hightFilter stringByAppendingString:@" Hz"];
        _highFilterL.font = [UIFont systemFontOfSize: 13];
        _highFilterL.textColor = [UIColor whiteColor];
        _highFilterL.frame = CGRectMake(0, CGRectGetMaxY(_highFilterSlider.frame), 60, 20);
        [self addSubview:_highFilterL];
        _highFilterL.textAlignment = NSTextAlignmentCenter;
        _highFilterL.layer.cornerRadius = 5;
        _highFilterL.backgroundColor = RGB(0, 89, 118);
        _highFilterL.center = CGPointMake(_highFilterSlider.center.x, _highFilterL.center.y);
        _highFilterL.clipsToBounds = YES;
        
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
        float lowWalue = [lowFilter floatValue];
        float lowMax = (_lowFilterMax - _lowFilterMin);
        if(lowMax)
        {
            float f = (lowWalue - _lowFilterMin)/lowMax;
            f = fabsf(f);
            [_lowFilterSlider setCircleValue:f];
            
            [fglm setLPMaxMinFreqWithMaxfreq:_lowFilterMax
                                     minfreq:_lowFilterMin];
            
            [fglm setLPFilterWithFreq:_lowFilterMax];
        }
        
        _lowFilgerL = [[UILabel alloc] init];
        _lowFilgerL.text = [lowFilter stringByAppendingString:@" KHz"];
        _lowFilgerL.font = [UIFont systemFontOfSize: 13];
        _lowFilgerL.textColor = [UIColor whiteColor];
        _lowFilgerL.frame = CGRectMake(0, CGRectGetMaxY(_lowFilterSlider.frame), 60, 20);
        [self addSubview:_lowFilgerL];
        _lowFilgerL.textAlignment = NSTextAlignmentCenter;
        _lowFilgerL.layer.cornerRadius = 5;
        _lowFilgerL.backgroundColor = RGB(0, 89, 118);
        _lowFilgerL.center = CGPointMake(_lowFilterSlider.center.x, _lowFilgerL.center.y);
        _lowFilgerL.clipsToBounds = YES;
        
        
    }
    
    return self;
}



- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    if(slbtn == _highFilterSlider)
    {
        float freq = (value *(_highFilterMax-_highFilterMin)) + _highFilterMin;
        
        NSString *hz = @"Hz";
        float showValue = freq;
        if(freq > 1000)
        {
            hz = @"KHz";
            showValue = freq/1000;
        }
        
        _highFilterL.text = [NSString stringWithFormat:@"%0.0f %@",
                             showValue, hz];
        
        [_currentObj._proxyObj controlHighFilter:[NSString stringWithFormat:@"%0.0f", freq]];
        
        [fglm setHPFilterWithFreq:freq];
    }
    else
        if(slbtn == _lowFilterSlider)
        {
            float freq = (value *(_lowFilterMax-_lowFilterMin)) + _lowFilterMin;
            
            NSString *hz = @"Hz";
            float showValue = freq;
            if(freq > 1000)
            {
                hz = @"KHz";
                showValue = freq/1000;
            }
            
            _lowFilgerL.text = [NSString stringWithFormat:@"%0.0f %@",
                                showValue, hz];
            
            [_currentObj._proxyObj controlLowFilter:[NSString stringWithFormat:@"%0.0f", freq]];
            
            [fglm setLPFilterWithFreq:freq];
        }
}
- (void)filterGraphViewPEQFilterBandChoosedWithBand:(NSInteger)band{
    
    
}

- (void)filterGraphViewHPFilterChangedWithFreq:(float)freq{
    
    NSString *hz = @"Hz";
    float showValue = freq;
    if(freq > 1000)
    {
        hz = @"KHz";
        showValue = freq/1000;
    }
    
    _highFilterL.text = [NSString stringWithFormat:@"%0.0f %@",
                         showValue,
                         hz];
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
    
    NSString *hz = @"Hz";
    float showValue = freq;
    if(freq > 1000)
    {
        hz = @"KHz";
        showValue = freq/1000;
    }
    
    _lowFilgerL.text = [NSString stringWithFormat:@"%0.0f %@",
                        showValue,
                        hz];
    
    
    [_currentObj._proxyObj controlLowFilter:[NSString stringWithFormat:@"%0.0f", freq]];
    
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
