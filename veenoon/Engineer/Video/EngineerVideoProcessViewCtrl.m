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
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
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
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(90, labelHeight, SCREEN_WIDTH-90, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentLeft;
    titleL.text = @"Inputs";
    

//    int cellHeight = 80;
//    int cellWidth = 80;
    
    scroolViewIn = [[UIScrollView alloc] initWithFrame:CGRectMake(75,
                                                                  labelHeight+60,
                                                                  SCREEN_WIDTH,
                                                                  110)];
    [self.view addSubview:scroolViewIn];
    scroolViewIn.showsHorizontalScrollIndicator = NO;
    
    
    scroolViewOut = [[UIScrollView alloc] initWithFrame:CGRectMake(75, labelHeight+260, SCREEN_WIDTH, 120)];
    
    [self.view addSubview:scroolViewOut];

    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(90, labelHeight+210, SCREEN_WIDTH-90, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentLeft;
    titleL.text = @"Outputs";
    
    
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
    
    IMP_BLOCK_SELF(EngineerVideoProcessViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        /*
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedVideoProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
         */
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedVideoCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }

}


- (void) loadedVideoCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _currentObj._driver;
    
    id proxy = self._currentObj._proxyObj;

    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        self._currentProxy = proxy;
    }
    else
    {
        self._currentProxy = [[VVideoProcessSetProxy alloc] init];
    }
    
    self._currentObj._proxyObj = _currentProxy;
    
    _currentProxy.delegate = self;
    _currentProxy._deviceId = driver.m_id;
    [_currentProxy checkRgsProxyCommandLoad:cmds];
    
}

- (void) loadedVideoProxy:(NSArray*)proxys{
    
    id proxy = self._currentObj._proxyObj;

    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        self._currentProxy = proxy;
    }
    else
    {
        self._currentProxy = [[VVideoProcessSetProxy alloc] init];
    }
    _currentProxy.delegate = self;
    
    _currentProxy._rgsProxyObj = [proxys objectAtIndex:0];
    [_currentProxy checkRgsProxyCommandLoad:nil];
    
    
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
        
        NSString *ctrl_val = [NSString stringWithFormat:@"%d",i];
        id data = @{@"icon":@"engineer_scenario_add_small.png",@"type":@"0"};
        if([_currentProxy._inputDevices objectForKey:ctrl_val]){
            
            data = [_currentProxy._inputDevices objectForKey:ctrl_val];
            iBtn.delegate = self;
        }
        [iBtn fillData:data];
        
        
        [scroolViewIn addSubview:iBtn];
        
        
        NSString *titleStr = [NSString stringWithFormat:@"%d", i];
        [iBtn setTitle:titleStr];
        
        x = CGRectGetMaxX(rc)+15;
        
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
        
        NSString *ctrl_val = [NSString stringWithFormat:@"%d",i];
        id data = @{@"icon":@"engineer_scenario_add_small.png",@"type":@"0"};
        if([_currentProxy._outputDevices objectForKey:ctrl_val]){
            
            data = [_currentProxy._outputDevices objectForKey:ctrl_val];
            
            [_outDataMap setObject:iBtn
                            forKey:ctrl_val];
            
            iBtn.delegate = self;
        }
    
        [iBtn fillData:data];
        
        [scroolViewOut addSubview:iBtn];
        
        
        NSString *titleStr = [NSString stringWithFormat:@"%d", i];
        [iBtn setTitle:titleStr];
        
        x = CGRectGetMaxX(rc)+15;
        
        [_outPutBtnArray addObject:iBtn];
    }
    
    x+=180;
    scroolViewOut.contentSize = CGSizeMake(x, CGRectGetHeight(scroolViewOut.frame));
    
    
    if([_currentProxy._deviceMatcherDic count])
    {
        [self createP2P:_currentProxy._deviceMatcherDic];
    }
    
}

- (void) createP2P:(NSDictionary *)p2p{
    
    for(TwoIconAndTitleView *ibtn in _inPutBtnArray)
    {
        NSDictionary *data = [ibtn getMyData];
        if(data)
        {
            NSString *ctrl_val = [data objectForKey:@"ctrl_val"];
            NSArray *outputs = [p2p objectForKey:ctrl_val];
            if(outputs && [outputs count])
            {
                for(id val in outputs)
                {
                    TwoIconAndTitleView *toCell = [_outDataMap objectForKey:val];
                    if(toCell)
                    {
                        [self linkCell:ibtn outCell:toCell];
                    }
                    
                }
            }
        }
    }
}

