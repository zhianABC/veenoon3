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

@interface UserInfoCollectViewCtrl () <UIScrollViewDelegate> {
    
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
    _content.showsHorizontalScrollIndicator = NO;
    _content.delegate = self;
    
    [self drawYearGraphic];
    [self drawMonthGraphic];
    [self drawDaysGraphic];
    
    btnYear = [UIButton buttonWithType:UIButtonTypeCustom];
    btnYear.frame  = CGRectMake(60, SCREEN_HEIGHT - 140, 50, 50);
    [btnYear setTitle:@"年" forState:UIControlStateNormal];
    [btnYear setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnYear.titleLabel.font = [UIFont systemFontOfSize:14];
    //[btnYear setImage:[UIImage imageNamed:@"info_collect_y.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnYear];
    
    btnMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMonth.frame  = CGRectMake(CGRectGetMaxX(btnYear.frame)+10, SCREEN_HEIGHT - 140, 50, 50);
    [btnMonth setTitle:@"月" forState:UIControlStateNormal];
    [btnMonth setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnMonth.titleLabel.font = [UIFont systemFontOfSize:14];
    //[btnMonth setImage:[UIImage imageNamed:@"info_collect_m.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnMonth];
    
    btnDay = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDay.frame  = CGRectMake(CGRectGetMaxX(btnMonth.frame)+10, SCREEN_HEIGHT - 140, 50, 50);
    [btnDay setTitle:@"日" forState:UIControlStateNormal];
    [btnDay setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnDay.titleLabel.font = [UIFont systemFontOfSize:14];
    //[btnDay setImage:[UIImage imageNamed:@"info_collect_d.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnDay];
    
    btnMonth.center = CGPointMake(SCREEN_WIDTH/2, btnMonth.center.y);
    btnYear.center = CGPointMake(SCREEN_WIDTH/2 - 50, btnYear.center.y);
    btnDay.center = CGPointMake(SCREEN_WIDTH/2 + 50, btnDay.center.y);
    
    
    [btnYear addTarget:self
                 action:@selector(yearAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [btnMonth addTarget:self
                 action:@selector(monthAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [btnDay addTarget:self
                 action:@selector(dayAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    /*
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
    
    */
    
    [self yearAction:nil];
}

- (void) yearAction:(id)sender{
    
    [btnYear setTitleColor:RGBA(3, 235, 211,1) forState:UIControlStateNormal];
    btnYear.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [btnMonth setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnMonth.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btnDay setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnDay.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_content setContentOffset:CGPointMake(0, 0) animated:NO];

}
- (void) monthAction:(id)sender{
    
    [btnYear setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnYear.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btnMonth setTitleColor:RGBA(3, 235, 211,1) forState:UIControlStateNormal];
    btnMonth.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [btnDay setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnDay.titleLabel.font = [UIFont systemFontOfSize:14];

    
   [_content setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}
- (void) dayAction:(id)sender{
    
    [btnYear setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnYear.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btnMonth setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
    btnMonth.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btnDay setTitleColor:RGBA(3, 235, 211,1) forState:UIControlStateNormal];
    btnDay.titleLabel.font = [UIFont systemFontOfSize:18];

    
   [_content setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat pageWidth = scrollView.frame.size.width;
    
    int page = scrollView.contentOffset.x/pageWidth;
    
    if(page == 0)
    {
        [btnYear setTitleColor:RGBA(3, 235, 211,1) forState:UIControlStateNormal];
        btnYear.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btnMonth setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
        btnMonth.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btnDay setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
        btnDay.titleLabel.font = [UIFont systemFontOfSize:14];

    }
    else if(page == 1)
    {
        [btnYear setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
        btnYear.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btnMonth setTitleColor:RGBA(3, 235, 211,1) forState:UIControlStateNormal];
        btnMonth.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btnDay setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
        btnDay.titleLabel.font = [UIFont systemFontOfSize:14];

    }
    else if(page == 2)
    {
        [btnYear setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
        btnYear.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btnMonth setTitleColor:RGBA(3, 235, 211,0.5) forState:UIControlStateNormal];
        btnMonth.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [btnDay setTitleColor:RGBA(3, 235, 211,1) forState:UIControlStateNormal];
        btnDay.titleLabel.font = [UIFont systemFontOfSize:18];

    }
    
}


- (void) drawYearGraphic{
    
    
    
    colYear = [[ColumnsView alloc] initWithFrame:CGRectZero];
    colYear.xStepPixel = 66;
    colYear.yStepPixel = 36;
    colYear.xStepValues = @[@"1月",@"2月",@"3月",@"4月",
                            @"5月",@"6月",@"7月",@"8月",
                            @"9月",@"10月",@"11月",@"12月"];
    colYear.yStepValues = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50"];
    colYear._themeColor = RGB(3, 235, 211);
    colYear._lineColor = RGB(3, 235, 211);
    colYear.xName = @"月份";
    colYear.yName = @"KW-h";
    
    [colYear initXY];
    colYear.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    colYear.maxColValue = 50;
    colYear.colWidth = 50;
    colYear.colValues = @[@"40",@"30",@"20",@"10",@"40",@"20",
                          @"10",@"20",@"20",@"20",@"20",@"20"];
    [colYear draw];
    
    [_content addSubview:colYear];
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy年"];
    NSString *yearVal = [fm stringFromDate:date];
    
    
    //back_white_ico@2x
    UILabel *yearL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    yearL.textAlignment = NSTextAlignmentCenter;
    yearL.font = [UIFont systemFontOfSize:16];
    yearL.textColor = RGB(3, 235, 211);
    [_content addSubview:yearL];
    yearL.text = yearVal;
    
    yearL.center = CGPointMake(colYear.center.x, CGRectGetMinY(colYear.frame)-30);
    
    CGSize s = [yearL.text sizeWithAttributes:@{NSFontAttributeName:yearL.font}];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, s.width+5, 1)];
    line.backgroundColor = RGB(3, 235, 211);
    [_content addSubview:line];
    line.center = CGPointMake(yearL.center.x, yearL.center.y+9);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_content addSubview:leftBtn];
    leftBtn.frame = CGRectMake(0, 0, 60, 60);
    [leftBtn setImage:[UIImage imageNamed:@"back_white_ico.png"]
             forState:UIControlStateNormal];
    leftBtn.center = CGPointMake(yearL.center.x-100, yearL.center.y);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_content addSubview:rightBtn];
    rightBtn.frame = CGRectMake(0, 0, 60, 60);
    [rightBtn setImage:[UIImage imageNamed:@"right_white_ico.png"]
              forState:UIControlStateNormal];
    rightBtn.center = CGPointMake(yearL.center.x+100, yearL.center.y);
   
}

- (void) drawMonthGraphic
{
    
    
    NSDate *date = [NSDate date];
    NSDate *lastDay = [date endOfMonth];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"dd"];
    NSString *dd = [fm stringFromDate:lastDay];
    
    NSMutableArray *days = [NSMutableArray array];
    NSMutableArray *colvs = [NSMutableArray array];
    for(int i = 1; i <= [dd intValue]; i++)
    {
        [days addObject:[NSString stringWithFormat:@"%d", i]];
        
        int val = random()%50;
        [colvs addObject:[NSString stringWithFormat:@"%d", val]];
    }
    
    colMonth = [[ColumnsView alloc] initWithFrame:CGRectZero];
    colMonth.xStepPixel = 26;
    colMonth.yStepPixel = 36;
    colMonth.xStepValues = days;
    colMonth.yStepValues = @[@"0",@"5",@"10",@"15",@"20",@"25",
                             @"30",@"35",@"40",@"45",@"50"];
    colMonth._themeColor = RGB(3, 235, 211);
    colMonth._lineColor = RGB(3, 235, 211);
    colMonth.xName = @"日期";
    colMonth.yName = @"KW-h";
    
    [colMonth initXY];
    colMonth.center = CGPointMake(SCREEN_WIDTH*3/2, SCREEN_HEIGHT/2);
    
    colMonth.maxColValue = 50;
    colMonth.colWidth = 18;
    colMonth.colValues = colvs;
    [colMonth draw];
    
    [_content addSubview:colMonth];
    
    [fm setDateFormat:@"yyyy年MM月"];
    NSString *yearVal = [fm stringFromDate:date];
    
    
    //back_white_ico@2x
    UILabel *yearL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
    yearL.textAlignment = NSTextAlignmentCenter;
    yearL.font = [UIFont systemFontOfSize:16];
    yearL.textColor = RGB(3, 235, 211);
    [_content addSubview:yearL];
    yearL.text = yearVal;
    
    yearL.center = CGPointMake(colMonth.center.x, CGRectGetMinY(colMonth.frame)-30);
    
    CGSize s = [yearL.text sizeWithAttributes:@{NSFontAttributeName:yearL.font}];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, s.width+5, 1)];
    line.backgroundColor = RGB(3, 235, 211);
    [_content addSubview:line];
    line.center = CGPointMake(yearL.center.x, yearL.center.y+9);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_content addSubview:leftBtn];
    leftBtn.frame = CGRectMake(0, 0, 60, 60);
    [leftBtn setImage:[UIImage imageNamed:@"back_white_ico.png"]
             forState:UIControlStateNormal];
    leftBtn.center = CGPointMake(yearL.center.x-100, yearL.center.y);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_content addSubview:rightBtn];
    rightBtn.frame = CGRectMake(0, 0, 60, 60);
    [rightBtn setImage:[UIImage imageNamed:@"right_white_ico.png"]
              forState:UIControlStateNormal];
    rightBtn.center = CGPointMake(yearL.center.x+100, yearL.center.y);
}

- (void) drawDaysGraphic
{
    NSMutableArray *hours = [NSMutableArray array];
    NSMutableArray *colvs = [NSMutableArray array];
    for(int i = 1; i <= 24; i++)
    {
        [hours addObject:[NSString stringWithFormat:@"%d", i]];
        
        int val = random()%50;
        [colvs addObject:[NSString stringWithFormat:@"%d", val]];
    }
    
    colDay = [[ColumnsView alloc] initWithFrame:CGRectZero];
    colDay.xStepPixel = 34;
    colDay.yStepPixel = 36;
    colDay.xStepValues = hours;
    colDay.yStepValues = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50"];
    colDay._themeColor = RGB(3, 235, 211);
    colDay._lineColor = RGB(3, 235, 211);
    colDay.xName = @"小时";
    colDay.yName = @"KW-h";
    
    [colDay initXY];
    colDay.center = CGPointMake( SCREEN_WIDTH*5/2, SCREEN_HEIGHT/2);
    
    colDay.maxColValue = 50;
    colDay.colWidth = 24;
    colDay.colValues = colvs;
    [colDay draw];
    
    [_content addSubview:colDay];
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy年MM月dd日"];
    NSString *yearVal = [fm stringFromDate:date];
    
    
    //back_white_ico@2x
    UILabel *yearL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 20)];
    yearL.textAlignment = NSTextAlignmentCenter;
    yearL.font = [UIFont systemFontOfSize:16];
    yearL.textColor = RGB(3, 235, 211);
    [_content addSubview:yearL];
    yearL.text = yearVal;
    
    yearL.center = CGPointMake(colDay.center.x, CGRectGetMinY(colDay.frame)-30);
    
    CGSize s = [yearL.text sizeWithAttributes:@{NSFontAttributeName:yearL.font}];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, s.width+5, 1)];
    line.backgroundColor = RGB(3, 235, 211);
    [_content addSubview:line];
    line.center = CGPointMake(yearL.center.x, yearL.center.y+9);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_content addSubview:leftBtn];
    leftBtn.frame = CGRectMake(0, 0, 60, 60);
    [leftBtn setImage:[UIImage imageNamed:@"back_white_ico.png"]
             forState:UIControlStateNormal];
    leftBtn.center = CGPointMake(yearL.center.x-100, yearL.center.y);
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_content addSubview:rightBtn];
    rightBtn.frame = CGRectMake(0, 0, 60, 60);
    [rightBtn setImage:[UIImage imageNamed:@"right_white_ico.png"]
              forState:UIControlStateNormal];
    rightBtn.center = CGPointMake(yearL.center.x+100, yearL.center.y);
    
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
