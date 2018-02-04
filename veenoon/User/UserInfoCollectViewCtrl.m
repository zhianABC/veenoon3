//
//  UserInfoCollectViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserInfoCollectViewCtrl.h"
#import "UIButton+Color.h"
#import "ColumnsView.h"
#import "UIButton+Color.h"
#import "NSDate-Helper.h"
#import "CircleProgressView.h"

@interface UserInfoCollectViewCtrl () {
    
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

@implementation UserInfoCollectViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
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
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-120)];
    [self.view addSubview:_content];
    _content.pagingEnabled = YES;
    _content.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-120);
    
    [self drawYearGraphic];
    [self drawMonthGraphic];
    [self drawDaysGraphic];
    
    btnYear = [UIButton buttonWithColor:THEME_COLOR selColor:nil];
    btnYear.frame  = CGRectMake(60, SCREEN_HEIGHT - 150, 50, 50);
    [self.view addSubview:btnYear];
    
    btnMonth = [UIButton buttonWithColor:THEME_COLOR selColor:nil];
    btnMonth.frame  = CGRectMake(CGRectGetMaxX(btnYear.frame)+10, SCREEN_HEIGHT - 150, 50, 50);
    [self.view addSubview:btnMonth];
    
    btnDay = [UIButton buttonWithColor:THEME_COLOR selColor:nil];
    btnDay.frame  = CGRectMake(CGRectGetMaxX(btnMonth.frame)+10, SCREEN_HEIGHT - 150, 50, 50);
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
    colYear._themeColor = SINGAL_COLOR;
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
    colMonth._themeColor = SINGAL_COLOR;
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
    colDay._themeColor = SINGAL_COLOR;
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
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
