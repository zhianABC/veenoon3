//
//  UserHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserHomeViewController.h"
#import "UserMeetingRoomConfig.h"

@interface UserHomeViewController () {
    NSMutableArray *roomList;
}

@end

@implementation UserHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (roomList) {
        [roomList removeAllObjects];
    } else {
        UIImage *roomImage1 = [UIImage imageNamed:@"user_meeting_room_1.png"];
        UIImage *roomImage2 = [UIImage imageNamed:@"user_meeting_room_2.png"];
        UIImage *roomImage3 = [UIImage imageNamed:@"user_meeting_room_3.png"];
        UIImage *roomImage4 = [UIImage imageNamed:@"user_meeting_room_4.png"];
        UIImage *roomImage5 = [UIImage imageNamed:@"user_meeting_room_5.png"];
        UIImage *roomImage6 = [UIImage imageNamed:@"user_meeting_room_6.png"];
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomImage1, @"image",
                                     @"meeting_room1", @"roomname",
                                    nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomImage2, @"image",
                                     @"meeting_room2", @"roomname",
                                     nil];
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomImage3, @"image",
                                     @"meeting_room3", @"roomname",
                                     nil];
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomImage4, @"image",
                                     @"meeting_room4", @"roomname",
                                     nil];
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomImage5, @"image",
                                     @"meeting_room5", @"roomname",
                                     nil];
        NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomImage6, @"image",
                                     @"meeting_room6", @"roomname",
                                     nil];
        roomList = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, nil];
    }
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scroolView.backgroundColor = RGB(63, 58, 55);
    [self.view addSubview:scroolView];
    
    int top = 50;
    int leftRight = 60;
    int space = 10;
    
    int cellWidth = (SCREEN_WIDTH - 2*leftRight - 2*space) / 3;
    int cellHeight = 186;
    int index = 0;
    for (id dic in roomList) {
        int row = index/3;
        int col = index%3;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIImage *roomImage = [dic objectForKey:@"image"];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = index;
        [scroolView addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        roomeImageView.userInteractionEnabled=YES;
        
        UIImageView *roomeBotomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_meeting_roome_b.png"]];
        [roomeImageView addSubview:roomeBotomImageView];
        roomeBotomImageView.frame = CGRectMake(18, roomeImageView.frame.size.height-48, roomeImageView.frame.size.width-36, 30);
        roomeBotomImageView.userInteractionEnabled=YES;
        
        index++;
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        cameraBtn.frame = CGRectMake(CGRectGetMaxX(roomeImageView.frame)-60, CGRectGetMaxY(roomeImageView.frame) - 55, 50, 50);
        cameraBtn.tag = index;
        [cameraBtn setImage:[UIImage imageNamed:@"camera_n.png"] forState:UIControlStateNormal];
        [cameraBtn setImage:[UIImage imageNamed:@"camera_s.png"] forState:UIControlStateHighlighted];
        [cameraBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [scroolView addSubview:cameraBtn];
        
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = index;
        [roomeImageView addGestureRecognizer:tapGesture];
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(40, roomeImageView.frame.size.height-45, 200, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [roomeImageView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [dic objectForKey:@"roomname"];
    }
    
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
    [backBtn addTarget:self
                  action:@selector(backAction:)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    long index = gestureRecognizer.view.tag;
    NSMutableDictionary *dic = [roomList objectAtIndex:index];
    
    UserMeetingRoomConfig *lctrl = [[UserMeetingRoomConfig alloc] init];
    lctrl.meetingRoomDic = dic;
    
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) cameraAction:(id)sender{
    
}
@end
