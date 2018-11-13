//
//  E2MicView.m
//  veenoon
//
//  Created by chen jack on 2018/11/13.
//  Copyright © 2018 jack. All rights reserved.
//

#import "E2MicView.h"
#import "SlideButton.h"
#import "BatteryView.h"
#import "SignalView.h"
#import "RegulusSDK.h"
#import "AudioEWirlessMike.h"
#import "AudioEWirlessMikeProxy.h"
#import "DriverCmdSync.h"

@interface E2MicView () <SlideButtonDelegate>
{
    SlideButton *proxyBtn1;
    SlideButton *proxyBtn2;
    
    UILabel* titleL;
    UILabel* volValueL1;
    UILabel* volValueL2;
    
    SignalView *signal1;
    BatteryView *batter1;
    UILabel* sgtitleL1;
    
    SignalView *signal2;
    BatteryView *batter2;
    UILabel* sgtitleL2;
    
    int lw;
    UILabel *line;
    
    int _minVal;
    int _maxVal;
    
    UIView *signalView1;
    UIView *signalView2;
}
@property (nonatomic, strong) AudioEWirlessMike *_curMic;

@end


@implementation E2MicView
@synthesize _curMic;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
 
    if(self = [super initWithFrame:frame])
    {
        lw = 8;
        
        _minVal = -20;
        _maxVal = 20;
        
        int cellWidth = (frame.size.width-8)/2;
        proxyBtn1 = [[SlideButton alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 120)];
        [self addSubview:proxyBtn1];
        proxyBtn1.delegate = self;
        
        int value = -20;
        float circleValue = (value +20.0f)/40.0f;
        [proxyBtn1 setCircleValue:circleValue];
        
        proxyBtn2 = [[SlideButton alloc] initWithFrame:CGRectMake(lw+cellWidth, 0, cellWidth, 120)];
        [self addSubview:proxyBtn2];
        proxyBtn2.delegate = self;
        
        value = -20;
        circleValue = (value +20.0f)/40.0f;
        [proxyBtn2 setCircleValue:circleValue];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 4)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        line.center = CGPointMake(frame.size.width/2, 60);
        line.alpha = 0.6;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"标题";
     
        
        volValueL1 = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              proxyBtn1.frame.size.height - 20,
                                                              cellWidth, 20)];
        volValueL1.textAlignment = NSTextAlignmentCenter;
        volValueL1.backgroundColor = [UIColor clearColor];
        [self addSubview:volValueL1];
        volValueL1.font = [UIFont boldSystemFontOfSize:12];
        volValueL1.textColor  = [UIColor whiteColor];
        volValueL1.textAlignment = NSTextAlignmentCenter;
        volValueL1.text = @"1";
        
        volValueL2 = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth+lw,
                                                               proxyBtn2.frame.size.height - 20,
                                                               cellWidth, 20)];
        volValueL2.textAlignment = NSTextAlignmentCenter;
        volValueL2.backgroundColor = [UIColor clearColor];
        [self addSubview:volValueL2];
        volValueL2.font = [UIFont boldSystemFontOfSize:12];
        volValueL2.textColor  = [UIColor whiteColor];
        volValueL2.textAlignment = NSTextAlignmentCenter;
        volValueL2.text = @"2";
        
        signalView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, cellWidth, 120)];
        [self addSubview:signalView1];
        signalView1.alpha = 0.6;
        
        UIImage *image  = [UIImage imageNamed:@"huisehuatong.png"];
