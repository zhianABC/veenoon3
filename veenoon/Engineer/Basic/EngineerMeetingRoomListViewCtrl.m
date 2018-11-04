//
//  UserHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerMeetingRoomListViewCtrl.h"
#import "EngineerSysSelectViewCtrl.h"
#import "JCActionView.h"
#import "DataSync.h"
#import "AppDelegate.h"
#import "DataBase.h"
#import "ReaderCodeViewController.h"
#import "Utilities.h"
#import "SBJson4.h"
#import "MeetingRoom.h"

#import "KVNProgress.h"
#import "DataCenter.h"
#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"
#endif

#import "UIImageView+WebCache.h"
#import "UserDefaultsKV.h"

#import "UIButton+Color.h"

#import "KVNProgress.h"
#import "EngineerLocalPrjsListViewCtrl.h"


@interface EngineerMeetingRoomListViewCtrl () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, JCActionViewDelegate, ReaderCodeDelegate>{
    
    NSMutableArray *lableArray;
    NSMutableArray *roomImageArray;
    
    int selectedRoomIndex;
    
    UIImagePickerController *_imagePicker;
    
    UIScrollView *scroolView;
    
    UIButton *_flashBtn;
    UIImageView *_scanLineImageView;
    BOOL _is_Animation;
    UIImageView* shoot_image;
    
    WebClient *_client;
    
    int _curEditIndex;
    
    UIButton *editBtn;
    
    UIScrollView *_offlineScroll;
    
    UIButton *_tab1;
    UIButton *_tab2;
}
@property (nonatomic, strong) NSMutableArray *roomList;

@property (nonatomic, strong) NSString *_regulus_user_id;
@property (nonatomic, strong) NSString *_regulus_gateway_id;
@property (nonatomic, strong) MeetingRoom *_currentRoom;

@property (nonatomic, strong) ReaderCodeViewController *reader_;
@property (nonatomic, strong) NSString *qrcode;

@property (nonatomic, strong) NSMutableArray *_offlineProjs;

@end

@implementation EngineerMeetingRoomListViewCtrl
@synthesize roomList;
@synthesize _currentRoom;

@synthesize _regulus_user_id;
@synthesize _regulus_gateway_id;
@synthesize reader_;
@synthesize qrcode;

@synthesize _offlineProjs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    lableArray = [[NSMutableArray alloc] init];
    roomImageArray = [[NSMutableArray alloc] init];
    selectedRoomIndex = -1;
    
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    int topSpace = StatusRect.size.height+60;

    int tabWidth = 200;
    int xx = SCREEN_WIDTH/2 - tabWidth/2;
    _tab1 = [[UIButton alloc] initWithFrame:CGRectMake(xx,
                                                      topSpace,
                                                      tabWidth,
                                                      44)];
    _tab1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_tab1 setTitle:@"在线配置" forState:UIControlStateNormal];
    [self.view addSubview:_tab1];
    [_tab1 setTitleColor:[UIColor whiteColor]
                forState:UIControlStateNormal];

    

    scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140,
                                                                SCREEN_WIDTH,
                                                                SCREEN_HEIGHT-150)];
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    
    
    _offlineScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT-150)];
    _offlineScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_offlineScroll];
    _offlineScroll.hidden = YES;
    
    
    self.roomList = [[DataBase sharedDatabaseInstance] getMeetingRooms];
    
    if([roomList count] == 0)
    {
        [self scanRegulusDevice];
    }
    
    [self showRoomList];
    
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(SCREEN_WIDTH-20-160, StatusRect.size.height+20,160, 50);
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"清空房间" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [editBtn addTarget:self action:@selector(clearAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    _tab2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-20-160, 0,160, 50)];
    _tab2.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_tab2 setTitle:@"离线配置" forState:UIControlStateNormal];
    [bottomBar addSubview:_tab2];
    [_tab2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _tab2.tag = 2;
    [_tab2 addTarget:self
              action:@selector(buttonAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, SCREEN_HEIGHT - 48, 42, 42);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backBtn addTarget:self
                action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];

    //[self loadLocalProjects];
    
    [[DataSync sharedDataSync] logoutCurrentRegulus];
}




