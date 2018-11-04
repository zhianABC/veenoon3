//
//  UserHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserHomeViewController.h"
#import "UserMeetingRoomConfig.h"
#import "JCActionView.h"
#import "AppDelegate.h"
#import "DataBase.h"
#import "Utilities.h"
#import "MeetingRoom.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Color.h"
#import "DataSync.h"
#import "NetworkChecker.h"

@interface UserHomeViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, JCActionViewDelegate>{
    NSMutableArray *lableArray;
    NSMutableArray *roomImageArray;
    
    int selectedRoomIndex;
    
    UIImagePickerController *_imagePicker;
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
    
    self.roomList = [[DataBase sharedDatabaseInstance] getMeetingRooms];

    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, SCREEN_WIDTH-30, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"房间管理";
    
    self.view.backgroundColor = USER_GRAY_COLOR;
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    
    int top = 50;
    int leftRight = 75;
    int space = 15;
    
    int cellWidth = 278;
    int cellHeight = 156;
    int index = 0;
    for (MeetingRoom *room in roomList) {
        
        
        int row = index/3;
        int col = index%3;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIImage *roomImageBG = [UIImage imageNamed:@"image_backgroud.png"];
        UIImageView *roomeImageBGView = [[UIImageView alloc] initWithImage:roomImageBG];
        roomeImageBGView.frame = CGRectMake(startX-21, startY-21, 278, 156);
//        [scroolView addSubview:roomeImageBGView];
        
        
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
        roomeImageView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        roomeImageView.clipsToBounds = YES;
        
        if(coverurl)
            [roomeImageView setImageWithURL:[NSURL URLWithString:coverurl]];
        
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
        
        cameraBtn.frame = CGRectMake(CGRectGetWidth(roomeImageView.frame)-40, CGRectGetHeight(roomeImageView.frame)-30, 40, 30);
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
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(roomeImageView.frame)-30, 200, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [roomeImageView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = room.room_name;
        
        [lableArray addObject:titleL];
        
        index++;
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
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
    
    UIButton *btnSync = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSync.frame = CGRectMake(60, SCREEN_HEIGHT - 48, 42, 42);
    [btnSync setImage:[UIImage imageNamed:@"sync_data_n.png"] forState:UIControlStateNormal];
    [btnSync setImage:[UIImage imageNamed:@"sync_data_s.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:btnSync];
    btnSync.layer.cornerRadius = 5;
    btnSync.clipsToBounds = YES;
    [btnSync addTarget:self
                action:@selector(dataSyncAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [[DataSync sharedDataSync] logoutCurrentRegulus];
}

- (void) dataSyncAction:(id)sender{
    
    [[DataSync sharedDataSync] syncDataFromServerToLocalDB];
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
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
            NSString *scenarioName = envirnmentNameTextField.text;
            if (scenarioName && [scenarioName length] > 0) {
                MeetingRoom *mroom = [self.roomList objectAtIndex:index];
                UILabel *scenarioLabel = [lableArray objectAtIndex:index];
                
                mroom.room_name = scenarioName;
                scenarioLabel.text =scenarioName;
                
                [[DataBase sharedDatabaseInstance] saveMeetingRoom:mroom];
            }
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    long index = gestureRecognizer.view.tag;
    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable) {
        //没有网络的情况下
        
        [Utilities showMessage:@"请检查您的网络设置" ctrl:self];
        
        return;
    }
    
    MeetingRoom *dic = [roomList objectAtIndex:index];
    
    UserMeetingRoomConfig *lctrl = [[UserMeetingRoomConfig alloc] init];
    lctrl._currentRoom = dic;
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) cameraAction:(id)sender {
    UIButton *cameraBtn = (UIButton*) sender;
    selectedRoomIndex = (int) cameraBtn.tag;
        if(_imagePicker == nil)
        {
            _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = NO;
            
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
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(800, 800)];
            
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
    
    NSMutableDictionary *roomDic = [self.roomList objectAtIndex:selectedRoomIndex];
    
    int time = [[NSDate date] timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"%d_%d.jpg", time, rand()%10];
    
    NSString *path = [Utilities documentsPath:name];
    
    NSData *data = UIImageJPEGRepresentation(img, 1);
    
    [data writeToFile:path atomically:YES];
    
    [roomDic setObject:name forKey:@"image"];
    
    [[DataBase sharedDatabaseInstance] saveMeetingRoom:roomDic];
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

@end
