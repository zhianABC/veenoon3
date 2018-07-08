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
    UILabel *gaotongL;
    UILabel *gaotongL2;
    
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

-(id) initWithFrame:(CGRect)frame withAudiMix:(AudioEMix*) audioMix
{
    if(self = [super initWithFrame:frame])
    {
        _currentObj = audioMix;
        
        CGRect rc = CGRectMake(0, 40, frame.size.width, 320);
        UIView *bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        
        rc = CGRectMake(10, 50, frame.size.width-20, 300);
        fglm = [[MixFilterGraphView alloc] initWithFrame:rc];
        fglm.backgroundColor = [UIColor clearColor];
        [self addSubview:fglm];
        fglm.delegate = self;
        
        int startH = CGRectGetMaxY(fglm.frame);
        int startX = 420;
        
//        UILabel *addLabel = [[UILabel alloc] init];
//        addLabel.text = @"-12dB";
//        addLabel.font = [UIFont systemFontOfSize: 13];
//        addLabel.textColor = [UIColor whiteColor];
//        addLabel.frame = CGRectMake(startX-60, startH+115, 120, 20);
//        [self addSubview:addLabel];
//
//        addLabel = [[UILabel alloc] init];
//        addLabel.text = @"12dB";
//        addLabel.font = [UIFont systemFontOfSize: 13];
//        addLabel.textColor = [UIColor whiteColor];
//        addLabel.frame = CGRectMake(startX+80, startH+115, 120, 20);
//        [self addSubview:addLabel];
        
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
        
        NSString *peqStr = _currentObj._proxyObj._mixPEQ;
        float highValue = [peqStr floatValue];
        float highMax = (_peqMax - _peqMin);
        if(highMax)
        {
            float f = (highValue - _peqMin)/highMax;
            f = fabsf(f);
            [btnJH setCircleValue:f];
        }
        
        gaotongL = [[UILabel alloc] init];
        gaotongL.text = [peqStr stringByAppendingString:@" dB"];
        gaotongL.font = [UIFont systemFontOfSize: 13];
        gaotongL.textColor = [UIColor whiteColor];
        gaotongL.frame = CGRectMake(0, CGRectGetMaxY(btnJH.frame), 60, 20);
        [self addSubview:gaotongL];
        gaotongL.textAlignment = NSTextAlignmentCenter;
        gaotongL.layer.cornerRadius = 5;
        gaotongL.backgroundColor = RGB(0, 89, 118);
        gaotongL.center = CGPointMake(btnJH.center.x, gaotongL.center.y);
        gaotongL.clipsToBounds = YES;
        
    }
    
    return self;
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float k = (value *(_peqMax-_peqMin)) + _peqMin;
    gaotongL.text = [NSString stringWithFormat:@"%0.0f dB", k];
    
    if(_curIndex < [_peqRateArray count])
    {
        id rateKey = [_peqRateArray objectAtIndex:_curIndex];
        [_currentObj._proxyObj controlMixPEQ:[NSString stringWithFormat:@"%0.0f", k]
                                    withRate:rateKey];
    }
    
    [fglm setPEQWithBand:_curIndex
                    gain:k];
}

- (void)filterGraphViewPEQFilterBandChoosedWithBand:(NSInteger)band{
    
    _curIndex = band;
    
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
            
            gaotongL.text = [NSString stringWithFormat:@"%0.0f dB", gain];
        }
    }
    
    
}
- (void)filterGraphViewPEQFilterChangedWithBand:(NSInteger)band freq:(float)freq gain:(float)gain{
    
    _curIndex = band;
    
    if(_curIndex < [_peqRateArray count])
    {
        id rateKey = [_peqRateArray objectAtIndex:_curIndex];

        [_currentObj._proxyObj controlMixPEQ:[NSString stringWithFormat:@"%0.0f", gain]
                                    withRate:rateKey];
        
        float highMax = (_peqMax - _peqMin);
        if(highMax)
        {
            float f = (gain - _peqMin)/highMax;
            f = fabsf(f);
            [btnJH setCircleValue:f];
            
            gaotongL.text = [NSString stringWithFormat:@"%0.0f dB", gain];
        }
    }
}

- (void)filterGraphViewPEQFilterChangedWithBand:(NSInteger)band qIndex:(NSInteger)qIndex qValue:(float)qValue{
    
    
}

@end
