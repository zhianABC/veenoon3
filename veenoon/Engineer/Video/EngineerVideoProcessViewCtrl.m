//
//  EngineerVideoProcessViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerVideoProcessViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "VideoProcessRightView.h"
#import "TwoIconAndTitleView.h"
#import "PlugsCtrlTitleHeader.h"
#import "BrandCategoryNoUtil.h"
#import "VVideoProcessSetProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface EngineerVideoProcessViewCtrl () <CustomPickerViewDelegate, VideoProcessRightViewDelegate, TwoIconAndTitleViewDelegate, VVideoProcessSetProxyDelegate>{
    
    NSMutableArray *_inPutBtnArray;
    NSMutableArray *_outPutBtnArray;
    
    UIButton *okBtn;
    UIButton *saveBtn;
    BOOL isSettings;
    VideoProcessRightView *_rightView;
    
    UIView *_topView;
    UIImageView *bottomBar;
    
    UIScrollView *scroolViewIn;
    UIScrollView *scroolViewOut;
    
    int inputMin;
    int inputMax;
    int outputMin;
    int outputMax;
    
    TwoIconAndTitleView *_inputSelected;
    TwoIconAndTitleView *_outPutSelected;
}
@property (nonatomic, strong) NSMutableDictionary *_selectedDataMap;
@property (nonatomic, strong) NSMutableDictionary *_outDataMap;
@property (nonatomic, strong) TwoIconAndTitleView *_current;
@property (nonatomic, strong) VVideoProcessSetProxy *_currentProxy;
@end

@implementation EngineerVideoProcessViewCtrl
@synthesize _videoProcessInArray;
@synthesize _videoProcessOutArray;
@synthesize _inNumber;
@synthesize _outNumber;
@synthesize _selectedDataMap;
@synthesize _outDataMap;
@synthesize _current;
@synthesize _currentObj;
@synthesize _videoProcessArray;
@synthesize _currentProxy;
@synthesize _currentVideoDevices;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    inputMin = 1;
    inputMax = 9;
    outputMin = 1;
    outputMax = 9;
    
    _inputSelected = nil;
    _outPutSelected = nil;
    
    if ([_videoProcessArray count]) {
        self._currentObj = [_videoProcessArray objectAtIndex:0];
    }
    
    if (_currentObj == nil) {
        self._currentObj = [[VVideoProcessSet alloc] init];
    }
    
    _inPutBtnArray = [[NSMutableArray alloc] init];
    _outPutBtnArray = [[NSMutableArray alloc] init];
    
    
    self._selectedDataMap = [NSMutableDictionary dictionary];
    self._outDataMap = [NSMutableDictionary dictionary];
    
    [super setTitleAndImage:@"video_corner_shipinchuli.png" withTitle:@"视频处理器"];
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:mask];
    
    bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingsAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = okBtn.frame;
    [bottomBar addSubview:saveBtn];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [saveBtn addTarget:self
                action:@selector(saveAction:)
      forControlEvents:UIControlEventTouchUpInside];
    saveBtn.hidden = YES;
    
    int labelHeight = 180;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight, SCREEN_WIDTH-125*2, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"输入";
    

//    int cellHeight = 80;
//    int cellWidth = 80;
    
    scroolViewIn = [[UIScrollView alloc] initWithFrame:CGRectMake(100,
                                                                  labelHeight+60,
                                                                  SCREEN_WIDTH - 175*2,
                                                                  110)];
    [self.view addSubview:scroolViewIn];
    scroolViewIn.showsHorizontalScrollIndicator = NO;
    
    
    scroolViewOut = [[UIScrollView alloc] initWithFrame:CGRectMake(100, labelHeight+260, SCREEN_WIDTH - 175*2, 120)];
    
    [self.view addSubview:scroolViewOut];

    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight+210, SCREEN_WIDTH-125*2, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"输出";
    
    
    [self.view addSubview:bottomBar];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-300, 0, 300, 64)];
    _topView.backgroundColor = DARK_GRAY_COLOR;
    [self.view addSubview:_topView];
    
    _rightView = [[VideoProcessRightView alloc]
                  initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                           64, 300, SCREEN_HEIGHT-114) withVideoDevices:self._currentVideoDevices];
    _rightView.delegate = self;
    _rightView._numOfDevice = (int) [_videoProcessArray count];
    
    [self.view insertSubview:_rightView belowSubview:_topView];
    
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [mask addGestureRecognizer:tapGesture];

    [self getCurrentDeviceDriverProxys];
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerVideoProcessViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedCameraProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
            }
        }];
    }
#endif
}

- (void) loadedCameraProxy:(NSArray*)proxys{
    
    id proxy = self._currentObj._proxyObj;

    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        _currentProxy = proxy;
    }
    else
    {
        _currentProxy = [[VVideoProcessSetProxy alloc] init];
    }
    _currentProxy.delegate = self;
    
    _currentProxy._rgsProxyObj = [proxys objectAtIndex:0];
    [_currentProxy checkRgsProxyCommandLoad];

    self._currentObj._proxyObj = _currentProxy;
    
}

