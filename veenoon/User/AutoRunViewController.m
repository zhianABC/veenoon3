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
    
    [self loadAutoItems];
    
}

- (void) loadAutoItems{
    
    [_autoItems addObject:@{@"name":@"+", @"type":@"1"}];
    
    int left = (SCREEN_WIDTH - 15*6 - cellWidth*7)/2;
    
    int x = left;
    int y = 0;
    for(int i = 0; i < [_autoItems count]; i++)
    {
        int row = i/7;
        int col = i%7;
        
        x = row * (cellWidth+15) + left;
        y = col * (cellWidth+15) + 15;
        
        UIButton *btn = [UIButton buttonWithColor:RGB(0x52, 0x4e, 0x4b)
                                         selColor:nil];
        btn.frame = CGRectMake(x, y, cellWidth, cellWidth);
        [_content addSubview:btn];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.tag = i;
        
        [btn addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void) showItems{
    
    
    
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
