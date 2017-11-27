//
//  UserHuiYinViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/27.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserHuiYinViewController.h"
#import "CustomPickerView.h"

@interface UserHuiYinViewController () {
    UIButton *_yuyinjiliBtn;
    UIButton *_shedingzhuxiBtn;
    UIButton *_biaozhunmoshiBtn;
    UIButton *_fayanrenshuBtn;
    
    CustomPickerView *_peoplePicker;
}
@end

@implementation UserHuiYinViewController

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
    
    _yuyinjiliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yuyinjiliBtn.frame = CGRectMake(390, 250, 50, 100);
    [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_n.png"] forState:UIControlStateNormal];
    [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_s.png"] forState:UIControlStateHighlighted];
    [_yuyinjiliBtn setTitle:@"语音激励" forState:UIControlStateNormal];
    [_yuyinjiliBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_yuyinjiliBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _yuyinjiliBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_yuyinjiliBtn setTitleEdgeInsets:UIEdgeInsetsMake(_yuyinjiliBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_yuyinjiliBtn setImageEdgeInsets:UIEdgeInsetsMake(-50.0,-10,_yuyinjiliBtn.titleLabel.bounds.size.height, 0)];
    [_yuyinjiliBtn addTarget:self action:@selector(yuyinjiliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yuyinjiliBtn];
    
    _shedingzhuxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shedingzhuxiBtn.frame = CGRectMake(440, 450, 80, 30);
    [_shedingzhuxiBtn setImage:[UIImage imageNamed:@"shedingzhuxi_n.png"] forState:UIControlStateNormal];
    [_shedingzhuxiBtn setImage:[UIImage imageNamed:@"shedingzhuxi_s.png"] forState:UIControlStateHighlighted];
    [_shedingzhuxiBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shedingzhuxiBtn];
    
    _biaozhunmoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _biaozhunmoshiBtn.frame = CGRectMake(690, 250, 50, 100);
    [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_n.png"] forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_s.png"] forState:UIControlStateHighlighted];
    [_biaozhunmoshiBtn setTitle:@"标准模式" forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _biaozhunmoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_biaozhunmoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_biaozhunmoshiBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_biaozhunmoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-50.0,-10.0,_biaozhunmoshiBtn.titleLabel.bounds.size.height, 0)];
    [_biaozhunmoshiBtn addTarget:self action:@selector(biaozhunmoshiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_biaozhunmoshiBtn];
    
    _fayanrenshuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fayanrenshuBtn.frame = CGRectMake(590, 450, 80, 30);
    [_fayanrenshuBtn setImage:[UIImage imageNamed:@"fayanrenshu_n.png"] forState:UIControlStateNormal];
    [_fayanrenshuBtn setImage:[UIImage imageNamed:@"fayanrenshu_s.png"] forState:UIControlStateHighlighted];
    [_fayanrenshuBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fayanrenshuBtn];
    
    _peoplePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _peoplePicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [self.view addSubview:_peoplePicker];
    _peoplePicker.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 260);
    _peoplePicker._selectColor = RGB(230, 151, 50);
    _peoplePicker._rowNormalColor = SINGAL_COLOR;
    [_peoplePicker selectRow:0 inComponent:0];
    IMP_BLOCK_SELF(UserHuiYinViewController);
    _peoplePicker._selectionBlock = ^(NSDictionary *values) {
        //[block_self didPickerValue:values];
    };
}

- (void) shedingzhuxiAction:(id)sender{
    
}

- (void) biaozhunmoshiAction:(id)sender{
    
}

- (void) yuyinjiliAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
