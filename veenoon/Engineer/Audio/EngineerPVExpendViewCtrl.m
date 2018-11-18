//
//  EngineerPVExpendViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPVExpendViewCtrl.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "SlideButton.h"
#import "PAMicView.h"
#import "AudioEMinMax.h"
#import "AudioEMinMaxProxy.h"
#import "KVNProgress.h"
#import "RegulusSDK.h"


@interface EngineerPVExpendViewCtrl () <EngineerSliderViewDelegate, SlideButtonDelegate, CustomPickerViewDelegate, PAMicViewDelegate>{
    
    EngineerSliderView *_zengyiSlider;
    
    BOOL isSettings;
    UIButton *okBtn;
    
    UIView *_proxysView;
}
@property (nonatomic, strong) AudioEMinMax *_curProcessor;
@property (nonatomic, strong) NSMutableArray *_cells;
@property (nonatomic, strong) NSArray *_proxys;

@end

@implementation EngineerPVExpendViewCtrl
@synthesize _pvExpendArray;
@synthesize _curProcessor;
@synthesize _cells;
@synthesize _proxys;
@synthesize fromScenario;


- (void)viewDidLoad {
    [super viewDidLoad];
   
    isSettings = NO;
    
    self._cells = [NSMutableArray array];

    [super setTitleAndImage:@"audio_corner_gongfang.png" withTitle:@"功放"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           SCREEN_HEIGHT-50,
                                                                           SCREEN_WIDTH,
                                                                           50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    int height = 150;
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           height-5,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-height-60)];
    [self.view addSubview:_proxysView];
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi3.png"]
                     frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = 0;
    _zengyiSlider.minValue = -32;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(TESLARIA_SLIDER_X, TESLARIA_SLIDER_Y);
    
    
    if([_pvExpendArray count])
        self._curProcessor = [_pvExpendArray objectAtIndex:0];
    
    if(_curProcessor)
    {
        [self getCurrentDeviceDriverProxys];
    }

}


- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
    //如果有，就不需要重新请求了
    if([_curProcessor._proxys count])
    {
        self._proxys = _curProcessor._proxys;
        [self initChannels];
        
        return;
    }
    
    IMP_BLOCK_SELF(EngineerPVExpendViewCtrl);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self prepareProxys:proxys];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }

}

- (void) prepareProxys:(NSArray*)array{
    
    NSMutableArray *tmp = [NSMutableArray array];
    _curProcessor._proxys = tmp;
    self._proxys = tmp;
    
    for(RgsProxyObj *pro in array)
    {
        AudioEMinMaxProxy *ap = [[AudioEMinMaxProxy alloc] init];
        ap._rgsProxyObj = pro;
        [tmp addObject:ap];
    }

    [self initChannels];
    
}

- (void) initChannels{
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 250;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    int index = 0;
    int top = 0;
    
    for (int i = 0; i < [self._proxys count]; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        CGRect rc = CGRectMake(startX, startY, 120, 230);
        PAMicView *pv = [[PAMicView alloc] initWithFrame:rc];
        [_proxysView addSubview:pv];
        pv.delegate = self;
        [_cells addObject:pv];
    
        AudioEMinMaxProxy *proxy = [self._proxys objectAtIndex:i];
        
        [pv fillMicObj:proxy];
        
        if(!fromScenario)
        {
            [proxy getCurrentDataState];
        }
        
        index++;
    }
    
    if([_proxys count])
    {
        AudioEMinMaxProxy *proxy = [self._proxys objectAtIndex:0];
        if(![proxy haveProxyCommandLoaded])
        {
            IMP_BLOCK_SELF(EngineerPVExpendViewCtrl);
            
            [[RegulusSDK sharedRegulusSDK] GetProxyCommands:proxy._rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
                if (result)
                {
                    [block_self saveProxyCmds:commands];
                }
                else
                {
                    NSString *errorMsg = [NSString stringWithFormat:@"%@ - proxyid:%d",
                                          [error description], (int)proxy._rgsProxyObj.m_id];
                    
                    [KVNProgress showErrorWithStatus:errorMsg];
                }
                
            }];
        }
    }
}


- (void) saveProxyCmds:(NSArray*)commands{
    
    if ([commands count]) {
        
        for(AudioEMinMaxProxy *proxy in _proxys)
        {
            [proxy checkRgsProxyCommandLoad:commands];
        }
        
        if([_proxys count])
        {
        AudioEMinMaxProxy *proxy  = [_proxys objectAtIndex:0];
        _zengyiSlider.maxValue = [proxy getMaxVolRange];
        _zengyiSlider.minValue = [proxy getMinVolRange];
        }
    }
}

- (void) doVolChanged:(float)value{
    
    //批量执行
    NSMutableArray *opts = [NSMutableArray array];
    
    for (PAMicView *cell in _cells) {
        
        id opt = [cell testChangeVolValueWhenSelected:value];
        
        if(opt)
            [opts addObject:opt];
    }
    
    if([opts count])
        [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                     completion:nil];
}

- (void) didSliderValueChanged:(float)value object:(id)object {
    
    [self doVolChanged:value];
    
}

- (void) didSliderEndChanged:(float)value object:(id)object{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        [self doVolChanged:value];
    });
}


- (void) didSliderMuteChanged:(BOOL)mute object:(id)object{
    
    //批量执行
    NSMutableArray *opts = [NSMutableArray array];
    
    for (PAMicView *cell in _cells) {
        
        id opt = [cell testChangeMuteWhenSelected:mute];
        
        if(opt)
            [opts addObject:opt];
    }
    
    if([opts count])
        [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                     completion:nil];
}

- (void) didTappedButtonWithVol:(int)vol{
    
    [_zengyiSlider setScaleValue:vol];
    
}


- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
