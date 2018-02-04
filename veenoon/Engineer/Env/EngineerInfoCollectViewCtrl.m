//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerInfoCollectViewCtrl.h"
#import "ColumnsView.h"
#import "UIButton+Color.h"
#import "NSDate-Helper.h"
#import "CircleProgressView.h"
#import "CustomPickerView.h"
#import "EngineerScenarioSettingsViewCtrl.h"

@interface EngineerInfoCollectViewCtrl () <CustomPickerViewDelegate>{
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    ColumnsView *colYear;
    ColumnsView *colMonth;
    ColumnsView *colDay;
    
    UIButton *btnYear;
    UIButton *btnMonth;
    UIButton *btnDay;
    
    UIScrollView *_content;
    
    CircleProgressView *circle;
    CircleProgressView *circleA;
}
@end

@implementation EngineerInfoCollectViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-120)];
    [self.view addSubview:_content];
    _content.pagingEnabled = YES;
    _content.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-120);
    
    [self drawYearGraphic];
    [self drawMonthGraphic];
    [self drawDaysGraphic];
    
    btnYear = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
    btnYear.frame  = CGRectMake(60, SCREEN_HEIGHT - 150, 50, 50);
    btnYear.layer.cornerRadius = 5;
    btnYear.layer.borderWidth = 2;
    btnYear.layer.borderColor = [UIColor clearColor].CGColor;;
    btnYear.clipsToBounds = YES;
    [btnYear setImage:[UIImage imageNamed:@"info_year_n.png"] forState:UIControlStateNormal];
    [btnYear setImage:[UIImage imageNamed:@"info_year_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnYear];
    
    btnMonth = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
    btnMonth.frame  = CGRectMake(CGRectGetMaxX(btnYear.frame)+10, SCREEN_HEIGHT - 150, 50, 50);
    btnMonth.layer.cornerRadius = 5;
    btnMonth.layer.borderWidth = 2;
    btnMonth.layer.borderColor = [UIColor clearColor].CGColor;;
    btnMonth.clipsToBounds = YES;
    [btnMonth setImage:[UIImage imageNamed:@"info_month_n.png"] forState:UIControlStateNormal];
    [btnMonth setImage:[UIImage imageNamed:@"info_month_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnMonth];
    
    btnDay = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
    btnDay.frame  = CGRectMake(CGRectGetMaxX(btnMonth.frame)+10, SCREEN_HEIGHT - 150, 50, 50);
    btnDay.layer.cornerRadius = 5;
    btnDay.layer.borderWidth = 2;
    btnDay.layer.borderColor = [UIColor clearColor].CGColor;;
    btnDay.clipsToBounds = YES;
    [btnDay setImage:[UIImage imageNamed:@"info_day_n.png"] forState:UIControlStateNormal];
    [btnDay setImage:[UIImage imageNamed:@"info_day_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnDay];
    
    [btnYear addTarget:self
                action:@selector(yearAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [btnMonth addTarget:self
                 action:@selector(monthAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [btnDay addTarget:self
               action:@selector(dayAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    circle = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.view addSubview:circle];
    [circle setProgress:0.8];
    circle.center = CGPointMake(SCREEN_WIDTH - 200, 120);
    circle.textL.text = @"220V";
    
    UILabel* vL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    vL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:vL];
    vL.font = [UIFont boldSystemFontOfSize:16];
    vL.textColor  = [UIColor whiteColor];
    vL.text = @"电压";
    vL.center = CGPointMake(CGRectGetMinX(circle.frame)-20,
                            CGRectGetMinY(circle.frame)+6);
    
    circleA = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.view addSubview:circleA];
    [circleA setProgress:0.2];
    circleA.center = CGPointMake(SCREEN_WIDTH - 80, 120);
    circleA.textL.text = @"1.5A";
    
    UILabel* aL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    aL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:aL];
    aL.font = [UIFont boldSystemFontOfSize:16];
    aL.textColor  = [UIColor whiteColor];
    aL.text = @"电流";
    aL.center = CGPointMake(CGRectGetMinX(circleA.frame)-20,
                            CGRectGetMinY(circleA.frame)+6);
    
    
    [self yearAction:nil];
}

- (void) yearAction:(id)sender{
    
    [_content setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
- (void) monthAction:(id)sender{
    
    [_content setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}
- (void) dayAction:(id)sender{
    
    [_content setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
}

- (void) drawYearGraphic{
    
    colYear = [[ColumnsView alloc] initWithFrame:CGRectZero];
    colYear.xStepPixel = 75;
    colYear.yStepPixel = 30;
    colYear.xStepValues = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    colYear.yStepValues = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50"];
    colYear._themeColor = RGB(0, 89, 118);
    colYear._lineColor = [UIColor whiteColor];
    colYear.xName = @"月份";
    colYear.yName = @"KW-h";
    
    [colYear initXY];
    colYear.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60);
    
    colYear.maxColValue = 50;
    colYear.colWidth = 50;
    colYear.colValues = @[@"40",@"30",@"50",@"10",@"40",@"20",@"10",@"20",@"20",@"20",@"20",@"20"];
    [colYear draw];
    
    [_content addSubview:colYear];
    
    
}

- (void) drawMonthGraphic
{
    
    
    NSDate *date = [NSDate date];
    NSDate *lastDay = [date endOfMonth];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd"];
    NSString *dd = [fm stringFromDate:lastDay];
    
    NSMutableArray *days = [NSMutableArray array];
    for(int i = 1; i <= [dd intValue]; i++)
    {
        [days addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    colMonth = [[ColumnsView alloc] initWithFrame:CGRectZero];
    colMonth.xStepPixel = 30;
    colMonth.yStepPixel = 30;
    colMonth.xStepValues = days;
    colMonth.yStepValues = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50"];
    colMonth._themeColor = RGB(0, 89, 118);
    colMonth._lineColor = [UIColor whiteColor];
    colMonth.xName = @"日期";
    colMonth.yName = @"KW-h";
    
    [colMonth initXY];
    colMonth.center = CGPointMake(SCREEN_WIDTH*3/2, SCREEN_HEIGHT/2-60);
    
    colMonth.maxColValue = 50;
    colMonth.colWidth = 20;
    colMonth.colValues = @[@"40",@"30",@"50",@"10",@"40",@"20",@"10",@"20",@"20",@"20",@"20",@"20"];
    [colMonth draw];
    
    [_content addSubview:colMonth];
    
    
}

- (void) drawDaysGraphic
{
    NSMutableArray *hours = [NSMutableArray array];
    for(int i = 1; i <= 24; i++)
    {
        [hours addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    colDay = [[ColumnsView alloc] initWithFrame:CGRectZero];
    colDay.xStepPixel = 40;
    colDay.yStepPixel = 30;
    colDay.xStepValues = hours;
    colDay.yStepValues = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50"];
    colDay._themeColor = RGB(0, 89, 118);
    colDay._lineColor = [UIColor whiteColor];
    colDay.xName = @"小时";
    colDay.yName = @"KW-h";
    
    [colDay initXY];
    colDay.center = CGPointMake( SCREEN_WIDTH*5/2, SCREEN_HEIGHT/2-60);
    
    colDay.maxColValue = 50;
    colDay.colWidth = 30;
    colDay.colValues = @[@"40",@"30",@"50",@"10",@"40",@"20",@"10",@"20",@"20",@"20",@"20",@"20"];
    [colDay draw];
    
    [_content addSubview:colDay];
    
    
}
- (void) okAction:(id)sender{
    EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end