- (void) didLoadedProxyCommand {
    
    _currentProxy.delegate = nil;
    
    NSDictionary *inputSettings = [_currentProxy getVideoProcessInputSettings];
    
    inputMin = [[inputSettings objectForKey:@"min"] intValue];
    inputMax = [[inputSettings objectForKey:@"max"] intValue];

    NSDictionary *outputSettings = [_currentProxy getVideoProcessOutputSettings];
    
    outputMin = [[outputSettings objectForKey:@"min"] intValue];
    outputMax = [[outputSettings objectForKey:@"max"] intValue];
    
    [self updateView];
}

- (void) updateView {
    
    
    [[scroolViewIn subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int x = 10;
    int y = 0;
    for(int i = inputMin; i <= inputMax; i++)
    {
        CGRect rc = CGRectMake(x, y, 80, 110);
        
        TwoIconAndTitleView *iBtn = [[TwoIconAndTitleView alloc] initWithFrame:rc];
        iBtn.tag = i;
        //iBtn.delegate = self;
        iBtn.clipsToBounds = YES;
        [iBtn fillData:@{@"icon":@"engineer_scenario_add_small.png",@"type":@"0"}];
        [scroolViewIn addSubview:iBtn];
        
        
        NSString *titleStr = [NSString stringWithFormat:@"%d", i];
        [iBtn setTitle:titleStr];
        
        x = CGRectGetMaxX(rc)+20;
        
        [_inPutBtnArray addObject:iBtn];
    }
    
    x+=180;
    scroolViewIn.contentSize = CGSizeMake(x, CGRectGetHeight(scroolViewIn.frame));
    
    
    
    [[scroolViewOut subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    x = 10;
    y = 0;
    for(int i = outputMin; i <= outputMax; i++)
    {
        CGRect rc = CGRectMake(x, y, 80, 110);
        
        TwoIconAndTitleView *iBtn = [[TwoIconAndTitleView alloc] initWithFrame:rc];
        iBtn.tag = i;
        //iBtn.delegate = self;
        iBtn.clipsToBounds = YES;
        [iBtn fillData:@{@"icon":@"engineer_scenario_add_small.png",@"type":@"0"}];
        [scroolViewOut addSubview:iBtn];
        
        
        NSString *titleStr = [NSString stringWithFormat:@"%d", i];
        [iBtn setTitle:titleStr];
        
        x = CGRectGetMaxX(rc)+20;
        
        [_outPutBtnArray addObject:iBtn];
    }
    
    x+=180;
    scroolViewOut.contentSize = CGSizeMake(x, CGRectGetHeight(scroolViewOut.frame));
    
}


- (void) handleTapGesture:(UIGestureRecognizer*)sender{
    
    CGPoint pt = [sender locationInView:self.view];
    
    if(pt.x < SCREEN_WIDTH-300)
    {
        
        CGRect rc = _rightView.frame;
        rc.origin.x = SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _rightView.frame = rc;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        
        okBtn.hidden = NO;
        saveBtn.hidden = YES;
        isSettings = NO;
    }
}

- (void) saveAction:(id)sender{
    
    [self handleTapGesture:nil];
    
    
}
- (void) settingsAction:(id)sender{
    //检查是否需要创建
    if (_rightView == nil) {
        _rightView = [[VideoProcessRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114) withVideoDevices:self._currentVideoDevices];
        
        //创建底部设备切换按钮
        _rightView._numOfDevice = (int)[_videoProcessArray count];
        _rightView._currentVideoDevices = self._currentVideoDevices;
    }
    
    //如果在显示，消失
    if([_rightView superview])
    {
        
        //写入中控
        //......
        
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _rightView.frame  = CGRectMake(SCREEN_WIDTH,
                                                            64, 300, SCREEN_HEIGHT-114);
                         } completion:^(BOOL finished) {
                             [_rightView removeFromSuperview];
                         }];
    }
    else//如果没显示，显示
    {
        _rightView._currentObj = _currentObj;
        [_rightView refreshView:_currentObj];
        
        
        [self.view addSubview:_rightView];
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        
        [UIView beginAnimations:nil context:nil];
        _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                       64, 300, SCREEN_HEIGHT-114);
        [UIView commitAnimations];
    }
}

- (void) didBeginTouchedTIA:(id)tia{
    
    TwoIconAndTitleView *t = tia;
 
    if([t testIsInDevice])
    {
        self._current = t;
        
        for(TwoIconAndTitleView *to in _inPutBtnArray)
        {
            if([to isKindOfClass:[TwoIconAndTitleView class]])
            {
                if(to != t)
                {
                    [to unselected];
                } else {
                    _inputSelected = t;
                }
            }
        }
    }
    else//输出
    {
        if(_current)
        {
            [t fillRelatedData:[_current getMyData]];
            _outPutSelected = t;
            [self controlAddOutDevice];
        }
        else
        {
            [t unselected];
            _outPutSelected = t;
            
            [self controlRemoveOutDevice];
        }
    }
}

- (void) controlAddOutDevice {
    
    if (_inputSelected == nil || _outPutSelected == nil) {
        return;
    }
    
    NSString *inputDeviceName = _inputSelected._textLabel.text;
    NSString *outputDeviceName = _outPutSelected._textLabel.text;
    
    [_currentProxy controlDeviceAdd:inputDeviceName withOutDevice:outputDeviceName];
}

- (void) controlRemoveOutDevice {
    
    if (_inputSelected == nil || _outPutSelected == nil) {
        return;
    }
}

- (void) didCancelTouchedTIA:(id)tia{
    
    TwoIconAndTitleView *t = tia;
    
    if([t testIsInDevice])
    {
        self._current = nil;
    }
    else//输出
    {
        if(_current)
        {
            
        }
    }
}


/*
- (void) addInputDevice:(NSDictionary*)data{
    
    
    UIButton *lastAddBtn = [_inPutBtnArray lastObject];
    
    int idx = (int)[_inPutBtnArray count] - 1;
    
    CGRect rc = lastAddBtn.frame;
    rc.origin.y = 0;
    rc.size.height = 110;
    
    TwoIconAndTitleView *iBtn = [[TwoIconAndTitleView alloc] initWithFrame:rc];
    iBtn.tag = idx;
    iBtn.delegate = self;
    iBtn.clipsToBounds = YES;
    [iBtn fillData:data];
    [scroolViewIn addSubview:iBtn];
    
    
    NSString *titleStr = [NSString stringWithFormat:@"%d", idx+1];
    [iBtn setTitle:titleStr];
   

    CGRect newRC = rc;
    newRC.origin.x = CGRectGetMaxX(rc) + 20;
    newRC.origin.y = 10;
    newRC.size.height = 80;
    
    [UIView beginAnimations:nil context:nil];
    lastAddBtn.frame = newRC;
    [UIView commitAnimations];
    
    [_inPutBtnArray insertObject:iBtn atIndex:idx];
    
    [_selectedDataMap setObject:data
                         forKey:[NSNumber numberWithInt:idx]];
    
}


- (void) addOutputDevice:(NSDictionary*)data{
    
    UIButton *lastAddBtn = [_outPutBtnArray lastObject];
    
    int idx = (int)[_outPutBtnArray count] - 1;
    
    CGRect rc = lastAddBtn.frame;
    rc.origin.y = 0;
    rc.size.height = 110;
    
    TwoIconAndTitleView *iBtn = [[TwoIconAndTitleView alloc] initWithFrame:rc];
    iBtn.tag = idx;
    iBtn.clipsToBounds = YES;
    [iBtn fillData:data];
    [scroolViewOut addSubview:iBtn];
    
    iBtn.delegate = self;
    
    NSString *titleStr = [NSString stringWithFormat:@"%d", idx+1];
    [iBtn setTitle:titleStr];
    
    //    [iBtn addTarget:self
    //                  action:@selector(inputBtnAction:)
    //        forControlEvents:UIControlEventTouchUpInside];
    //
    CGRect newRC = rc;
    newRC.origin.x = CGRectGetMaxX(rc) + 20;
    newRC.origin.y = 10;
    newRC.size.height = 80;
    
    [UIView beginAnimations:nil context:nil];
    lastAddBtn.frame = newRC;
    [UIView commitAnimations];
    
    [_outPutBtnArray insertObject:iBtn atIndex:idx];
    
    [_outDataMap setObject:data
                         forKey:[NSNumber numberWithInt:idx]];
    
}
*/

- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt {
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_rightView];
    
    if(viewPoint.x < CGRectGetMinX(_rightView.frame)  - 20)
    {
        NSNumber *number = [data objectForKey:@"id"];
        int numberInt = [number intValue];
        if (301 <= numberInt && numberInt <= 305) {
            
            CGPoint rpt = [self.view convertPoint:viewPoint toView:scroolViewIn];
            for(TwoIconAndTitleView * ti in _inPutBtnArray)
            {
                if(CGRectContainsPoint(ti.frame, rpt))
                {
                    [ti fillData:data];
                    ti.delegate = self;
                    break;
                }
            }
            
           // [self addInputDevice:data];
            
        } else {
            
            CGPoint rpt = [self.view convertPoint:viewPoint toView:scroolViewOut];
            for(TwoIconAndTitleView * ti in _outPutBtnArray)
            {
                if(CGRectContainsPoint(ti.frame, rpt))
                {
                    [ti fillData:data];
                    ti.delegate = self;
                    break;
                }
            }
            
            //[self addOutputDevice:data];
        }
    }

}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
