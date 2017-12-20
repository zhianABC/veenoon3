//
//  EngineerMeetingRoomListViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerMeetingRoomListViewCtrl.h"
#import "EngineerSysSelectViewCtrl.h"

@interface EngineerMeetingRoomListViewCtrl () {
    NSMutableArray *_meetingRoomList;
}
@property (nonatomic, strong) NSMutableArray *_meetingRoomList;
@end

@implementation EngineerMeetingRoomListViewCtrl
@synthesize _meetingRoomList;

- (void) initData {
    if (_meetingRoomList) {
        [_meetingRoomList removeAllObjects];
    } else {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room2", @"roomname",
                                     nil];
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room3", @"roomname",
                                     nil];
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room4", @"roomname",
                                     nil];
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room5", @"roomname",
                                     nil];
        NSMutableDictionary *dic61 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room61", @"roomname",
                                     nil];
        NSMutableDictionary *dic62 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room62", @"roomname",
                                     nil];
        NSMutableDictionary *dic63 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room63", @"roomname",
                                     nil];
        NSMutableDictionary *dic64 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room64", @"roomname",
                                     nil];
        NSMutableDictionary *dic65 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room65", @"roomname",
                                     nil];
        NSMutableDictionary *dic66 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room66", @"roomname",
                                     nil];
        NSMutableDictionary *dic67 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room67", @"roomname",
                                     nil];
        NSMutableDictionary *dic68 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room68", @"roomname",
                                     nil];
        NSMutableDictionary *dic69 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room69", @"roomname",
                                     nil];
        NSMutableDictionary *dic611 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room611", @"roomname",
                                     nil];
        NSMutableDictionary *dic612 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"meeting_room612", @"roomname",
                                     nil];
        self._meetingRoomList = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5,dic61, dic62, dic63, dic64, dic65, dic66, dic67,dic68, dic69, dic611, dic612, nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    ///
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-130)];
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    
    int top = 10;
    int leftRight = 60;
    int space = 2;
    int cellWidth = (SCREEN_WIDTH - 2*leftRight - 2*space) / 3;
    int cellHeight = 176;
    
    int rowNumber = [_meetingRoomList count] / 3 + 1;
    int scrollHeight = rowNumber * cellHeight + (rowNumber-1)*space + top;
    scroolView.contentSize = CGSizeMake(SCREEN_WIDTH - 2*leftRight, scrollHeight);
    
    
    int index = 0;
    for (id dic in _meetingRoomList) {
        int row = index/3;
        int col = index%3;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        NSString *roomImageName = [dic objectForKey:@"image"];
        if (roomImageName == nil) {
            roomImageName = @"engineer_meetingroom_default_n.png";
        }
        UIImage *roomImage = [UIImage imageNamed:roomImageName];
        
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
        NSString *meetingRoomName = [dic objectForKey:@"roomname"];
        if (meetingRoomName == nil) {
            meetingRoomName = @"请点击命名";
        }
        titleL.text = meetingRoomName;
    }
}
-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    long index = gestureRecognizer.view.tag;
    NSMutableDictionary *dic = [_meetingRoomList objectAtIndex:index];
    
    EngineerSysSelectViewCtrl *ctrl = [[EngineerSysSelectViewCtrl alloc] init];
    
    ctrl._meetingRoomDic = dic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
}
- (void) cameraAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
