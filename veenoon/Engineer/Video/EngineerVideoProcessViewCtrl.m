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

@interface EngineerVideoProcessViewCtrl () <CustomPickerViewDelegate, VideoProcessRightViewDelegate>{
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    NSMutableArray *_inPutBtnArray;
    NSMutableArray *_outPutBtnArray;
    
    UIButton *okBtn;
    BOOL isSettings;
    VideoProcessRightView *_rightView;
    
    UIView *_topView;
    UIView *_bottomView;
    UIImageView *bottomBar;
}

@end

@implementation EngineerVideoProcessViewCtrl
@synthesize _videoProcessInArray;
@synthesize _videoProcessOutArray;
@synthesize _inNumber;
@synthesize _outNumber;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    _inPutBtnArray = [[NSMutableArray alloc] init];
    _outPutBtnArray = [[NSMutableArray alloc] init];
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _selectSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSysBtn.frame = CGRectMake(70, 100, 200, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"视频处理器" forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-30,0,_selectSysBtn.imageView.bounds.size.width+50)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width,0,-100)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    int labelHeight = SCREEN_HEIGHT - 600;
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight, SCREEN_WIDTH, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"输入";
    
    int index = 0;
    int cellHeight = 60;
    int cellWidth = 80;
    int space = 5;
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(200, labelHeight+40, SCREEN_WIDTH - 200*2, 70)];
    int viewWidth = self._inNumber * 85;
    scroolView.contentSize = CGSizeMake(viewWidth, 70);
    [self.view addSubview:scroolView];
    
    for (int i = 0 ; i < self._inNumber; i++) {
        int startX = index*cellWidth+index*space;
        
        UIButton *cameraBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
        cameraBtn.frame = CGRectMake(startX, 5, cellWidth, cellHeight);
        cameraBtn.layer.cornerRadius = 5;
        cameraBtn.layer.borderWidth = 2;
        cameraBtn.tag = index;
        cameraBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        cameraBtn.clipsToBounds = YES;
        [cameraBtn setTitle:@"摄像机" forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cameraBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [scroolView addSubview:cameraBtn];
        [cameraBtn addTarget:self
                      action:@selector(inputBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [_inPutBtnArray addObject:cameraBtn];
        
        index++;
    }
    
    UIScrollView *scroolView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(200, labelHeight+240, SCREEN_WIDTH - 200*2, 70)];
    int viewWidth2 = self._outNumber * 85;
    scroolView2.contentSize = CGSizeMake(viewWidth2, 70);
    
    [self.view addSubview:scroolView2];
    
    
    int index2 =0;
    for (int i = 0 ; i < self._outNumber; i++) {
        int startX = index2*cellWidth+index2*space;
        
        UIButton *cameraBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
        cameraBtn.frame = CGRectMake(startX, 5, cellWidth, cellHeight);
        cameraBtn.layer.cornerRadius = 5;
        cameraBtn.layer.borderWidth = 2;
        cameraBtn.tag = index2;
        cameraBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        cameraBtn.clipsToBounds = YES;
        
        [cameraBtn setTitle:@"摄像机" forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cameraBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        cameraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [scroolView2 addSubview:cameraBtn];
        [cameraBtn addTarget:self
                      action:@selector(outputBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
        [_outPutBtnArray addObject:cameraBtn];
        
        index2++;
    }
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight+200, SCREEN_WIDTH, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"输出";
    
    
    [self.view addSubview:bottomBar];
}
- (void) inputBtnAction:(id)sender{
}
- (void) outputBtnAction:(id)sender{
}
- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 200) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 2; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"00%d", i]];
    }
    
    _customPicker._pickerDataArray = @[@{@"values":arr}];
    
    
    _customPicker._selectColor = [UIColor orangeColor];
    _customPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_customPicker];
    _customPicker.delegate_ = self;
}

- (void) didConfirmPickerValue:(NSString*) pickerValue {
    if (_customPicker) {
        [_customPicker removeFromSuperview];
    }
    NSString *title =  [@"视频处理器" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}
- (void) saveAction:(id)sender{
    if (_rightView) {
        [_rightView removeFromSuperview];
    }
    if (_topView) {
        [_topView removeFromSuperview];
    }
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    
    okBtn.hidden = NO;
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
}
- (void) okAction:(id)sender{
    if (!isSettings) {
        _rightView = [[VideoProcessRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        _rightView.delegate = self;
        [self.view insertSubview:_rightView belowSubview:bottomBar];
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-300, 0, 300, 64)];
        _topView.backgroundColor = THEME_COLOR;
        [self.view addSubview:_topView];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-300, SCREEN_HEIGHT-50, 300, 50)];
        _bottomView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bottomView];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(_bottomView.frame.size.width -170, 0,160, 50);
        [_bottomView addSubview:saveBtn];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [saveBtn addTarget:self
                  action:@selector(saveAction:)
        forControlEvents:UIControlEventTouchUpInside];
        
        okBtn.hidden = YES;
        
        isSettings = YES;
    }
}

- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt {
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_rightView];
    
    NSNumber *number = [data objectForKey:@"id"];
    int numberInt = [number intValue];
    UIImage *image = [data objectForKey:@"icon"];
    if (301 <= numberInt && numberInt <= 305) {
        for (UIButton *button in _inPutBtnArray) {
            CGRect rect = [self.view convertRect:button.frame fromView:button.superview];
            if (CGRectContainsPoint(rect, viewPoint)) {
//                [button setImage:image forState:UIControlStateNormal];
            }
        }
    } else {
        for (UIButton *button in _outPutBtnArray) {
            if (CGRectContainsPoint(button.frame, viewPoint)) {
//                [button setImage:image forState:UIControlStateNormal];
            }
        }
    }
    
    
    
    NSLog(@"ssss");
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
