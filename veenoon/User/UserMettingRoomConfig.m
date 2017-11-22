//
//  UserMettingRoomConfig.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMeetingRoomConfig.h"

@interface UserMeetingRoomConfig () {
    NSMutableDictionary *meetingRoomDic;
}

@end

@implementation UserMeetingRoomConfig
@synthesize meetingRoomDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, SCREEN_HEIGHT -45, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [backBtn addTarget:self action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 200, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [meetingRoomDic objectForKey:@"roomname"];
    
    
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
