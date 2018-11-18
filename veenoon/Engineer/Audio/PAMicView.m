//
//  PAMicView.m
//  veenoon
//
//  Created by chen jack on 2018/11/18.
//  Copyright © 2018 jack. All rights reserved.
//

#import "PAMicView.h"
#import "SlideButton.h"
#import "AudioEMinMaxProxy.h"
#import "RegulusSDK.h"

@interface PAMicView () <SlideButtonDelegate>
{
    SlideButton *proxyBtn;
    
    UILabel* tempL;
    UILabel* vL;
    UILabel* eL;
    UILabel* mL;
    
    UIView *panView;
    
}
@property (nonatomic, strong) AudioEMinMaxProxy *_curMic;

@end

@implementation PAMicView
@synthesize _curMic;

- (id) initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame])
    {
        int startX = (frame.size.width - 92)/2.0;
        proxyBtn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, 0, 92, 120)];
        proxyBtn.delegate = self;
        [self addSubview:proxyBtn];
        
        self.backgroundColor = [UIColor clearColor];
        
        //proxyBtn._titleLabel.text = [NSString stringWithFormat:@"Channel %02d",i+1];
        
        panView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 120, 120)];
        panView.alpha = 0.6;
        panView.userInteractionEnabled = YES;
        [self addSubview:panView];
        
        tempL = [[UILabel alloc] initWithFrame:CGRectMake(proxyBtn.frame.size.width/2 -40,
                                                                    20, 80, 20)];
        tempL.backgroundColor = [UIColor clearColor];
        [panView addSubview:tempL];
        tempL.font = [UIFont boldSystemFontOfSize:14];
        tempL.textColor  = YELLOW_COLOR;
        tempL.textAlignment = NSTextAlignmentCenter;
        
        vL = [[UILabel alloc] initWithFrame:CGRectMake(proxyBtn.frame.size.width/2 -40,
                                                           45, 80, 20)];
        vL.backgroundColor = [UIColor clearColor];
        [panView addSubview:vL];
        vL.font = [UIFont boldSystemFontOfSize:14];
        vL.textColor  = YELLOW_COLOR;
        vL.textAlignment = NSTextAlignmentCenter;
        
        eL = [[UILabel alloc] initWithFrame:CGRectMake(proxyBtn.frame.size.width/2 -40,
                                                           70, 80, 20)];
        eL.backgroundColor = [UIColor clearColor];
        [panView addSubview:eL];
        eL.font = [UIFont boldSystemFontOfSize:14];
        eL.textColor  = YELLOW_COLOR;
        eL.textAlignment = NSTextAlignmentCenter;
        
        mL = [[UILabel alloc] initWithFrame:CGRectMake(proxyBtn.frame.size.width/2 -40,
                                                       95, 80, 20)];
        mL.backgroundColor = [UIColor clearColor];
        [panView addSubview:mL];
        mL.font = [UIFont boldSystemFontOfSize:14];
        mL.textColor  = YELLOW_COLOR;
        mL.textAlignment = NSTextAlignmentCenter;

        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(onStateChange:)
         name:@"RgsDeviceNotify"
         object:nil];
        
    }
    
    return self;
}

-(void)onStateChange:(NSNotification *)notify
{
    
    RgsDeviceNoteObj * dev_notify = notify.object;
    if(dev_notify && [dev_notify isKindOfClass:[RgsDeviceNoteObj class]])
    {
        if(dev_notify.device_id == _curMic._rgsProxyObj.m_id)
        {
            //TODO: 功率放大器的数据更新，在此更新
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self updateRealtimeData:dev_notify.param];
                
            });
           
        }
    }
    
}

- (void) updateRealtimeData:(NSDictionary*)data{
    
    
     [_curMic updateRealtimeData:data];
    
    tempL.text  = @"温度： ";
    vL.text     = @"电压： ";
    eL.text     = @"电流： ";
    mL.text     = @"模式： ";
}

- (void) fillMicObj:( AudioEMinMaxProxy* )micObj{
    
    self._curMic = micObj;
    
    proxyBtn._titleLabel.text = micObj._rgsProxyObj.name;
    
    tempL.text  = @"温度： ";
    vL.text     = @"电压： ";
    eL.text     = @"电流： ";
    mL.text     = @"模式： ";
    
    [micObj syncDeviceDataRealtime];
}

//value = 0....1
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int min = [_curMic getMinVolRange];
    int max = [_curMic getMaxVolRange];
    
    float circleValue = min + (value * (max-min));
    slbtn._valueLabel.text = [NSString stringWithFormat:@"%0.0f db", circleValue];
    
    
    [_curMic controlDeviceVol:circleValue exec:YES];
    
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int min = [_curMic getMinVolRange];
    int max = [_curMic getMaxVolRange];
    
    float circleValue = min + (value * (max-min));
    slbtn._valueLabel.text = [NSString stringWithFormat:@"%0.0f db", circleValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        [_curMic controlDeviceVol:circleValue exec:YES];
    });
}


- (void) didTappedMSelf:(SlideButton*)slbtn{
    
    BOOL isEnabled = [slbtn stateEnabled];
    [slbtn enableValueSet:!isEnabled];
    
    if(!isEnabled)
    {
        panView.alpha = 1.0;
    }
    else
    {
        panView.alpha = 0.6;
    }
}

- (id) testChangeVolValueWhenSelected:(float)vol
{
    int min = [_curMic getMinVolRange];
    int max = [_curMic getMaxVolRange];
    
    BOOL isEnabled = [proxyBtn stateEnabled];
    if(isEnabled){
        
        if(max-min > 0)
        {
            proxyBtn._valueLabel.text = [NSString stringWithFormat:@"%0.0f db", vol];
            [proxyBtn setCircleValue:fabs((vol-min)/(float)(max-min))];
            
            [_curMic controlDeviceVol:vol exec:NO];
            
            //控制命令
            RgsSceneOperation *opt = [_curMic generateEventOperation_Vol];
            
            return opt;
        }
        
    }
    
    return nil;
}

- (id) testChangeMuteWhenSelected:(BOOL)mute{
    
    BOOL isEnabled = [proxyBtn stateEnabled];
    if(isEnabled)
    {
        [proxyBtn muteSlider:mute];
        [_curMic controlDeviceMute:mute exec:NO];
        
        //控制命令
        RgsSceneOperation *opt = [_curMic generateEventOperation_Mute];
       
        return opt;
    }
    
    return nil;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