- (void) linkCell:(TwoIconAndTitleView *)inCell outCell:(TwoIconAndTitleView* )outCell{
    
    if(inCell && outCell)
    {
        //输入源
        //[inCell selected];
        [outCell selected];
        
        NSDictionary* inputD = [inCell getMyData];
        [outCell fillRelatedData:inputD];
        
    }
    
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
 
    if([t testIsInDevice])//输入
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
        if(_current)//如果有输入
        {
            [t fillRelatedData:[_current getMyData]];
            _outPutSelected = t;
            [self controlAddOutDevice];
        }
    }
}

- (void) controlAddOutDevice {
    
    if (_inputSelected == nil || _outPutSelected == nil) {
        return;
    }
    
    NSString *inputDeviceName = _inputSelected._textLabel.text;
    NSString *outputDeviceName = _outPutSelected._textLabel.text;
    
    //把选择的插件数据传递过去
    NSDictionary *data = [_inputSelected getMyData];
    NSMutableDictionary *src = [NSMutableDictionary dictionaryWithDictionary:data];
    [src setObject:inputDeviceName forKey:@"ctrl_val"];
    
    data = [_outPutSelected getMyData];
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:data];
    [res setObject:outputDeviceName forKey:@"ctrl_val"];
    
    [_currentProxy controlDeviceAdd:src
                      withOutDevice:res];
}

- (void) controlRemoveOutDevice {
    
    if (_inputSelected == nil || _outPutSelected == nil) {
        return;
    }
    
    NSString *inputDeviceName = _inputSelected._textLabel.text;
    NSString *outputDeviceName = _outPutSelected._textLabel.text;
    
    //把选择的插件数据传递过去
    NSDictionary *data = [_inputSelected getMyData];
    NSMutableDictionary *src = [NSMutableDictionary dictionaryWithDictionary:data];
    [src setObject:inputDeviceName forKey:@"ctrl_val"];
    
    data = [_outPutSelected getMyData];
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:data];
    [res setObject:outputDeviceName forKey:@"ctrl_val"];
    
    [_currentProxy controlDeviceRemove:src
                      withOutDevice:res];
    
}

- (void) didCancelTouchedTIA:(id)tia{
    
    TwoIconAndTitleView *t = tia;
    
    if([t testIsInDevice])
    {
        //取消输入
        self._current = nil;
    }
    else//取消输出
    {
        if(self._current)
        {
            //如果有输入，顶替新的输入
            
            id cur = [_current getMyData];
            id inp = [t getInputData];
            if(cur != inp)//替换
            {
                [t selected];
                [t fillRelatedData:cur];
                _outPutSelected = t;
                 [self controlAddOutDevice];
            }
            else//取消
            {
                [t unselected];
                _outPutSelected = t;
                [self controlRemoveOutDevice];
            }
           
        }
        else
        {
            //如果没选择输入，直接取消输出
            [t unselected];
            _outPutSelected = t;
            
            [self controlRemoveOutDevice];
        }
    }
}

- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt {
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_rightView];
    
    if(viewPoint.x < CGRectGetMinX(_rightView.frame)  - 20)
    {
        NSNumber *number = [data objectForKey:@"input_output"];
        int numberInt = [number intValue];
        if (numberInt == 1) {
            
            CGPoint rpt = [self.view convertPoint:viewPoint toView:scroolViewIn];
            for(TwoIconAndTitleView * ti in _inPutBtnArray)
            {
                if(CGRectContainsPoint(ti.frame, rpt))
                {
                    NSString *deviceName = [NSString stringWithFormat:@"%d", (int)ti.tag];
                    NSMutableDictionary *src = [NSMutableDictionary dictionaryWithDictionary:data];
                    [src setObject:deviceName forKey:@"ctrl_val"];
                    
                    [ti fillData:src];
                    ti.delegate = self;
                    
                    [_currentProxy saveInputDevice:src];
                    
                    break;
                }
            }
            
        }
        else
        {
            
            CGPoint rpt = [self.view convertPoint:viewPoint toView:scroolViewOut];
            for(TwoIconAndTitleView * ti in _outPutBtnArray)
            {
                if(CGRectContainsPoint(ti.frame, rpt))
                {
                    NSString *deviceName = [NSString stringWithFormat:@"%d", (int)ti.tag];
                    NSMutableDictionary *src = [NSMutableDictionary dictionaryWithDictionary:data];
                    [src setObject:deviceName forKey:@"ctrl_val"];
                    
                    [ti fillData:src];
                    ti.delegate = self;
                    
                    [_currentProxy saveOutputDevice:src];
                    
                    [_outDataMap setObject:ti
                                    forKey:deviceName];
                    
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
