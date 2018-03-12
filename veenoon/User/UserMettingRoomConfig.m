//
//  UserMettingRoomConfig.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMeetingRoomConfig.h"
#import "UserScnarioConfigViewController.h"

@interface UserMeetingRoomConfig () {
    NSMutableDictionary *meetingRoomDic;
    
    UIButton *_trainingBtn;
    UIButton *_envirementControlBtn;
    UIButton *_guestBtn;
    UIButton *_envirementLightBtn;
    UIButton *_discussionBtn;
    UIButton *_leaveMeetingBtn;
    
    UIScrollView *_content;
}
@property (nonatomic, strong) NSArray *scens;

@end

@implementation UserMeetingRoomConfig
@synthesize meetingRoomDic;
@synthesize scens;

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
    
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-80-40)];
    [self.view addSubview:_content];
    
    
    self.scens = @[@{@"icon_nor":@"user_training_n.png",@"icon_sel":@"user_training_s.png",
                         @"title":@"专业培训",@"title_en":@"Training"},
                       @{@"icon_nor":@"envirement_control_n.png",@"icon_sel":@"envirement_control_s.png",
                         @"title":@"环境控制",@"title_en":@"Environmental control"},
                       @{@"icon_nor":@"guest_reception_n.png",@"icon_sel":@"guest_reception_s.png",
                         @"title":@"宾客接待",@"title_en":@"Guests reception"},
                       @{@"icon_nor":@"envirement_light_n.png",@"icon_sel":@"envirement_light_s.png",
                         @"title":@"环境照明",@"title_en":@"Ambient lighting"},
                       @{@"icon_nor":@"meeting_discuss_n.png",@"icon_sel":@"meeting_discuss_s.png",
                         @"title":@"讨论会议",@"title_en":@"Meeting"},
                       @{@"icon_nor":@"close_system_n.png",@"icon_sel":@"close_system_s.png",
                         @"title":@"离开会场",@"title_en":@"Close system"}];
    
    
    
    int ox = (SCREEN_WIDTH - 420*2 - 20)/2 - 20;
    int y = 70;
    int x = ox;
    for(int i = 0; i < [scens count]; i++)
    {
        
        if(i%2==0 && i > 0){
            y+=200;
            y+=5;
            x = ox;
        }
        if(i%2 != 0 ){
            x = ox+420;
            x+=10;
        }
        
        NSDictionary *scen = [scens objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, 481, 250);
        [btn setImage:[UIImage imageNamed:[scen objectForKey:@"icon_nor"]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[scen objectForKey:@"icon_sel"]] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(userTrainingAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.tag = i;
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [btn addGestureRecognizer:longPress0];
    }
}

- (void) longPressed0:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
        int index = (int)viewRecognizer.view.tag;
        
        NSDictionary *scen = [scens objectAtIndex:index];
        
        UserScnarioConfigViewController *invitation = [[UserScnarioConfigViewController alloc] init];
        invitation._data = scen;
        [self.navigationController pushViewController:invitation animated:YES];
    }
}

- (void) userTrainingAction:(UIButton*)sender{
    
}



- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
