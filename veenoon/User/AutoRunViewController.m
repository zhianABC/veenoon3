//
//  AutoRunViewController.m
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AutoRunViewController.h"
#import "UIButton+Color.h"
#import "AutoRunSetView.h"
#import "MeetingRoom.h"
#import "Scenario.h"
#import "DataBase.h"

@interface AutoRunViewController ()
{
    UIScrollView *_content;
    
    int cellWidth;
    
    
}
@property (nonatomic, strong) NSMutableArray *_autoItems;
@end

@implementation AutoRunViewController
@synthesize _autoItems;
@synthesize _room;
@synthesize _scenarios;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, 40, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [backBtn addTarget:self action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, SCREEN_WIDTH-100, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"自动化设置";
    
    self._autoItems = [NSMutableArray array];
    cellWidth = 110;
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-100-50)];
    [self.view addSubview:_content];
    _content.clipsToBounds = YES;
    
    //
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyRefreshItems:)
                                                 name:@"Notify_Refresh_Items"
                                               object:nil];
    
    [self loadAutoItems];
    
}

- (void) loadAutoItems{
    
    NSArray *datas = [[DataBase sharedDatabaseInstance] getScenarioSchedules];
    
    [_autoItems addObjectsFromArray:datas];
    
    [_autoItems addObject:@{@"name":@"+", @"type":@"1"}];
    
    int left = (SCREEN_WIDTH - 15*6 - cellWidth*7)/2;
    
    int x = left;
    int y = 0;
    for(int i = 0; i < [_autoItems count]; i++)
    {
        NSDictionary *dic = [_autoItems objectAtIndex:i];
        
        int row = i/7;
        int col = i%7;
        
        x = col * (cellWidth+15) + left;
        y = row * (cellWidth+15) + 15;
        
        UIButton *btn = [UIButton buttonWithColor:RGB(0x52, 0x4e, 0x4b)
                                         selColor:nil];
        btn.frame = CGRectMake(x, y, cellWidth, cellWidth);
        [_content addSubview:btn];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.tag = i;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:btn.bounds];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.numberOfLines = 2;
        
        int type = [[dic objectForKey:@"type"] intValue];
        if(type == 0)
        {
            int tms = [[dic objectForKey:@"date"] intValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:tms];
            
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"HH:mm"];
            
            NSString *times = [fm stringFromDate:date];
            
            titleL.text = [NSString stringWithFormat:@"%@\n%@",times,[dic objectForKey:@"name"]];

        }
        else
        {
            titleL.text = [dic objectForKey:@"name"];
            [btn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
    }
}

- (void) notifyRefreshItems:(id)sender{
    
    [_autoItems removeAllObjects];
    
    [self loadAutoItems];
}

- (void) buttonAction:(UIButton*)sender{
    
    NSDictionary *item = [_autoItems objectAtIndex:sender.tag];
    
    int type = [[item objectForKey:@"type"] intValue];
    if(type == 1)
    {
        AutoRunSetView *autoView = [[AutoRunSetView alloc] initWithFrame:CGRectMake(0,
                                                                                   0,
                                                                                    SCREEN_WIDTH,
                                                                                    SCREEN_HEIGHT)];
        [self.view addSubview:autoView];
        autoView._scenarios = _scenarios;
        
        [autoView show];
    }
}


- (void)backAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