- (void) clearAction:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"您确定要清空房间列表吗? "
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *takeAction = [UIAlertAction
                                 actionWithTitle:@"确定"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                                     [[DataBase sharedDatabaseInstance] deleteMeetingRoom];
                                     
                                     self.roomList = [[DataBase sharedDatabaseInstance] getMeetingRooms];
                                     
                                     [self showRoomList];
                                 }];
    [alert addAction:takeAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    
    [self presentViewController:alert animated:YES
                     completion:nil];
    
    
}


- (void) buttonAction:(UIButton*)sender{

    EngineerLocalPrjsListViewCtrl *offline = [[EngineerLocalPrjsListViewCtrl alloc] init];
    [self.navigationController pushViewController:offline animated:YES];

}

- (void) backupAction:(id)sender{
    
    [[DataSync sharedDataSync] backupLocalDBToServer];
}

- (void) dataSyncAction:(id)sender{
    
    [[DataSync sharedDataSync] syncDataFromServerToLocalDB];
}

- (void) scanRegulus:(id)sender{
    
    [self scanRegulusDevice];
}

- (void) scanRegulusDevice{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])//
    {
        if(reader_ && [reader_.view superview])
            return;
        
        self.reader_ = [[ReaderCodeViewController alloc] init];
        reader_.delegate = self;
        
        reader_.postion = 0;//front
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [reader_.view addSubview:maskView];
        
        
        shoot_image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 380, 380)];
        //shoot_image.image = [UIImage imageNamed:@"shoot_front.png"];
        [maskView addSubview:shoot_image];
        shoot_image.backgroundColor = [UIColor clearColor];
        
        shoot_image.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-50);
        
        
        UIImageView *maskTop = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             SCREEN_WIDTH, CGRectGetMinY(shoot_image.frame))];
        maskTop.backgroundColor = RGBA(0, 0, 0, 0.2);
        [maskView addSubview:maskTop];
        UIImageView *maskBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(shoot_image.frame),
                                                                                SCREEN_WIDTH,SCREEN_HEIGHT-CGRectGetMaxY(shoot_image.frame))];
        maskBottom.backgroundColor = RGBA(0, 0, 0, 0.2);
        [maskView addSubview:maskBottom];
        
        UIImageView *maskLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(shoot_image.frame),
                                                                              CGRectGetMinX(shoot_image.frame),
                                                                              CGRectGetHeight(shoot_image.frame))];
        maskLeft.backgroundColor = RGBA(0, 0, 0, 0.2);
        [maskView addSubview:maskLeft];
        
        UIImageView *maskRight = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shoot_image.frame),
                                                                               CGRectGetMinY(shoot_image.frame),
                                                                               SCREEN_WIDTH - CGRectGetWidth(shoot_image.frame),
                                                                               CGRectGetHeight(shoot_image.frame))];
        maskRight.backgroundColor = RGBA(0, 0, 0, 0.2);
        [maskView addSubview:maskRight];
        
        UILabel *maskCover = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        maskCover.backgroundColor = THEME_COLOR;
        maskCover.alpha = 0.8;
        [maskView addSubview:maskCover];
        
        UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                                CGRectGetMaxY(maskTop.frame),
                                                                30, 2)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                       CGRectGetMaxY(maskTop.frame),
                                                       2, 30)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-30,
                                                       CGRectGetMaxY(maskTop.frame),
                                                       30, 2)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-2,
                                                       CGRectGetMaxY(maskTop.frame),
                                                       2, 30)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                       CGRectGetMinY(maskBottom.frame)-2,
                                                       30, 2)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                       CGRectGetMinY(maskBottom.frame)-30,
                                                       2, 30)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-30,
                                                       CGRectGetMinY(maskBottom.frame)-2,
                                                       30, 2)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-2,
                                                       CGRectGetMinY(maskBottom.frame)-30,
                                                       2, 30)];
        l1.backgroundColor = RGB(0, 150, 255);
        [maskView addSubview:l1];
        
        
        UILabel* alertMsgL = [[UILabel alloc]
                              initWithFrame:CGRectMake(CGRectGetMinX(shoot_image.frame),
                                                       CGRectGetMaxY(shoot_image.frame)+30,
                                                       CGRectGetWidth(shoot_image.frame),
                                                       20)];
        alertMsgL.backgroundColor = [UIColor clearColor];
        [maskView addSubview:alertMsgL];
        alertMsgL.font = [UIFont systemFontOfSize:12];
        alertMsgL.textColor  = [UIColor whiteColor];
        alertMsgL.text = @"将二维码放入框内，即可自动扫描";
        alertMsgL.textAlignment = NSTextAlignmentCenter;
        
        UILabel* titleL = [[UILabel alloc]
                               initWithFrame:CGRectMake(CGRectGetMinX(shoot_image.frame),
                                                        CGRectGetMinY(shoot_image.frame)-40,
                                                        CGRectGetWidth(alertMsgL.frame),
                                                        20)];
        titleL.backgroundColor = [UIColor clearColor];
        [maskView addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"扫一扫";
        titleL.textAlignment = NSTextAlignmentCenter;
        
        UILabel* alertMsgL1 = [[UILabel alloc]
                               initWithFrame:CGRectMake(CGRectGetMinX(shoot_image.frame),
                                                        CGRectGetMaxY(alertMsgL.frame)+10,
                                                        CGRectGetWidth(alertMsgL.frame),
                                                        20)];
        alertMsgL1.backgroundColor = [UIColor clearColor];
        [maskView addSubview:alertMsgL1];
        alertMsgL1.font = [UIFont systemFontOfSize:12];
        alertMsgL1.textColor  = [UIColor greenColor];
        alertMsgL1.text = @"中控二维码";
        alertMsgL1.textAlignment = NSTextAlignmentCenter;
        
        
        UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        [maskView addSubview:bottomBar];
        bottomBar.backgroundColor = [UIColor grayColor];
        bottomBar.userInteractionEnabled = YES;
        bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(60, SCREEN_HEIGHT -45, 60, 40);
        [maskView addSubview:backBtn];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
        backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [backBtn addTarget:self
                    action:@selector(cancelCameraAndBack:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *roomList = [UIButton buttonWithType:UIButtonTypeCustom];
        roomList.frame = CGRectMake(SCREEN_WIDTH - 90,
                                    SCREEN_HEIGHT - 45 - 120,
                                    70, 70);
        [maskView addSubview:roomList];
        [roomList setImage:[UIImage imageNamed:@"qr_code_icon.png"]
                  forState:UIControlStateNormal];
        [roomList addTarget:self
                    action:@selector(cancelZbarController:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel* roomListName = [[UILabel alloc]
                               initWithFrame:CGRectMake(CGRectGetMinX(roomList.frame),
                                                        CGRectGetMaxY(roomList.frame),
                                                        CGRectGetWidth(roomList.frame),
                                                        20)];
        roomListName.backgroundColor = [UIColor clearColor];
        [maskView addSubview:roomListName];
        roomListName.font = [UIFont systemFontOfSize:12];
        roomListName.textColor  = [UIColor greenColor];
        roomListName.text = @"房间列表";
        roomListName.textAlignment = NSTextAlignmentCenter;
        
        // present and release the controller
        [self presentViewController:reader_ animated:YES completion:^{
            
        }];
        
        _is_Animation = YES;
        if(_scanLineImageView)
        {
            [_scanLineImageView removeFromSuperview];
            _scanLineImageView = nil;
        }
        [self loopDrawLine];
        
    }
}


- (void) showRoomList{
    
    [[scroolView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int top = 0;
    int leftRight = 75;
    int space = 15;
    
    int cellWidth = 278;
    int cellHeight = 156;
    int index = 0;
    
    NSMutableArray *cellData = [NSMutableArray array];
    [cellData addObjectsFromArray:roomList];
    [cellData addObject:@{@"p":@"1"}];
    
    
    [lableArray removeAllObjects];
    [roomImageArray removeAllObjects];
    
    for (MeetingRoom * room in cellData) {
        
        int row = index/3;
        int col = index%3;
        
        
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIImage *roomImageBG = [UIImage imageNamed:@"image_backgroud.png"];
        UIImageView *roomeImageBGView = [[UIImageView alloc] initWithImage:roomImageBG];
        roomeImageBGView.frame = CGRectMake(startX-21, startY-21, 278, 156);
//        [scroolView addSubview:roomeImageBGView];
        
        
        if(![room isKindOfClass:[MeetingRoom class]])
        {
            //plus +1
            UIImage *img = [UIImage imageNamed:@"room_add_pg.png"];
            UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:img];
            roomeImageView.userInteractionEnabled=YES;
            roomeImageView.contentMode = UIViewContentModeScaleAspectFill;
            roomeImageView.clipsToBounds=YES;
            roomeImageView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            [scroolView addSubview:roomeImageView];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = roomeImageView.frame;
            [scroolView addSubview:btn];
            [btn addTarget:self
                    action:@selector(scanRegulus:)
          forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            NSString *roomImgName = room.room_image;
            UIImage *img = nil;
            NSString *coverurl = nil;
            int roomid = room.local_room_id;
            if([roomImgName length] == 0)
            {
                int r = roomid%6;
                NSString *name = [NSString stringWithFormat:@"user_meeting_room_%d.png", r];
                img = [UIImage imageNamed:name];
            }
            else
            {
                NSRange range = [roomImgName rangeOfString:@"http"];
                if(range.location != NSNotFound)
                {
                    coverurl = roomImgName;
                }
                else
                {
                    NSString *path = [Utilities documentsPath:roomImgName];
                    img = [UIImage imageWithContentsOfFile:path];
                }
            }
            
            UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:img];
            roomeImageView.userInteractionEnabled=YES;
            roomeImageView.contentMode = UIViewContentModeScaleAspectFill;
            roomeImageView.clipsToBounds=YES;
            roomeImageView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            
            if(coverurl)
            {
                [roomeImageView setImageWithURL:[NSURL URLWithString:coverurl]];
            }
            
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, cellWidth, cellHeight);
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
            
            
            
            UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            cameraBtn.frame = CGRectMake(CGRectGetWidth(roomeImageView.frame)-40, CGRectGetHeight(roomeImageView.frame)-35, 40, 40);
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
            
            
            UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(roomeImageView.frame)-30, 190, 30)];
            titleL.backgroundColor = [UIColor clearColor];
            [roomeImageView addSubview:titleL];
            titleL.font = [UIFont boldSystemFontOfSize:16];
            titleL.textColor  = [UIColor whiteColor];
            titleL.text = room.room_name;
            
            [lableArray addObject:titleL];
        }
        
        
        index++;
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
        _curEditIndex = index;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入会议室名称" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"会议室名称";
        }];
        
        IMP_BLOCK_SELF(EngineerMeetingRoomListViewCtrl);
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
            NSString *nameTxt = envirnmentNameTextField.text;
            if (nameTxt && [nameTxt length] > 0) {
                
                
                [block_self updateRoomName:nameTxt];
                
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void) updateRoomName:(NSString*)nameTxt{
    
    MeetingRoom *room = [self.roomList objectAtIndex:_curEditIndex];
    UILabel *scenarioLabel = [lableArray objectAtIndex:_curEditIndex];
    
    scenarioLabel.text = nameTxt;
    room.room_name = nameTxt;
    
    [[DataBase sharedDatabaseInstance] saveMeetingRoom:room];
    
    [self saveRoomPic:nil room:room];
}

- (void) backAction:(id)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    
    long index = gestureRecognizer.view.tag;
    
    MeetingRoom *room = [roomList objectAtIndex:index];
    self._currentRoom = room;
    
    [self tryLoginRegulus];
   
}

