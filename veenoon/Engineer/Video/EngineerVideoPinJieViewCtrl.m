//
//  EngineerVideoPinJieViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerVideoPinJieViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "PinJiePingRightView.h"
#import "VPinJieSet.h"
#import "PlugsCtrlTitleHeader.h"
#import "BrandCategoryNoUtil.h"

@interface EngineerVideoPinJieViewCtrl ()<CustomPickerViewDelegate> {
    PlugsCtrlTitleHeader *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    NSMutableArray *_inPutBtnArray;
    
    BOOL isSettings;
    PinJiePingRightView *_rightView;
    UIButton *okBtn;
    
    UIScrollView *_scroolView;
}

@end

@implementation EngineerVideoPinJieViewCtrl
@synthesize _pinjieSysArray;
@synthesize _rowNumber;
@synthesize _colNumber;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inPutBtnArray = [[NSMutableArray alloc] init];
    
    if ([_pinjieSysArray count]) {
        self._currentObj = [_pinjieSysArray objectAtIndex:0];
    }
    
    if(_currentObj == nil) {
        self._currentObj = [[VPinJieSet alloc] init];
    }
    
    [super setTitleAndImage:@"video_corner_pinjieping.png" withTitle:@"拼接屏"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
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
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    if (_currentObj) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
        [_selectSysBtn setShowText:nameStr];
    }
    
    
    [self refreshScrollView:self._rowNumber withColumn:self._colNumber];
    
}

- (void) refreshScrollView:(int)row withColumn:(int) column {
    int labelHeight = SCREEN_HEIGHT - 600;
    int cellHeight = 80;
    int space = 2;
    int leftRight = 150;
    
    if (_inPutBtnArray) {
        [_inPutBtnArray removeAllObjects];
    }
    
    if (_scroolView) {
        for (UIView *view in [_scroolView subviews]) {
            if (view) {
                [view removeFromSuperview];
            }
        }
    } else {
        _scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight, labelHeight, SCREEN_WIDTH - leftRight*2, cellHeight*5+space*4)];
        _scroolView.backgroundColor = [UIColor clearColor];
        int contentWidth = column * 80 + (column-1) *space;
        int contentHeight = row * 80 + (row - 1) * space;
        
        _scroolView.contentSize = CGSizeMake(contentWidth, contentHeight);
        [self.view addSubview:_scroolView];
    }
    int index = 0;
    
    for (int i = 0; i < row;i++) {
        int startY = i * (cellHeight+space);
        for (int j = 0; j < column; j++) {
            int startX = j * (cellHeight+space);
            
            UIButton *cameraBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
            cameraBtn.frame = CGRectMake(startX, startY, 80, 80);
            cameraBtn.layer.cornerRadius = 5;
            cameraBtn.layer.borderWidth = 2;
            cameraBtn.tag = index;
            cameraBtn.layer.borderColor = [UIColor clearColor].CGColor;;
            cameraBtn.clipsToBounds = YES;
            cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [_scroolView addSubview:cameraBtn];
            [cameraBtn addTarget:self
                          action:@selector(inputBtnAction:)
                forControlEvents:UIControlEventTouchUpInside];
            [_inPutBtnArray addObject:cameraBtn];
            
            index++;
        }
    }
    
}

- (void) inputBtnAction:(id)sender{
    
}

- (void) selectCurrentMike:(VPinJieSet*)mike{
    
    
    self._currentObj = mike;
    
    
    [self updateCurrentMikeState:mike._deviceno];
}

- (void) updateCurrentMikeState:(NSString *)deviceno{
    
    NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
    [_selectSysBtn setShowText:nameStr];
    
    if ([_rightView superview]) {
        _rightView._currentObj = _currentObj;
        [_rightView refreshView:_currentObj];
    }
    
}

- (void) sysSelectAction:(id)sender{
    
    [self.view addSubview:_dActionView];
    
    IMP_BLOCK_SELF(EngineerVideoPinJieViewCtrl);
    _dActionView._callback = ^(int tagIndex, id obj)
    {
        [block_self selectCurrentMike:obj];
    };
    
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(VPinJieSet *mike in _pinjieSysArray) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:mike._brand withCategory:mike._type withNo:mike._deviceno];
        [arr addObject:@{@"object":mike,@"name":nameStr}];
    }
    
    _dActionView._selectIndex = _currentObj._index;
    [_dActionView setSelectDatas:arr];
}

- (void) chooseDeviceAtIndex:(int)idx{
    
    self._currentObj = [_pinjieSysArray objectAtIndex:idx];
    
    [self updateCurrentMikeState:_currentObj._deviceno];
    
}

- (void) settingsAction:(id)sender{
    //检查是否需要创建
    if (_rightView == nil) {
        _rightView = [[PinJiePingRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        
        //创建底部设备切换按钮
        _rightView._numOfDevice = (int)[_pinjieSysArray count];
        
        
        IMP_BLOCK_SELF(EngineerVideoPinJieViewCtrl);
        _rightView._callback = ^(int deviceIndex) {
            
            [block_self chooseDeviceAtIndex:deviceIndex];
        };
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

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
