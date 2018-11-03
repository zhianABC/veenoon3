//
//  DimmerLightSwitchView.m
//  veenoon
//
//  Created by chen jack on 2018/9/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DimmerLightSwitchView.h"
#import "UIButton+Color.h"
#import "LightSliderButton.h"
#import "DSwitchLightRightView.h"
#import "EDimmerSwitchLight.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "EDimmerSwitchLightProxy.h"

@interface DimmerLightSwitchView () <LightSliderButtonDelegate>{
    
    NSMutableArray *_buttonArray;
    NSMutableArray *_buttonNumberArray;
    NSMutableArray *_selectedBtnArray;

    UIView *_proxysView;
    
}
@property (nonatomic, strong) NSArray *_proxys;

@end

@implementation DimmerLightSwitchView
@synthesize _curProcessor;
@synthesize _proxys;

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _buttonArray = [[NSMutableArray alloc] init];
        _buttonNumberArray = [[NSMutableArray alloc] init];
        _selectedBtnArray = [[NSMutableArray alloc] init];
        
        
        _proxysView = [[UIView alloc] initWithFrame:self.bounds];
        
        [self addSubview:_proxysView];

    }
    
    return self;
}

- (void) load{
    
    [self getCurrentDeviceDriverProxys];
}

- (void) layoutChannels{
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_buttonArray removeAllObjects];
    [_buttonNumberArray removeAllObjects];
    
    int cellWidth = 92;
    int cellHeight = 92;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    NSMutableArray *tmpProxyObjs = [NSMutableArray array];
    
    if([_curProcessor._proxys count])//已经创建过
    {
        tmpProxyObjs = _curProcessor._proxys;
    }
    else //没创建过
    {
        //创建
        for (int i = 0; i < [_proxys count]; i++) {
            
            RgsProxyObj * rgsProxy = [_proxys objectAtIndex:i];
            
            EDimmerSwitchLightProxy *apxy = [[EDimmerSwitchLightProxy alloc] init];
            apxy._rgsProxyObj = rgsProxy;
            [tmpProxyObjs addObject:apxy];
        }
        
        _curProcessor._proxys = tmpProxyObjs;
    }
    
    int count = (int)[tmpProxyObjs count];
    
    int max = 8;
    if(count < max)
        max = count;
    
    int maxRow = count/8;
    if(count%8){
        maxRow+=1;
    }
    
    float leftRight = ( SCREEN_WIDTH - max*cellWidth - (max-1)*space )/2.0;
    float ftop = 114;
    
    
    float startX = leftRight;
    float startY = ftop;
    

    for (int i = 0; i < count; i++) {
    
        EDimmerSwitchLightProxy *apxy = [tmpProxyObjs objectAtIndex:i];
        
        LightSliderButton *btn = [[LightSliderButton alloc] initWithFrame:CGRectMake(startX,
                                                                                     startY,
                                                                                     cellWidth,
                                                                                     cellHeight)];
        btn.tag = i;
        btn.delegate = self;
        [_proxysView addSubview:btn];
        
        btn._grayBackgroundImage = [UIImage imageNamed:@"user_light_bg_n.png"];
        btn._lightBackgroundImage = [UIImage imageNamed:@"user_light_bg_s.png"];
        
        [btn setImageStype:UIViewContentModeCenter];
        
        [btn hiddenProgress];
        
        btn.data = apxy;
        [btn turnOnOff:apxy._power];
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX,
                                                                    CGRectGetMaxY(btn.frame),
                                                                    cellWidth, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [_proxysView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = RGB(121, 117, 115);
        titleL.text = [@"CH " stringByAppendingString:[NSString stringWithFormat:@"0%d",i+1]];
        [_buttonNumberArray addObject:titleL];
        
        [_buttonArray addObject:btn];
   
        startX += cellWidth;
        startX += space;
        
        if(i%8 == 0 && i)
        {
            startX = leftRight;
            startY += cellHeight;
            startY += space*3;
        }
    }
    
    if([tmpProxyObjs count])
    {
        //只读取一个，因为所有的out的commands相同
        NSMutableArray *proxyids = [NSMutableArray array];
        EDimmerSwitchLightProxy *ape = [tmpProxyObjs objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInteger:ape._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(DimmerLightSwitchView);
        
        if(![ape haveProxyCommandLoaded])
        {
            [KVNProgress show];
            [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                    completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                        
                                                        [block_self loadAllCommands:commd_dict];
                                                        
                                                    }];
        }
    }
}


- (void) loadAllCommands:(NSDictionary*)commd_dict{
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(EDimmerSwitchLightProxy *vap in _curProcessor._proxys)
        {
            [vap checkRgsProxyCommandLoad:cmds];
        }
    }
    
    [KVNProgress dismiss];
}


- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
    //如果有，就不需要重新请求了
    if([_curProcessor._proxys count])
    {
        [self layoutChannels];
        return;
    }
    
    IMP_BLOCK_SELF(DimmerLightSwitchView);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    NSMutableArray *proxysArray = [NSMutableArray array];
                    for (RgsProxyObj *proxyObj in proxys) {
                        if ([proxyObj.type isEqualToString:@"light_v2"]) {
                            [proxysArray addObject:proxyObj];
                        }
                    }
                    block_self._proxys = proxysArray;
                    [block_self layoutChannels];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
}


- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    EDimmerSwitchLightProxy *vpro = slbtn.data;
    int ch = (int)slbtn.tag + 1;
    
    // want to choose it
    if (![_selectedBtnArray containsObject:slbtn]) {
        
        [_selectedBtnArray addObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = YELLOW_COLOR;
        
        [slbtn enableValueSet:YES];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:1];
        }
        
    } else {
        // remove it
        [_selectedBtnArray removeObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = RGB(121, 117, 115);
        
        [slbtn enableValueSet:NO];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:0];
        }
    }
}

@end