- (void) tryLoginRegulus{

    self._regulus_gateway_id    = _currentRoom.regulus_id;
    self._regulus_user_id       = _currentRoom.regulus_user_id;

    
#if LOGIN_REGULUS
    [KVNProgress showWithStatus:@"登录中..."];
    
    if([_regulus_gateway_id length] && [_regulus_user_id length])
    {
        [self loginCtrlDevice];
    }
    else if([_regulus_gateway_id length])
    {
        [self regCtrlDevice];
    }
#endif
}



- (void) regCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerMeetingRoomListViewCtrl);
    
    
    [[RegulusSDK sharedRegulusSDK] RequestJoinGateWay:_regulus_gateway_id
                                           completion:^(BOOL result,
                                                        NSString *client_id, NSError *error) {
        if (result) {
            
            block_self._regulus_user_id = client_id;

            [[NSUserDefaults standardUserDefaults] setObject:_regulus_gateway_id forKey:@"gateway_id"];
            [[NSUserDefaults standardUserDefaults] setObject:client_id forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [block_self loginCtrlDevice];
        }
        else{
            [KVNProgress showErrorWithStatus:[error description]];
            
            [DataSync sharedDataSync]._currentReglusLogged = nil;
        }
    }];
    
#endif
    
}

- (void) loginCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerMeetingRoomListViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] Login:self._regulus_user_id
                                   gw_id:_regulus_gateway_id
                                password:@"111111"
                                   level:1 completion:^(BOOL result, NSInteger level, NSError *error) {
                                       if (result) {
                                           [block_self enterRoom];
                                       }
                                       else
                                       {
                                           [DataSync sharedDataSync]._currentReglusLogged = nil;
                                           [KVNProgress showErrorWithStatus:[error description]];
                                       }
                                   }];
    
