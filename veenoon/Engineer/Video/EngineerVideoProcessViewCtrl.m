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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
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
    

    int cellHeight = 80;
    int cellWidth = 80;
    
    scroolViewIn = [[UIScrollView alloc] initWithFrame:CGRectMake(100,
                                                                  labelHeight+60,
                                                                  SCREEN_WIDTH - 175*2,
                                                                  110)];
    [self.view addSubview:scroolViewIn];
    scroolViewIn.showsHorizontalScrollIndicator = NO;
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 10, cellWidth, cellHeight);
    cameraBtn.tag = 1000;
    cameraBtn.clipsToBounds = YES;
    [cameraBtn setImage:[UIImage imageNamed:@"engineer_scenario_add_small.png"]
               forState:UIControlStateNormal];
    [scroolViewIn addSubview:cameraBtn];
    [cameraBtn addTarget:self
                  action:@selector(addInputBtnAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_inPutBtnArray addObject:cameraBtn];
    
    
    
    scroolViewOut = [[UIScrollView alloc] initWithFrame:CGRectMake(100, labelHeight+260, SCREEN_WIDTH - 175*2, 120)];
    
    [self.view addSubview:scroolViewOut];
    
    UIButton *ocameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ocameraBtn.frame = CGRectMake(0, 10, cellWidth, cellHeight);
    ocameraBtn.tag = 1000;
    ocameraBtn.clipsToBounds = YES;
    [ocameraBtn setImage:[UIImage imageNamed:@"engineer_scenario_add_small.png"]
               forState:UIControlStateNormal];
    [scroolViewOut addSubview:ocameraBtn];
    [ocameraBtn addTarget:self
                   action:@selector(addOutputBtnAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [_outPutBtnArray addObject:ocameraBtn];
    
    
    
    
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
                                           64, 300, SCREEN_HEIGHT-114)];
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
    
//    id proxy = self._currentObj._proxyObj;
//    
//    VVideoProcessSetProxy *vcam = nil;
//    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
//    {
//        vcam = proxy;
//    }
//    else
//    {
//        vcam = [[VVideoProcessSetProxy alloc] init];
//    }
//    
//    vcam._rgsProxyObj = [proxys objectAtIndex:0];
//    [vcam checkRgsProxyCommandLoad];
//    
//    if([_currentObj._localSavedProxys count])
//    {
//        NSDictionary *local = [_currentObj._localSavedProxys objectAtIndex:0];
//        [vcam recoverWithDictionary:local];
//        
//        [_numberBtn setTitle:[NSString stringWithFormat:@"%d", vcam._load]
//                    forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_numberBtn setTitle:[NSString stringWithFormat:@"%d", vcam._save]
//                    forState:UIControlStateNormal];
//    }
//    
//    self._currentObj._proxyObj = vcam;
//    [_currentObj syncDriverIPProperty];
//    [_currentObj syncDriverComs];
}

- (void) updateProxyCommandValIsLoaded {
    _currentProxy.delegate = self;
    [_currentProxy checkRgsProxyCommandLoad];
    
}

- (void) didLoadedProxyCommand {
    _currentProxy.delegate = nil;
    
    NSDictionary *inputSettings = [_currentProxy getVideoProcessInputSettings];
    
    NSDictionary *outputSettings = [_currentProxy getVideoProcessOutputSettings];
    
    [self updateView];
}

- (void) updateView {
    
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


- (void) addInputBtnAction:(id)sender{
}
- (void) addOutputBtnAction:(id)sender{
}


- (void) inputBtnAction:(id)sender{
    
}
- (void) outputBtnAction:(id)sender{
    
}

- (void) saveAction:(id)sender{
    
    [self handleTapGesture:nil];
    
    
}
- (void) settingsAction:(id)sender{
    //检查是否需要创建
    if (_rightView == nil) {
        _rightView = [[VideoProcessRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        
        //创建底部设备切换按钮
        _rightView._numOfDevice = (int)[_videoProcessArray count];
        
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
                }
            }
        }
    }
    else//输出
    {
        if(_current)
        {
            [t fillRelatedData:[_current getMyData]];
        }
        else
        {
            [t unselected];
        }
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
    
    
    NSString *titleStr = [NSString stringWithFormat:@"Channel %02d", idx+1];
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
    
    NSString *titleStr = [NSString stringWithFormat:@"Channel %02d", idx+1];
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

- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt {
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_rightView];
    
    if(viewPoint.x < CGRectGetMinX(_rightView.frame)  - 20)
    {
        NSNumber *number = [data objectForKey:@"id"];
        int numberInt = [number intValue];
        if (301 <= numberInt && numberInt <= 305) {
            
            [self addInputDevice:data];
            
        } else {
            
            [self addOutputDevice:data];
        }
    }

}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
