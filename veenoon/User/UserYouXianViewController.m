//
//  UserYouXianViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/28.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserYouXianViewController.h"
#import "CustomPickerView.h"

@interface UserYouXianViewController () {
    UIButton *_zhuximoshiBtn;
    UIButton *_luntimoshiBtn;
    UIButton *_shenqingmoshiBtn;
    UIButton *_ziyoumoshiBtn;
    
    CustomPickerView *_peoplePicker1;
    CustomPickerView *_peoplePicker2;
    CustomPickerView *_peoplePicker3;
    CustomPickerView *_peoplePicker4;
}
@end

@implementation UserYouXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
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
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int leftRight = 200;
    int rowGap = 120;
    int height = SCREEN_HEIGHT - 600;
    int cellHeight = 150;
    
    int pickerRowLeft = -20;
    
    int pickerHeight = 200;
    
    int cellWidth = (SCREEN_WIDTH - leftRight*2 - rowGap*3)/4;
    
    _zhuximoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhuximoshiBtn.frame = CGRectMake(leftRight, height, cellWidth, cellHeight);
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_n.png"] forState:UIControlStateNormal];
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_s.png"] forState:UIControlStateHighlighted];
    [_zhuximoshiBtn setTitle:@"主席模式" forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _zhuximoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_zhuximoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_zhuximoshiBtn.imageView.frame.size.height+50,-80,-20,10)];
    [_zhuximoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_zhuximoshiBtn.titleLabel.bounds.size.height, 0)];
    [_zhuximoshiBtn addTarget:self action:@selector(zhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zhuximoshiBtn];
    
    _peoplePicker1 = [[CustomPickerView alloc] initWithFrame:CGRectMake(leftRight+pickerRowLeft, height+pickerHeight, 100, 120) withGrayOrLight:@"gray"];
    _peoplePicker1._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker1];
    [_peoplePicker1 selectRow:0 inComponent:0];
    _peoplePicker1._selectColor = RGB(230, 151, 50);
    _peoplePicker1._rowNormalColor = SINGAL_COLOR;
    
    _luntimoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _luntimoshiBtn.frame = CGRectMake(leftRight+rowGap+cellWidth, height, cellWidth, cellHeight);
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_n.png"] forState:UIControlStateNormal];
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_s.png"] forState:UIControlStateHighlighted];
    [_luntimoshiBtn setTitle:@"轮替模式" forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _luntimoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_luntimoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_luntimoshiBtn.imageView.frame.size.height+50,-75,-20,5)];
    [_luntimoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_luntimoshiBtn.titleLabel.bounds.size.height, 0)];
    [_luntimoshiBtn addTarget:self action:@selector(luntiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_luntimoshiBtn];
    
    _peoplePicker2 = [[CustomPickerView alloc] initWithFrame:CGRectMake(leftRight+rowGap+cellWidth+pickerRowLeft, height+pickerHeight, 100, 120) withGrayOrLight:@"gray"];
    _peoplePicker2._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker2];
    [_peoplePicker2 selectRow:0 inComponent:0];
    _peoplePicker2._selectColor = RGB(230, 151, 50);
    _peoplePicker2._rowNormalColor = SINGAL_COLOR;
    
    _shenqingmoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shenqingmoshiBtn.frame = CGRectMake(leftRight+rowGap*2+cellWidth*2, height, cellWidth, cellHeight);
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_n.png"] forState:UIControlStateNormal];
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_s.png"] forState:UIControlStateHighlighted];
    [_shenqingmoshiBtn setTitle:@"申请模式" forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _shenqingmoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_shenqingmoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_shenqingmoshiBtn.imageView.frame.size.height+50,-75,-20,5)];
    [_shenqingmoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_shenqingmoshiBtn.titleLabel.bounds.size.height, 0)];
    [_shenqingmoshiBtn addTarget:self action:@selector(shenqingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shenqingmoshiBtn];
    
    _peoplePicker3 = [[CustomPickerView alloc] initWithFrame:CGRectMake(leftRight+rowGap*2+cellWidth*2+pickerRowLeft, height+pickerHeight, 100, 120) withGrayOrLight:@"gray"];
    _peoplePicker3._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker3];
    [_peoplePicker3 selectRow:0 inComponent:0];
    _peoplePicker3._selectColor = RGB(230, 151, 50);
    _peoplePicker3._rowNormalColor = SINGAL_COLOR;
    
    _ziyoumoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ziyoumoshiBtn.frame = CGRectMake(leftRight+rowGap*3+cellWidth*3, height, cellWidth, cellHeight);
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_n.png"] forState:UIControlStateNormal];
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_s.png"] forState:UIControlStateHighlighted];
    [_ziyoumoshiBtn setTitle:@"自由模式" forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _ziyoumoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_ziyoumoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_ziyoumoshiBtn.imageView.frame.size.height+50,-75,-20,5)];
    [_ziyoumoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_ziyoumoshiBtn.titleLabel.bounds.size.height, 0)];
    [_ziyoumoshiBtn addTarget:self action:@selector(ziyouAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ziyoumoshiBtn];
    
    _peoplePicker4 = [[CustomPickerView alloc] initWithFrame:CGRectMake(leftRight+rowGap*3+cellWidth*3+pickerRowLeft, height+pickerHeight, 100, 120) withGrayOrLight:@"gray"];
    _peoplePicker4._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker4];
    [_peoplePicker4 selectRow:0 inComponent:0];
    _peoplePicker4._selectColor = RGB(230, 151, 50);
    _peoplePicker4._rowNormalColor = SINGAL_COLOR;
}

- (void) zhuxiAction:(id)sender{
    
}

- (void) luntiAction:(id)sender{
    
}

- (void) shenqingAction:(id)sender{
    
}

- (void) ziyouAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
