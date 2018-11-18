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
        proxyBtn.longPressEnabled = YES;
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyProxyGotCurStateVals:)
                                                     name:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                                   object:nil];
        
    }
    
    return self;
}

#pragma mark --Proxy Current State Got
- (void) notifyProxyGotCurStateVals:(NSNotification*)notify{
    
    NSDictionary *obj = notify.object;
    
    if(obj && [obj objectForKey:@"proxy"])
    {
        id proxyid = [obj objectForKey:@"proxy"];
        
        if([proxyid integerValue] == _curMic._rgsProxyObj.m_id)
        {
            [self refreshUI];
        }
        
    }
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
    
    [self refreshUI];
    
    [_curMic syncDeviceDataRealtime];

}

- (void) refreshUI{
    
    int min = [_curMic getMinVolRange];
    int max = [_curMic getMaxVolRange];
    if(max - min)
    {
        float p = fabs((float)([_curMic getVol] - min)/(max-min));
        [proxyBtn setCircleValue:p];
    }
    
    BOOL isMute = [_curMic getMute];
    [proxyBtn muteSlider:isMute];
    
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

- (void) didLongPressSlideButton:(SlideButton*)slbtn{

    if(_curMic)
    {
        NSString *alert = @"修改通道名称";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:alert preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"通道名称";
            textField.text = _curMic._rgsProxyObj.name;
            //textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        
        
        IMP_BLOCK_SELF(PAMicView);
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *alValTxt = alertController.textFields.firstObject;
            NSString *val = alValTxt.text;
            if (val && [val length] > 0) {
                
                [block_self resetProxyName:val];
            }
        }]];
        
        //[self presentViewController:alertController animated:true completion:nil];
    }
}

- (void) resetProxyName:(NSString*)name{
    
    proxyBtn._titleLabel.text = name;
    _curMic._rgsProxyObj.name = name;
    
    [[RegulusSDK sharedRegulusSDK] RenameProxy:_curMic._rgsProxyObj.m_id
                                          name:name
                                    completion:nil];
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
