//
//  UserYouXianViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/28.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserYouXianViewController.h"
#import "CenterCustomerPickerView.h"

@interface UserYouXianViewController ()<CenterCustomerPickerViewDelegate> {
    UIButton *_zhuximoshiBtn;
    UIButton *_luntimoshiBtn;
    UIButton *_shenqingmoshiBtn;
    UIButton *_ziyoumoshiBtn;
    
    CenterCustomerPickerView *_peoplePicker1;
    CenterCustomerPickerView *_peoplePicker2;
    CenterCustomerPickerView *_peoplePicker3;
}
@end

@implementation UserYouXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"user_corner_handto.png" withTitle:@"手拉手会议系统"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
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
    int height = SCREEN_HEIGHT - 550;
    int cellHeight = 150;
    
    int pickerRowLeft = -20;
    
    int pickerHeight = 250;
    
    int cellWidth = (SCREEN_WIDTH - leftRight*2 - rowGap*3)/4;
    
    _zhuximoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zhuximoshiBtn.frame = CGRectMake(leftRight, height, cellWidth, cellHeight);
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_n.png"] forState:UIControlStateNormal];
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_s.png"] forState:UIControlStateHighlighted];
    [_zhuximoshiBtn setTitle:@"主席模式" forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _zhuximoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_zhuximoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_zhuximoshiBtn.imageView.frame.size.height+50,-90,-20,-20)];
    [_zhuximoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-35.0,0.0,_zhuximoshiBtn.titleLabel.bounds.size.height, 0)];
    [_zhuximoshiBtn addTarget:self action:@selector(zhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zhuximoshiBtn];
    
    _peoplePicker1 = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(leftRight+pickerRowLeft-5, height+pickerHeight, 120, 120)];
    [_peoplePicker1 removeArray];
    
    _peoplePicker1._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker1];
    [_peoplePicker1 selectRow:0 inComponent:0];
    _peoplePicker1._selectColor = RGB(230, 151, 50);
    _peoplePicker1._rowNormalColor = SINGAL_COLOR;
    _peoplePicker1.hidden=YES;
    _peoplePicker1.delegate_=self;
    
    _luntimoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _luntimoshiBtn.frame = CGRectMake(leftRight+rowGap+cellWidth, height, cellWidth, cellHeight);
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_n.png"] forState:UIControlStateNormal];
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_s.png"] forState:UIControlStateHighlighted];
    [_luntimoshiBtn setTitle:@"轮替模式" forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _luntimoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_luntimoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_luntimoshiBtn.imageView.frame.size.height+50,-70,-20,-5)];
    [_luntimoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_luntimoshiBtn.titleLabel.bounds.size.height, 0)];
    [_luntimoshiBtn addTarget:self action:@selector(luntiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_luntimoshiBtn];
    
    _peoplePicker2 = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(leftRight+rowGap+cellWidth+pickerRowLeft-10, height+pickerHeight, 120, 120) ];
    [_peoplePicker2 removeArray];
    _peoplePicker2._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker2];
    [_peoplePicker2 selectRow:0 inComponent:0];
    _peoplePicker2._selectColor = RGB(230, 151, 50);
    _peoplePicker2._rowNormalColor = SINGAL_COLOR;
    _peoplePicker2.hidden=YES;
    _peoplePicker2.delegate_=self;
    
    _shenqingmoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shenqingmoshiBtn.frame = CGRectMake(leftRight+rowGap*2+cellWidth*2, height, cellWidth, cellHeight);
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_n.png"] forState:UIControlStateNormal];
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_s.png"] forState:UIControlStateHighlighted];
    [_shenqingmoshiBtn setTitle:@"申请模式" forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _shenqingmoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_shenqingmoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_shenqingmoshiBtn.imageView.frame.size.height+50,-70,-20,-5)];
    [_shenqingmoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_shenqingmoshiBtn.titleLabel.bounds.size.height, 0)];
    [_shenqingmoshiBtn addTarget:self action:@selector(shenqingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shenqingmoshiBtn];
    
    _peoplePicker3 = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(leftRight+rowGap*2+cellWidth*2+pickerRowLeft-15, height+pickerHeight, 120, 120)];
    [_peoplePicker3 removeArray];
    _peoplePicker3._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker3];
    [_peoplePicker3 selectRow:0 inComponent:0];
    _peoplePicker3._selectColor = RGB(230, 151, 50);
    _peoplePicker3._rowNormalColor = SINGAL_COLOR;
    _peoplePicker3.hidden=YES;
    _peoplePicker3.delegate_=self;
    
    _ziyoumoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ziyoumoshiBtn.frame = CGRectMake(leftRight+rowGap*3+cellWidth*3, height, cellWidth, cellHeight);
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_n.png"] forState:UIControlStateNormal];
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_s.png"] forState:UIControlStateHighlighted];
    [_ziyoumoshiBtn setTitle:@"自由模式" forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _ziyoumoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_ziyoumoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_ziyoumoshiBtn.imageView.frame.size.height+50,-70,-20,-5)];
    [_ziyoumoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_ziyoumoshiBtn.titleLabel.bounds.size.height, 0)];
    [_ziyoumoshiBtn addTarget:self action:@selector(ziyouAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ziyoumoshiBtn];
}

- (void) zhuxiAction:(id)sender{
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_s.png"] forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_n.png"] forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_n.png"] forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_n.png"] forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    _peoplePicker1.hidden=NO;
    _peoplePicker2.hidden=YES;
    _peoplePicker3.hidden=YES;
}

- (void) luntiAction:(id)sender{
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_n.png"] forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_s.png"] forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_n.png"] forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_n.png"] forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    _peoplePicker1.hidden=YES;
    _peoplePicker2.hidden=NO;
    _peoplePicker3.hidden=YES;
}

- (void) shenqingAction:(id)sender{
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_n.png"] forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_n.png"] forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_s.png"] forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_n.png"] forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    _peoplePicker1.hidden=YES;
    _peoplePicker2.hidden=YES;
    _peoplePicker3.hidden=NO;
}

- (void) ziyouAction:(id)sender{
    [_zhuximoshiBtn setImage:[UIImage imageNamed:@"zhuximoshi_n.png"] forState:UIControlStateNormal];
    [_zhuximoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_luntimoshiBtn setImage:[UIImage imageNamed:@"luntimoshi_n.png"] forState:UIControlStateNormal];
    [_luntimoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_shenqingmoshiBtn setImage:[UIImage imageNamed:@"shenqingmoshi_n.png"] forState:UIControlStateNormal];
    [_shenqingmoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_ziyoumoshiBtn setImage:[UIImage imageNamed:@"ziyoumoshi_s.png"] forState:UIControlStateNormal];
    [_ziyoumoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    _peoplePicker1.hidden=YES;
    _peoplePicker2.hidden=YES;
    _peoplePicker3.hidden=YES;
}

- (void) okAction:(id)sender{
    _peoplePicker1.hidden=YES;
    _peoplePicker2.hidden=YES;
    _peoplePicker3.hidden=YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didConfirmPickerValue:(NSString*) pickerValue {
    _peoplePicker1.hidden=YES;
    _peoplePicker2.hidden=YES;
    _peoplePicker3.hidden=YES;
}
@end