#endif
    
}

- (void) enterRoom{
    
    
    if(_currentRoom)
    {
       
        [DataCenter defaultDataCenter]._isLocalPrj = NO;
        
        [DataCenter defaultDataCenter]._currentRoom = _currentRoom;
        
        _currentRoom.regulus_user_id = _regulus_user_id;
        [[DataBase sharedDatabaseInstance] saveMeetingRoom:_currentRoom];
        
        /*
        [[RegulusSDK sharedRegulusSDK] SetDate:[NSDate date]
                                    completion:nil];
         */
        
        [KVNProgress dismiss];
        
        [DataSync sharedDataSync]._currentReglusLogged = @{@"gw_id":_regulus_gateway_id,
                                                           @"user_id":_regulus_user_id
                                                           };
        
    
        EngineerSysSelectViewCtrl *lctrl = [[EngineerSysSelectViewCtrl alloc] init];
        [self.navigationController pushViewController:lctrl animated:YES];

    }
    
    
}

- (void) cameraAction:(id)sender {
    UIButton *cameraBtn = (UIButton*) sender;
    selectedRoomIndex = (int) cameraBtn.tag;
    if(_imagePicker == nil)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
       // _imagePicker.allowsEditing = YES;
        
    }
    
    [[UINavigationBar appearance] setTintColor:THEME_COLOR];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        JCActionView *jcAction = [[JCActionView alloc] initWithTitles:@[@"直接拍照", @"从相册中选取"]
                                                                frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        jcAction.delegate_ = self;
        jcAction.tag = 2017;
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.window addSubview:jcAction];
        [jcAction animatedShow];
        
    }
    else
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES
                         completion:^{
                             
                         }];
    }
    
}

- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView{
    
    if(index == 0)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES
                         completion:^{
                         }];
    }
    else if(index == 1)
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES
                         completion:^{
                             
                         }];
    }
    
}


/**** Image Picker Delegates ******/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(600, 600)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                UIImageView *roomImageView = [roomImageArray objectAtIndex:selectedRoomIndex];
                roomImageView.image = img;
                ///////图从这儿穿出去
                
                [self cacheCurrentRoomImage:img];
                
            });
        });
    }
    
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}


- (void) cacheCurrentRoomImage:(UIImage *)img{
    
    MeetingRoom* room = [self.roomList objectAtIndex:selectedRoomIndex];
    
    int time = [[NSDate date] timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"%d_%d.jpg", time, rand()%10];
    
    NSString *path = [Utilities documentsPath:name];
    
    NSData *data = UIImageJPEGRepresentation(img, 1);
    
    [data writeToFile:path atomically:YES];

    room.room_image = name;
    [[DataBase sharedDatabaseInstance] updateMeetingRoomPic:room];
    
#ifdef   REALTIME_NETWORK_MODEL
    [self saveRoomPic:img room:room];
#endif
}

- (void) saveRoomPic:(UIImage *)image room:(MeetingRoom*)room{
    
    int room_id = room.server_room_id;
    int user_id = room.user_id;
    if( room_id && user_id)
    {

        if(_client == nil)
        {
            _client = [[WebClient alloc] initWithDelegate:self];
        }
        
        _client._method = @"/updateroom";
        _client._httpMethod = @"POST";
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        _client._requestParam = param;
        
        
        [param setObject:[NSString stringWithFormat:@"%d", user_id] forKey:@"userID"];
        [param setObject:[NSString stringWithFormat:@"%d", room_id] forKey:@"roomID"];
        [param setObject:room.regulus_id forKey:@"regulusID"];
        
        if(room.regulus_password)
            [param setObject:room.regulus_password forKey:@"regulusPassword"];
        
        if(room.room_name)
            [param setObject:room.room_name forKey:@"roomName"];
        
        
        IMP_BLOCK_SELF(EngineerMeetingRoomListViewCtrl);
        
        if(image)
        {
            [param setObject:@"file" forKey:@"filename"];
            [param setObject:image forKey:@"photo"];
            
            [KVNProgress show];
            
            [_client requestWithSusessBlockWithImage:^(id lParam, id rParam) {
                
                NSString *response = lParam;
                NSLog(@"%@", response);
                
                [KVNProgress dismiss];
                
                SBJson4ValueBlock block = ^(id v, BOOL *stop) {
                    
                    
                    if([v isKindOfClass:[NSDictionary class]])
                    {
                        int code = [[v objectForKey:@"code"] intValue];
                        
                        if(code == 200)
                        {
                            if([v objectForKey:@"data"])
                            {
                                [block_self updateRoomPic:[v objectForKey:@"data"]];
                            }
                        }
                        return;
                    }
                    
                    
                };
                
                SBJson4ErrorBlock eh = ^(NSError* err) {
                    
                    
                    
                    NSLog(@"OOPS: %@", err);
                };
                
                id parser = [SBJson4Parser multiRootParserWithBlock:block
                                                       errorHandler:eh];
                
                id data = [response dataUsingEncoding:NSUTF8StringEncoding];
                [parser parse:data];
                
                
            } FailBlock:^(id lParam, id rParam) {
                
                NSString *response = lParam;
                NSLog(@"%@", response);
                
                [KVNProgress dismiss];
            }];
        }
        else
        {
            [KVNProgress show];
            
            [_client requestWithSusessBlock:^(id lParam, id rParam) {
                
                NSString *response = lParam;
                NSLog(@"%@", response);
                
                [KVNProgress dismiss];
                
                SBJson4ValueBlock block = ^(id v, BOOL *stop) {
                    
                    
                    if([v isKindOfClass:[NSDictionary class]])
                    {
                        int code = [[v objectForKey:@"code"] intValue];
                        
                        if(code == 200)
                        {
                           
                        }
                        return;
                    }
                    
                    
                };
                
                SBJson4ErrorBlock eh = ^(NSError* err) {
                    
                    
                    
                    NSLog(@"OOPS: %@", err);
                };
                
                id parser = [SBJson4Parser multiRootParserWithBlock:block
                                                       errorHandler:eh];
                
                id data = [response dataUsingEncoding:NSUTF8StringEncoding];
                [parser parse:data];
                
                
            } FailBlock:^(id lParam, id rParam) {
                
                NSString *response = lParam;
                NSLog(@"%@", response);
                
                [KVNProgress dismiss];
            }];
        }
    
    }
    
}

