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
#import "AppDelegate.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"
#endif

@interface EngineerMeetingRoomListViewCtrl () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, JCActionViewDelegate>{
    NSMutableArray *lableArray;
    NSMutableArray *roomImageArray;
    
    int selectedRoomIndex;
    
    UIImagePickerController *_imagePicker;
}
@property (nonatomic, strong) NSMutableArray *roomList;

@end

@implementation EngineerMeetingRoomListViewCtrl
@synthesize roomList;

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
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    
    int top = 80;
    int leftRight = 30;
    int space = 15;
    
    int cellWidth = 312;
    int cellHeight = 186;
    int index = 0;
    for (id dic in roomList) {
        int row = index/3;
        int col = index%3;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIImage *roomImageBG = [UIImage imageNamed:@"image_backgroud.png"];
        UIImageView *roomeImageBGView = [[UIImageView alloc] initWithImage:roomImageBG];
        roomeImageBGView.frame = CGRectMake(startX-21, startY-21, 354, 228);
        [scroolView addSubview:roomeImageBGView];
        
        
        UIImage *roomImage = [dic objectForKey:@"image"];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.userInteractionEnabled=YES;
        roomeImageView.contentMode = UIViewContentModeScaleAspectFill;
        roomeImageView.clipsToBounds=YES;
        roomeImageView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        
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
        titleL.text = [dic objectForKey:@"roomname"];
        
        [lableArray addObject:titleL];
        
        index++;
    }
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    
#ifdef OPEN_REG_LIB_DEF
    NSString* _regulus_gateway_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"gateway_id"];
    NSString* _regulus_user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    if(_regulus_gateway_id && _regulus_user_id)
    {
        //[[RegulusSDK sharedRegulusSDK] Logout:_regulus_user_id
                                        //gw_id:_regulus_gateway_id completion:nil];
    }
#endif
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
    
    EngineerSysSelectViewCtrl *lctrl = [[EngineerSysSelectViewCtrl alloc] init];
    lctrl._meetingRoomDic = dic;
    
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) cameraAction:(id)sender {
    UIButton *cameraBtn = (UIButton*) sender;
    selectedRoomIndex = (int) cameraBtn.tag;
    if(_imagePicker == nil)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        
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
            
            UIImage *img = [self imageWithImage:image scaledToSize:CGSizeMake(800, 800)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                UIImageView *roomImageView = [roomImageArray objectAtIndex:selectedRoomIndex];
                roomImageView.image = img;
                ///////图从这儿穿出去
                
                NSMutableDictionary *roomDic = [self.roomList objectAtIndex:selectedRoomIndex];
                [roomDic setObject:img forKey:@"image"];
                
            });
        });
    }
    
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
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

