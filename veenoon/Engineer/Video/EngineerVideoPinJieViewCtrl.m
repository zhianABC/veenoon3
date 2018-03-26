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

@interface EngineerVideoPinJieViewCtrl ()<CustomPickerViewDelegate> {
    UIButton *_selectSysBtn;
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inPutBtnArray = [[NSMutableArray alloc] init];
    
    [super setTitleAndImage:@"video_corner_pinjieping.png" withTitle:@"拼接屏"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
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
    _selectSysBtn.frame = CGRectMake(50, 100, 80, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"001" forState:UIControlStateNormal];
    _selectSysBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,_selectSysBtn.imageView.bounds.size.width)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width+35,0,0)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    
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

- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 100) withGrayOrLight:@"gray"];
    
    
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
    NSString *title =  [@"" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}
- (void) okAction:(id)sender{
    if (!isSettings) {
        _rightView = [[PinJiePingRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        [self.view addSubview:_rightView];
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
