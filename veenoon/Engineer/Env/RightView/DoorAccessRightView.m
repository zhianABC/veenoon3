//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "DoorAccessRightView.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "ComSettingView.h"

@interface DoorAccessRightView () <CustomPickerViewDelegate> {
    
    ComSettingView *_com;
    
    UILabel *_telephoneNumberL;
    UIButton *_backWorkdBtn;
}
@end

@implementation DoorAccessRightView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(0, 89, 118);
        
        int labelHeight = 80;
        int leftSpace = 40;
        
        UIImageView *textBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remote_video_filled_s.png"]];
        textBGView.userInteractionEnabled=YES;
        [self addSubview:textBGView];
        textBGView.frame = CGRectMake(leftSpace, labelHeight+100, 220, 33);
        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+5, labelHeight+60, 210, 33)];
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.userInteractionEnabled=YES;
        [self addSubview:passwordLabel];
        passwordLabel.font = [UIFont boldSystemFontOfSize:16];
        passwordLabel.textColor  = [UIColor whiteColor];
        passwordLabel.text = @"确认密码";
        
        _telephoneNumberL = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace+5, labelHeight+100, 210, 33)];
        _telephoneNumberL.backgroundColor = [UIColor clearColor];
        _telephoneNumberL.userInteractionEnabled=YES;
        [self addSubview:_telephoneNumberL];
        _telephoneNumberL.font = [UIFont boldSystemFontOfSize:16];
        _telephoneNumberL.textColor  = [UIColor whiteColor];
        _telephoneNumberL.text = @"";
        
        _backWorkdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _backWorkdBtn.frame = CGRectMake(leftSpace + 220 - 32, labelHeight+100, 32, 32);
        [_backWorkdBtn setImage:[UIImage imageNamed:@"remote_video_back_n.png"] forState:UIControlStateNormal];
        [_backWorkdBtn setImage:[UIImage imageNamed:@"remote_video_back_s.png"] forState:UIControlStateHighlighted];
        [_backWorkdBtn addTarget:self action:@selector(backWordAction:) forControlEvents:UIControlEventTouchUpInside];
        _backWorkdBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_backWorkdBtn];
        
        UIButton *phone1Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone1Btn.frame = CGRectMake(leftSpace, labelHeight+70+75, 70, 70);
        phone1Btn.layer.cornerRadius = 5;
        phone1Btn.layer.borderWidth = 2;
        phone1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone1Btn.clipsToBounds = YES;
        [phone1Btn setTitle:@"1" forState:UIControlStateNormal];
        [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone1Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone1Btn];
        [phone1Btn addTarget:self
                      action:@selector(phone1Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone2Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone2Btn.frame = CGRectMake(leftSpace+75, labelHeight+70+75, 70, 70);
        phone2Btn.layer.cornerRadius = 5;
        phone2Btn.layer.borderWidth = 2;
        phone2Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone2Btn.clipsToBounds = YES;
        [phone2Btn setTitle:@"2" forState:UIControlStateNormal];
        [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone2Btn];
        [phone2Btn addTarget:self
                      action:@selector(phone2Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone3Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone3Btn.frame = CGRectMake(leftSpace+75+75, labelHeight+70+75, 70, 70);
        phone3Btn.layer.cornerRadius = 5;
        phone3Btn.layer.borderWidth = 2;
        phone3Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone3Btn.clipsToBounds = YES;
        [phone3Btn setTitle:@"3" forState:UIControlStateNormal];
        [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone3Btn];
        [phone3Btn addTarget:self
                      action:@selector(phone3Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone4Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone4Btn.frame = CGRectMake(leftSpace, labelHeight+70+75+75, 70, 70);
        phone4Btn.layer.cornerRadius = 5;
        phone4Btn.layer.borderWidth = 2;
        phone4Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone4Btn.clipsToBounds = YES;
        [phone4Btn setTitle:@"4" forState:UIControlStateNormal];
        [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone4Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone4Btn];
        [phone4Btn addTarget:self
                      action:@selector(phone4Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone5Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone5Btn.frame = CGRectMake(leftSpace+75, labelHeight+70+75+75, 70, 70);
        phone5Btn.layer.cornerRadius = 5;
        phone5Btn.layer.borderWidth = 2;
        phone5Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone5Btn.clipsToBounds = YES;
        [phone5Btn setTitle:@"5" forState:UIControlStateNormal];
        [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone5Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone5Btn];
        [phone5Btn addTarget:self
                      action:@selector(phone5Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone6Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone6Btn.frame = CGRectMake(leftSpace+75+75, labelHeight+70+75+75, 70, 70);
        phone6Btn.layer.cornerRadius = 5;
        phone6Btn.layer.borderWidth = 2;
        phone6Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone6Btn.clipsToBounds = YES;
        [phone6Btn setTitle:@"6" forState:UIControlStateNormal];
        [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone6Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone6Btn];
        [phone6Btn addTarget:self
                      action:@selector(phone6Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone7Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone7Btn.frame = CGRectMake(leftSpace, labelHeight+70+75+75+75, 70, 70);
        phone7Btn.layer.cornerRadius = 5;
        phone7Btn.layer.borderWidth = 2;
        phone7Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone7Btn.clipsToBounds = YES;
        [phone7Btn setTitle:@"7" forState:UIControlStateNormal];
        [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone7Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone7Btn];
        [phone7Btn addTarget:self
                      action:@selector(phone7Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone8Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone8Btn.frame = CGRectMake(leftSpace+75, labelHeight+70+75+75+75, 70, 70);
        phone8Btn.layer.cornerRadius = 5;
        phone8Btn.layer.borderWidth = 2;
        phone8Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone8Btn.clipsToBounds = YES;
        [phone8Btn setTitle:@"8" forState:UIControlStateNormal];
        [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone8Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone8Btn];
        [phone8Btn addTarget:self
                      action:@selector(phone8Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone9Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone9Btn.frame = CGRectMake(leftSpace+75+75, labelHeight+70+75+75+75, 70, 70);
        phone9Btn.layer.cornerRadius = 5;
        phone9Btn.layer.borderWidth = 2;
        phone9Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone9Btn.clipsToBounds = YES;
        [phone9Btn setTitle:@"9" forState:UIControlStateNormal];
        [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone9Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone9Btn];
        [phone9Btn addTarget:self
                      action:@selector(phone9Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phonedotBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phonedotBtn.frame = CGRectMake(leftSpace, labelHeight+70+75+75+75+75, 70, 70);
        phonedotBtn.layer.cornerRadius = 5;
        phonedotBtn.layer.borderWidth = 2;
        phonedotBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        phonedotBtn.clipsToBounds = YES;
        [phonedotBtn setTitle:@"." forState:UIControlStateNormal];
        [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phonedotBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phonedotBtn];
        [phonedotBtn addTarget:self
                        action:@selector(phonedotAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phone0Btn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phone0Btn.frame = CGRectMake(leftSpace+75, labelHeight+70+75+75+75+75, 70, 70);
        phone0Btn.layer.cornerRadius = 5;
        phone0Btn.layer.borderWidth = 2;
        phone0Btn.layer.borderColor = [UIColor clearColor].CGColor;;
        phone0Btn.clipsToBounds = YES;
        [phone0Btn setTitle:@"0" forState:UIControlStateNormal];
        [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phone0Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phone0Btn];
        [phone0Btn addTarget:self
                      action:@selector(phone0Action:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *phoneStarBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:RGB(242, 148, 20)];
        phoneStarBtn.frame = CGRectMake(leftSpace+75+75, labelHeight+70+75+75+75+75, 70, 70);
        phoneStarBtn.layer.cornerRadius = 5;
        phoneStarBtn.layer.borderWidth = 2;
        phoneStarBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        phoneStarBtn.clipsToBounds = YES;
        [phoneStarBtn setTitle:@"确认" forState:UIControlStateNormal];
        [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        phoneStarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:phoneStarBtn];
        [phoneStarBtn addTarget:self
                         action:@selector(phoneStarAction:)
               forControlEvents:UIControlEventTouchUpInside];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
    }
    
    return self;
}

- (void) phoneStarAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"*"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone0Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"0"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phonedotAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"."];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone9Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"9"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone8Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"8"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone7Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"7"];
    
    _telephoneNumberL.text = newTextStr;
}

- (void) phone6Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"6"];
    
    _telephoneNumberL.text = newTextStr;
}

- (void) phone5Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"5"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone4Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"4"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone3Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"3"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone2Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"2"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone1Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"1"];
    
    _telephoneNumberL.text = newTextStr;
}

- (void) backWordAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSLog(@"sssssss");
    if (textStr && [textStr length] > 0) {
        NSString *backStr = [textStr substringToIndex:[textStr length]-1];
        _telephoneNumberL.text = backStr;
    }
}

- (void) switchComSetting{
    
    if([_com superview])
        return;
    
    CGRect rc = _com.frame;
    rc.origin.y = 0-rc.size.height;
    
    _com.frame = rc;
    [self addSubview:_com];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _com.frame = self.bounds;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

@end





