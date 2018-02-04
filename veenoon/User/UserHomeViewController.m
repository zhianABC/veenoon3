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
    NSMutableArray *lableArray;
    NSMutableArray *roomImageArray;
    
    int selectedRoomIndex;
}
@property (nonatomic, strong) NSMutableArray *roomList;

@end

@implementation UserHomeViewController
@synthesize roomList;
@synthesize actionSheet;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lableArray = [[NSMutableArray alloc] init];
    roomImageArray = [[NSMutableArray alloc] init];
    selectedRoomIndex = -1;
    
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
        self.roomList = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, nil];
    }
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scroolView.backgroundColor = RGB(63, 58, 55);
    [self.view addSubview:scroolView];
    
    int top = 50;
    int leftRight = 60;
    int space = 10;
    
    int cellWidth = 312;
    int cellHeight = 186;
    int index = 0;
    for (id dic in roomList) {
        int row = index/3;
        int col = index%3;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIImage *roomImage = [dic objectForKey:@"image"];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.userInteractionEnabled=YES;
        roomeImageView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        view.tag = index;
        [roomeImageView addSubview:view];
        
        [roomImageArray addObject:roomeImageView];
        roomeImageView.tag = index;
        [scroolView addSubview:roomeImageView];
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [view addGestureRecognizer:longPress0];
        
        UIImageView *roomeBotomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_meeting_roome_b.png"]];
        [roomeImageView addSubview:roomeBotomImageView];
        roomeBotomImageView.frame = CGRectMake(0, CGRectGetHeight(roomeImageView.frame)-30, roomeImageView.frame.size.width, 30);
        roomeBotomImageView.userInteractionEnabled=YES;
        
        index++;
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        cameraBtn.frame = CGRectMake(CGRectGetWidth(roomeImageView.frame)-40, CGRectGetHeight(roomeImageView.frame)-40, 40, 40);
        cameraBtn.tag = index;
        [cameraBtn setImage:[UIImage imageNamed:@"camera_n.png"] forState:UIControlStateNormal];
        [cameraBtn setImage:[UIImage imageNamed:@"camera_s.png"] forState:UIControlStateHighlighted];
        [cameraBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [roomeImageView addSubview:cameraBtn];
        
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = index;
        [view addGestureRecognizer:tapGesture];
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(roomeImageView.frame)-30, 200, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [roomeImageView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [dic objectForKey:@"roomname"];
        
        [lableArray addObject:titleL];
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

- (void) longPressed0:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
        int index = (int)viewRecognizer.view.tag;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入会议室名称" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"会议室名称";
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
            NSString *scenarioName = envirnmentNameTextField.text;
            if (scenarioName && [scenarioName length] > 0) {
                NSMutableDictionary *meetingDic = [self.roomList objectAtIndex:index];
                UILabel *scenarioLabel = [lableArray objectAtIndex:index];
                
                [meetingDic setObject:scenarioName forKey:@"roomname"];
                scenarioLabel.text =scenarioName;
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
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

- (void) cameraAction:(id)sender {
    UIButton *cameraBtn = (UIButton*) sender;
}
@end