//        NSString *huatongType = @"huatong";
//        if ([@"huatong" isEqualToString:huatongType]) {
//
//        } else {
//            image = [UIImage imageNamed:@"huiseyaobao.png"];
//        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(25, 40);
        [signalView1 addSubview:imageView];
        
        batter1 = [[BatteryView alloc] initWithFrame:CGRectZero];
        batter1.normalColor = [UIColor whiteColor];
        [batter1 updateGrayBatteryView];
        [signalView1 addSubview:batter1];
        batter1.center = CGPointMake(imageView.center.x+20, 20);
        
        
        
        signal1 = [[SignalView alloc] initWithFrameAndStep:CGRectMake(imageView.center.x+30, 43, 30, 20)
                                                     step:2];
        [signalView1 addSubview:signal1];
        [signal1 setLightColor:[UIColor whiteColor]];//
        [signal1 setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
        
        
        
        sgtitleL1 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.center.x+10, 48, 20, 20)];
        sgtitleL1.backgroundColor = [UIColor clearColor];
        [signalView1 addSubview:sgtitleL1];
        sgtitleL1.font = [UIFont boldSystemFontOfSize:12];
        sgtitleL1.textColor  = [UIColor whiteColor];
        sgtitleL1.textAlignment = NSTextAlignmentCenter;
        
        
        
        signalView2 = [[UIView alloc] initWithFrame:CGRectMake(cellWidth+lw, 120, cellWidth, 120)];
        [self addSubview:signalView2];
        signalView2.alpha = 0.6;
        
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(25, 40);
        [signalView2 addSubview:imageView];
        
        batter2 = [[BatteryView alloc] initWithFrame:CGRectZero];
        batter2.normalColor = [UIColor whiteColor];
        [batter2 updateGrayBatteryView];
        [signalView2 addSubview:batter2];
        batter2.center = CGPointMake(imageView.center.x+20, 20);
        
        
        
        signal2 = [[SignalView alloc] initWithFrameAndStep:CGRectMake(imageView.center.x+30, 43, 30, 20)
                                                      step:2];
        [signalView2 addSubview:signal2];
        [signal2 setLightColor:[UIColor whiteColor]];//
        [signal2 setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    
        sgtitleL2 = [[UILabel alloc] initWithFrame:CGRectMake(imageView.center.x+10, 48, 20, 20)];
        sgtitleL2.backgroundColor = [UIColor clearColor];
        [signalView2 addSubview:sgtitleL2];
        sgtitleL2.font = [UIFont boldSystemFontOfSize:12];
        sgtitleL2.textColor  = [UIColor whiteColor];
        sgtitleL2.textAlignment = NSTextAlignmentCenter;
        
        
        [self fillMic1Data];
        [self fillMic2Data];
    }
    
    return self;
}

- (void) fillMic1Data{
    
    int value = -20;
    float circleValue = (value +20.0f)/40.0f;
    [proxyBtn1 setCircleValue:circleValue];
    volValueL1.text = [NSString stringWithFormat:@"%d", value];
    
    id dianliangStr = @"80";
    int dianliang = [dianliangStr intValue];
    double dianliangDouble = 1.0f * dianliang / 100;
    [batter1 setBatteryValue:dianliangDouble];
    
    int signalInt = 5;
    NSString *title = @"优";
    if (signalInt >= 3 && signalInt < 5) {
        title = @"良";
    } else if (signalInt < 3) {
        title = @"差";
    }
    [signal1 setSignalValue:signalInt];
    sgtitleL1.text = title;
}

- (void) fillMic2Data{
    
    int value = -20;
    float circleValue = (value +20.0f)/40.0f;
    [proxyBtn2 setCircleValue:circleValue];
    volValueL2.text = [NSString stringWithFormat:@"%d", value];
    
    id dianliangStr = @"80";
    int dianliang = [dianliangStr intValue];
    double dianliangDouble = 1.0f * dianliang / 100;
    [batter2 setBatteryValue:dianliangDouble];
    
    int signalInt = 5;
    NSString *title = @"优";
    if (signalInt >= 3 && signalInt < 5) {
        title = @"良";
    } else if (signalInt < 3) {
        title = @"差";
    }
    [signal2 setSignalValue:signalInt];
    sgtitleL2.text = title;
}