- (void) updateRoomPic:(NSDictionary*)data{
    
    MeetingRoom* room = [self.roomList objectAtIndex:selectedRoomIndex];
    NSString *roomImage = [data objectForKey:@"room_image"];
    room.room_image = [NSString stringWithFormat:@"%@/%@",WEB_API_URL,roomImage];
    
    [[DataBase sharedDatabaseInstance] updateMeetingRoomPic:room];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    if(image==nil)return nil;
    
    float width = image.size.width;
    float height = image.size.height;
    float x, x1, y1;
    
    if(width > height)
    {
        x1 = width / newSize.height;
        y1 = height / newSize.width;
    }
    else
    {
        x1 = width / newSize.width;
        y1 = height / newSize.height;
    }
    
    x = (x1 > y1) ? x1:y1;
    
    if(x < 1.0)return image;
    
    if(fabs(x-1.0) < 0.0001)return image;
    
    CGSize s = CGSizeMake(width/x,height/x);
    
    
    UIGraphicsBeginImageContext(s);
    [image drawInRect:CGRectMake(0,0,s.width,s.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark 扫描动画
-(void)loopDrawLine
{
    CGRect rect = shoot_image.frame;
    rect.origin.y += 40;
    rect.size.height = 3;
    
    if(_scanLineImageView == nil)
    {
        _scanLineImageView = [[UIImageView alloc] initWithFrame:rect];
        [_scanLineImageView setImage:[UIImage imageNamed:@"qrcode_scan_line.png"]];
        
    }
    
    [reader_.view addSubview:_scanLineImageView];
    _scanLineImageView.frame = rect;
    
    [UIView animateWithDuration:3.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         //修改fream的代码写在这里
                         _scanLineImageView.frame =CGRectMake(CGRectGetMinX(shoot_image.frame),
                                                              CGRectGetMaxY(shoot_image.frame)-40,
                                                              380, 3);
                         [_scanLineImageView setAnimationRepeatCount:0];
                         
                     }
                     completion:^(BOOL finished){
                         if (_is_Animation) {
                             [self loopDrawLine];
                         }
                     }];
    
    
    
}


- (void)cancelZbarController:(id)sender {
    
    _is_Animation = NO;
    
    [self.reader_ dismissViewControllerAnimated:YES completion:^{
        
        self.reader_ = nil;
    }];
    
}


- (void)cancelCameraAndBack:(id)sender {
    
    _is_Animation = NO;
    
    
    IMP_BLOCK_SELF(EngineerMeetingRoomListViewCtrl);
    [self.reader_ dismissViewControllerAnimated:NO completion:^{
        
        [block_self testNeedBack];
    }];
    
}

- (void) testNeedBack{
    
    if([roomList count] == 0)
        [self backAction:nil];
}

- (void) switchFlashMode:(id)sender{
    
    if(reader_.postion == 0)
    {
        [reader_ setDevicePosition:1];
    }
    else
    {
        [reader_ setDevicePosition:0];
    }
    
}


- (void) didReaderBarData:(NSString*)barString{
    
    _is_Animation = NO;
    
    //DC调查表号
    NSString *barcode_scan = barString;
    
    if([barcode_scan length]){
        
        NSArray *tma  = [barcode_scan componentsSeparatedByString:@";"];
        if([tma count])
        {
            self.qrcode = [tma objectAtIndex:0];
            
            [self testIsEncCode:qrcode];
        }
        
    }
    
    [self.reader_ dismissViewControllerAnimated:NO completion:^{
        self.reader_ = nil;
    }];
}

- (void) testIsEncCode:(NSString*)barcode{
    
    if([barcode length])
    {
        NSRange range = [barcode rangeOfString:@"RGS_"];
        NSRange range1 = [barcode rangeOfString:@"TESLARIA_"];
        if(range.location != NSNotFound
           || range1.location != NSNotFound)
        {
            [self testRegDevice:barcode];
        }
    }
}

- (void) testRegDevice:(NSString*)deviceid{
    
    IMP_BLOCK_SELF(EngineerMeetingRoomListViewCtrl);
    
    
    [[RegulusSDK sharedRegulusSDK] RequestJoinGateWay:deviceid
                                           completion:^(BOOL result,
                                                        NSString *client_id, NSError *error) {
                                               if (result) {
                                                   
                                                   [block_self addOneRoom:deviceid
                                                                andUserId:client_id];
                                               }
                                               else{
                                                   [KVNProgress showErrorWithStatus:[error description]];
                                                   
                                                   [DataSync sharedDataSync]._currentReglusLogged = nil;
                                               }
                                           }];
}

- (void) addOneRoom:(NSString*)regulusid andUserId:(NSString*)userid{
    
    if(userid && regulusid)
    {

        MeetingRoom *room = [[MeetingRoom alloc] init];
        room.room_name = @"房间";
        room.regulus_password = @"111111";
        room.regulus_user_id = userid;
        room.regulus_id = regulusid;
        
        User *u = [UserDefaultsKV getUser];
        if(u)
            room.user_id = [u._userId intValue];
        else
            room.user_id = 1;
        
        [[DataBase sharedDatabaseInstance] saveMeetingRoom:room];
        

        [self successAddRoom:room];
    
    }
}

- (void) successAddRoom:(MeetingRoom*)room{
    
    /*
     "regulus_id" = "RGS_EOC500_01";
     "regulus_password" = 111111;
     "regulus_user_id" = "B3763CEA-D181-4429-A01C-E4DAAA7F4EA6";
     "room_id" = 1;
     "room_image" = "";
     "room_name" = "\U623f\U95f4";
     "user_id" = 1;
     */
    
    //[[DataBase sharedDatabaseInstance] saveMeetingRoom:room];
    
    self.roomList = [[DataBase sharedDatabaseInstance] getMeetingRooms];
    [self showRoomList];
    
    [self cancelZbarController:nil];
}

@end

