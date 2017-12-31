//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerLightViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "SlideButton.h"

@interface EngineerLightViewController () <CustomPickerViewDelegate>{
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *_buttonNumberArray;
    
    NSMutableArray *_selectedBtnArray;
}
@end

@implementation EngineerLightViewController
@synthesize _lightSysArray;
@synthesize _number;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
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
    [_selectSysBtn setTitle:@"灯光" forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-30,0,_selectSysBtn.imageView.bounds.size.width+50)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width,0,-100)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    int index = 0;
    int top = 250;
    if (self._number >= 10) {
        top = 350;
    }
    
    int leftRight = 200;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = 7;
    int space = (SCREEN_WIDTH - colNumber*cellWidth-leftRight*2)/(colNumber-1);
    
    for (int i = 0; i < self._number; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight-100;
        int startY = row*cellHeight+space*row+top;
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = i;
        [btn addGestureRecognizer:tapGesture];
        
        btn.tag = i;
        [self.view addSubview:btn];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width - 30, 20, 30, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [NSString stringWithFormat:@"0%d",i+1];
        [_buttonNumberArray addObject:titleL];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -40, btn.frame.size.height - 40, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"Channel";
        [_buttonChannelArray addObject:titleL];
        
        [_buttonArray addObject:btn];
        
        index++;
    }
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    int tag = (int) gestureRecognizer.view.tag;
    
    SlideButton *btn;
    for (SlideButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        SlideButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = YELLOW_COLOR;
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = YELLOW_COLOR;
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = [UIColor whiteColor];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = [UIColor whiteColor];;
    }
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
    NSString *title =  [@"灯光" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}
- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
