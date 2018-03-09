//
//  EnginnerHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EnginnerHomeViewController.h"
#import "UIButton+Color.h"
#import "EngineerMeetingRoomListViewCtrl.h"
#import "ReaderCodeViewController.h"

@interface EnginnerHomeViewController () <ReaderCodeDelegate> {
    UITextField *_userNameField;
    UITextField *_userPwdField;
    
    UIButton *_flashBtn;
    UIImageView *_scanLineImageView;
    BOOL _is_Animation;
    UIImageView* shoot_image;
    
    UIView *_inputPannel;
}
@property (nonatomic, strong) ReaderCodeViewController *reader_;
@property (nonatomic, strong) NSString *barcode_;

@end

@implementation EnginnerHomeViewController
@synthesize reader_;
@synthesize barcode_;

- (void)viewDidLoad {
    [super viewDidLoad];
    int leftRight = 250;
    int width = SCREEN_WIDTH - leftRight*2;
    int height = width * 2 / 3;
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(leftRight, 150, width, height)];
    [self.view addSubview:_inputPannel];
    _inputPannel.backgroundColor = RGB(0, 89, 118);
    _inputPannel.userInteractionEnabled=YES;
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *roomImage = [UIImage imageNamed:@"engineer_login_icon.png"];
    UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
    [_inputPannel addSubview:roomeImageView];
    roomeImageView.frame = CGRectMake(width/2-69, 80, 138, 109);
    roomeImageView.userInteractionEnabled=YES;
    
    UIView *_inputPannel2 = [[UIView alloc] initWithFrame:CGRectMake(leftRight, 100+height, width, 150)];
    [self.view addSubview:_inputPannel2];
    _inputPannel2.backgroundColor = [UIColor whiteColor];
    _inputPannel2.userInteractionEnabled=YES;
    
    UIButton *login = [UIButton buttonWithColor:nil selColor:[UIColor blackColor]];
    login.frame = CGRectMake(_inputPannel2.frame.size.width/2 - 124,_inputPannel2.frame.size.height/2-25,248, 31);
    login.layer.cornerRadius = 5;
    login.layer.borderWidth = 2;
    login.layer.borderColor = [UIColor blackColor].CGColor;
    login.clipsToBounds = YES;
    [_inputPannel2 addSubview:login];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [login addTarget:self
              action:@selector(loginAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *userImage = [UIImage imageNamed:@"engineer_login_input_n.png"];
    UIImageView *userImageView = [[UIImageView alloc] initWithImage:userImage];
    [_inputPannel addSubview:userImageView];
    userImageView.frame = CGRectMake(_inputPannel.frame.size.width/2 - 124, _inputPannel.frame.size.height-150, 248, 31);
    userImageView.userInteractionEnabled=YES;
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 248, 31)];
    _userNameField.delegate = self;
    _userNameField.returnKeyType = UIReturnKeyDone;
    _userNameField.placeholder = @"";
    _userNameField.backgroundColor = [UIColor clearColor];
    _userNameField.textColor = [UIColor whiteColor];
    _userNameField.borderStyle = UITextBorderStyleNone;
    [userImageView addSubview:_userNameField];
    
    //密码输入框 pending....
    UIImage *userImage2 = [UIImage imageNamed:@"engineer_login_input_n.png"];
    UIImageView *userImageView2 = [[UIImageView alloc] initWithImage:userImage2];
    [_inputPannel addSubview:userImageView2];
    userImageView2.frame = CGRectMake(_inputPannel.frame.size.width/2 - 124, _inputPannel.frame.size.height-110, 248, 31);
    userImageView2.userInteractionEnabled=YES;
    
    _userPwdField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 248, 31)];
    _userPwdField.delegate = self;
    _userPwdField.returnKeyType = UIReturnKeyDone;
    _userPwdField.backgroundColor = [UIColor clearColor];
    _userPwdField.textColor = [UIColor whiteColor];
    _userPwdField.borderStyle = UITextBorderStyleNone;
    _userPwdField.secureTextEntry = YES;
    [userImageView2 addSubview:_userPwdField];
}

- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _userPwdField) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 170);
    }
    if (textField == _userNameField) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 130);
    }
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userPwdField) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 70);
    }
    if (textField == _userNameField) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 20);
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(textField == _userNameField) {
        [_userPwdField becomeFirstResponder];
    }
    
    return YES;
}

-(void) loginAction:(id) sender {
    
    
    EngineerMeetingRoomListViewCtrl *ctrl = [[EngineerMeetingRoomListViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];

    /*
    [self scanQRCode:nil];
   */
   
}

- (void) scanQRCode:(id)sender{
    
    if (1)//[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
    {
        if(reader_ && [reader_.view superview])
            return;
        
        self.reader_ = [[ReaderCodeViewController alloc] init];
        reader_.delegate = self;
        
        reader_.postion = 1;//front
        
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
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                       CGRectGetMaxY(maskTop.frame),
                                                       2, 30)];
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-30,
                                                       CGRectGetMaxY(maskTop.frame),
                                                       30, 2)];
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-2,
                                                       CGRectGetMaxY(maskTop.frame),
                                                       2, 30)];
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                       CGRectGetMinY(maskBottom.frame)-2,
                                                       30, 2)];
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maskLeft.frame),
                                                       CGRectGetMinY(maskBottom.frame)-30,
                                                       2, 30)];
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-30,
                                                       CGRectGetMinY(maskBottom.frame)-2,
                                                       30, 2)];
        l1.backgroundColor = [UIColor greenColor];
        [maskView addSubview:l1];
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(maskRight.frame)-2,
                                                       CGRectGetMinY(maskBottom.frame)-30,
                                                       2, 30)];
        l1.backgroundColor = [UIColor greenColor];
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
        
        UILabel* alertMsgL1 = [[UILabel alloc]
                              initWithFrame:CGRectMake(CGRectGetMinX(shoot_image.frame),
                                                       CGRectGetMaxY(alertMsgL.frame)+10,
                                                       CGRectGetWidth(alertMsgL.frame),
                                                       20)];
        alertMsgL1.backgroundColor = [UIColor clearColor];
        [maskView addSubview:alertMsgL1];
        alertMsgL1.font = [UIFont systemFontOfSize:12];
        alertMsgL1.textColor  = [UIColor greenColor];
        alertMsgL1.text = @"我的二维码";
        alertMsgL1.textAlignment = NSTextAlignmentCenter;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[cancelBtn setTitle:[[UserDefaultsKV sharedUserDefaultsKV] lanWithKey:@"Cancel"] forState:UIControlStateNormal];
        //cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [cancelBtn setImage:[UIImage imageNamed:@"iconfont-quxiao.png"] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(50, SCREEN_HEIGHT-50, SCREEN_WIDTH-100, 40);
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.clipsToBounds = YES;
        [maskView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelZbarController) forControlEvents:UIControlEventTouchUpInside];
        
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setImage:[UIImage imageNamed:@"camera_flip.png"] forState:UIControlStateNormal];
        _flashBtn.frame = CGRectMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-50, 40, 40);
        [maskView addSubview:_flashBtn];
        [_flashBtn addTarget:self action:@selector(switchFlashMode:) forControlEvents:UIControlEventTouchUpInside];
        
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
    else
    {
        self.barcode_ = @"DCN48Ogd7R5kHI8sv8NDGQ";//@"xopaEl79jrIKGpz5Bd9TGQ";
        [self testIsEncCode:barcode_];
        
    }
  
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


- (void)cancelZbarController {
    
    _is_Animation = NO;
    
    [self.reader_ dismissViewControllerAnimated:YES completion:^{
        
        self.reader_ = nil;
    }];
    
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
            self.barcode_ = [tma objectAtIndex:0];
            
            [self testIsEncCode:barcode_];
        }
        
    }
    
    [self.reader_ dismissViewControllerAnimated:NO completion:^{
        self.reader_ = nil;
    }];
}

- (void) testIsEncCode:(NSString*)barcode{
    
    if([barcode length])
    {
        EngineerMeetingRoomListViewCtrl *ctrl = [[EngineerMeetingRoomListViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}


@end
