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
    
    int _number;
}


@end

@implementation DimmerLightSwitchView
@synthesize _curProcessor;


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
    
    int max = 8;
    if(_number < max)
        max = _number;
    
    int maxRow = _number/8;
    if(_number%8){
        maxRow+=1;
    }
    
    float leftRight = ( SCREEN_WIDTH - max*cellWidth - (max-1)*space )/2.0;
    float ftop = 114;
    
    
    float startX = leftRight;
    float startY = ftop;
    
    NSDictionary *chLevelMap = [(EDimmerSwitchLightProxy*)_curProcessor._proxyObj getChLevelRecords];
    
    for (int i = 0; i <_number; i++) {
    
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
        
        [btn turnOnOff:NO];
        
        id key = [NSNumber numberWithInt:i+1];
        if([chLevelMap objectForKey:key])
        {
            BOOL power = [[chLevelMap objectForKey:key] boolValue];
            [btn turnOnOff:power];
        }
        
        
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
    
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
    IMP_BLOCK_SELF(DimmerLightSwitchView);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedLightCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
    
}

- (void) loadedLightCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _curProcessor._driver;
    
    id proxy = _curProcessor._proxyObj;
    
    EDimmerSwitchLightProxy *vpro = nil;
    if(proxy && [proxy isKindOfClass:[EDimmerSwitchLightProxy class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[EDimmerSwitchLightProxy alloc] init];
    }
    
    vpro._deviceId = driver.m_id;
    [vpro checkRgsProxyCommandLoad:cmds];
    
    
    self._curProcessor._proxyObj = vpro;
    [_curProcessor syncDriverIPProperty];
    
    _number = [vpro getNumberOfLights];
    [self layoutChannels];
}

- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    EDimmerSwitchLightProxy *vpro = self._curProcessor._proxyObj;
    int ch = (int)slbtn.tag + 1;
    
    // want to choose it
    if (![_selectedBtnArray containsObject:slbtn]) {
        
        [_selectedBtnArray addObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = YELLOW_COLOR;
        
        [slbtn enableValueSet:YES];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:1 ch:ch];
        }
        
    } else {
        // remove it
        [_selectedBtnArray removeObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = RGB(121, 117, 115);
        
        [slbtn enableValueSet:NO];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:0 ch:ch];
        }
    }
}

@end