//value = 0....1
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    if(proxyBtn1 == slbtn)
    {
        float circleValue = _minVal + (value * (_maxVal - _minVal));
        volValueL1.text = [NSString stringWithFormat:@"%0.0f", circleValue];
    }
    else
    {
        float circleValue = _minVal + (value * (_maxVal - _minVal));
        volValueL2.text = [NSString stringWithFormat:@"%0.0f", circleValue];
    }

//    id data = slbtn.data;
//    if([data isKindOfClass:[VAProcessorProxys class]])
//    {
//        [(VAProcessorProxys*)data controlDeviceDb:circleValue
//                                            force:YES];
//
//        [_zengyiSlider setScaleValue:circleValue];
//    }
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
//        
//        id data = slbtn.data;
//        if([data isKindOfClass:[VAProcessorProxys class]])
//        {
//            float circleValue = minAnalogyGain + (value * (maxAnalogyGain - minAnalogyGain));
//            
//            [(VAProcessorProxys*)data controlDeviceDb:circleValue
//                                                force:YES];
//            
//            [_zengyiSlider setScaleValue:circleValue];
//        }
//    });
    
}


- (void) didTappedMSelf:(SlideButton*)slbtn{
    
    if(slbtn.data)
    {
    
        BOOL isEnabled = [slbtn stateEnabled];
        [slbtn enableValueSet:!isEnabled];
        
        if(isEnabled)
        {
            AudioEWirlessMikeProxy *aproxy = slbtn.data;
            if(![aproxy haveProxyCommandLoaded])
            {
                NSArray *cmds = [[DriverCmdSync sharedCMDSync] getCmdFromCache:@"AudioEWirlessMikeProxy"];
                [aproxy checkRgsProxyCommandLoad:cmds];
            }
        }
            
        
        if([proxyBtn1 stateEnabled] || [proxyBtn2 stateEnabled])
        {
            line.alpha = 1.0;
            
        }
        else
        {
            line.alpha = 0.6;
        }
        
        if([proxyBtn1 stateEnabled])
        {
            signalView1.alpha = 1.0;
            
        }
        else
        {
            signalView1.alpha = 0.6;
        }
        
        if([proxyBtn2 stateEnabled])
        {
            signalView2.alpha = 1.0;
        }
        else
        {
            signalView2.alpha = 0.6;
        }
    }
}

- (void) fillMicObj:( AudioEWirlessMike* )micObj{
 
    self._curMic = micObj;
    
    //如果有，就不需要重新请求了
    if([_curMic._proxys count])
    {
        return;
    }
    
    if(micObj._driver)
    {
        RgsDriverObj *dr = micObj._driver;
        
        IMP_BLOCK_SELF(E2MicView);
        
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:dr.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            
            NSMutableArray *proxysArray = [NSMutableArray array];
            for (RgsProxyObj *proxyObj in proxys) {
                if ([proxyObj.type isEqualToString:@"Wireless Mic"]) {
                    [proxysArray addObject:proxyObj];
                }
            }
            
            [block_self processProxys:proxysArray];
        }];
    
    }
    
}

- (void) processProxys:(NSArray*)proxys{
    
    
    NSMutableArray *proObjs = [NSMutableArray array];
    
    for(RgsProxyObj *rgsp in proxys)
    {
        AudioEWirlessMikeProxy *aproxy = [[AudioEWirlessMikeProxy alloc] init];
        aproxy._rgsProxyObj = rgsp;
        [proObjs addObject:aproxy];
        
        NSArray *cmds = [[DriverCmdSync sharedCMDSync] getCmdFromCache:@"AudioEWirlessMikeProxy"];
        [aproxy checkRgsProxyCommandLoad:cmds];
    }
    
    _curMic._proxys = proObjs;
    
    if(0 < [proObjs count])
    {
        proxyBtn1.data = [proObjs objectAtIndex:0];
    }
    if(1 < [proObjs count])
    {
        proxyBtn2.data = [proObjs objectAtIndex:1];
    }
}

@end
