//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "PinJiePingRightView.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "ComSettingView.h"

@interface PinJiePingRightView () <CustomPickerViewDelegate> {
    
    ComSettingView *_com;
    
    UIButton *btnSelectSecs;
    CustomPickerView *_picker;
    
    UIButton *btnSelectSecs2;
    CustomPickerView *_picker2;
    
    UIImageView *icon;
    UIImageView *icon2;
    
    int selectedCustomer;
    
    UIButton *hangNumberBtn;
    UIButton *lieNumberBtn;
}
@end

@implementation PinJiePingRightView

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
        
        int startX = 50;
        int top = 160;
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX, top, 100, 40)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:14];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"显示分辨率";
        
        selectedCustomer = -1;
        
        UIColor *rectColor = RGB(0, 146, 174);
        
        btnSelectSecs = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        btnSelectSecs.layer.cornerRadius = 5;
        btnSelectSecs.clipsToBounds=YES;
        [btnSelectSecs setTitle:@"1+2" forState:UIControlStateNormal];
        btnSelectSecs.frame = CGRectMake(frame.size.width-160, top, 120, 40);
        [self addSubview:btnSelectSecs];
        btnSelectSecs.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [btnSelectSecs addTarget:self
                          action:@selector(chooseSecs:)
                forControlEvents:UIControlEventTouchUpInside];
        
        icon = [[UIImageView alloc]
                initWithFrame:CGRectMake(frame.size.width-60, top+15, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [self addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        
        int gap = 60;
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(startX, top+gap, 60, 40)];
        titleL2.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL2];
        titleL2.font = [UIFont boldSystemFontOfSize:14];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"调用场景";
        
        
        btnSelectSecs2 = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        btnSelectSecs2.layer.cornerRadius = 5;
        btnSelectSecs2.clipsToBounds=YES;
        [btnSelectSecs2 setTitle:@"1+2" forState:UIControlStateNormal];
        btnSelectSecs2.frame = CGRectMake(frame.size.width-160, top+gap, 120, 40);
        [self addSubview:btnSelectSecs2];
        btnSelectSecs2.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [btnSelectSecs2 addTarget:self
                          action:@selector(chooseSecs2:)
                forControlEvents:UIControlEventTouchUpInside];
        
        icon2 = [[UIImageView alloc]
                 initWithFrame:CGRectMake(frame.size.width-60, top+15+gap, 10, 10)];
        icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
        [self addSubview:icon2];
        icon2.alpha = 0.8;
        icon2.layer.contentsGravity = kCAGravityResizeAspect;
        
        _picker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSelectSecs2.frame)+5, self.frame.size.width, 100) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"1+2", @"3"]}];
        
        [self addSubview:_picker];
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        _picker.hidden = YES;
        
        _picker2 = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSelectSecs2.frame)+5, self.frame.size.width, 100) withGrayOrLight:@"picker_player.png"];
        
        
        _picker2._pickerDataArray = @[@{@"values":@[@"1", @"1+2", @"3"]}];
        
        [self addSubview:_picker2];
        _picker2._selectColor = YELLOW_COLOR;
        _picker2._rowNormalColor = [UIColor whiteColor];
        _picker2.delegate_ = self;
        [_picker2 selectRow:0 inComponent:0];
        _picker2.hidden = YES;
        
        int gap2 = 140;
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(startX, top+gap+gap2, 60, 40)];
        titleL3.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL3];
        titleL3.font = [UIFont boldSystemFontOfSize:14];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"分屏模式";
        
        UILabel* titleL4 = [[UILabel alloc] initWithFrame:CGRectMake(startX+80, top+gap+gap2, 40, 40)];
        titleL4.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL4];
        titleL4.font = [UIFont boldSystemFontOfSize:14];
        titleL4.textColor  = [UIColor whiteColor];
        titleL4.text = @"行";
        
        UILabel* titleL5 = [[UILabel alloc] initWithFrame:CGRectMake(startX+80, top+gap+gap2+60, 40, 40)];
        titleL5.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL5];
        titleL5.font = [UIFont boldSystemFontOfSize:14];
        titleL5.textColor  = [UIColor whiteColor];
        titleL5.text = @"列";
        
        int butGap = 20;
        UIButton *hangJianBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        hangJianBtn.layer.cornerRadius = 5;
        hangJianBtn.clipsToBounds=YES;
        [hangJianBtn setTitle:@"-" forState:UIControlStateNormal];
        hangJianBtn.frame = CGRectMake(startX+80+30, top+gap+gap2+5, 30, 30);
        [self addSubview:hangJianBtn];
        hangJianBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [hangJianBtn addTarget:self
                           action:@selector(hangJianAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        hangNumberBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        hangNumberBtn.userInteractionEnabled=NO;
        hangNumberBtn.layer.cornerRadius = 5;
        hangNumberBtn.clipsToBounds=YES;
        [hangNumberBtn setTitle:@"6" forState:UIControlStateNormal];
        hangNumberBtn.frame = CGRectMake(startX+80+50+butGap, top+gap+gap2+5, 30, 30);
        [self addSubview:hangNumberBtn];
        hangNumberBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIButton *hangJiaBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        hangJiaBtn.layer.cornerRadius = 5;
        hangJiaBtn.clipsToBounds=YES;
        [hangJiaBtn setTitle:@"+" forState:UIControlStateNormal];
        hangJiaBtn.frame = CGRectMake(startX+80+70+butGap*2, top+gap+gap2+5, 30, 30);
        [self addSubview:hangJiaBtn];
        hangJiaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [hangJiaBtn addTarget:self
                        action:@selector(hangJiaAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *lieJianBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        lieJianBtn.layer.cornerRadius = 5;
        lieJianBtn.clipsToBounds=YES;
        [lieJianBtn setTitle:@"-" forState:UIControlStateNormal];
        lieJianBtn.frame = CGRectMake(startX+80+30, top+gap+gap2+5+60, 30, 30);
        [self addSubview:lieJianBtn];
        lieJianBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [lieJianBtn addTarget:self
                        action:@selector(lieJianAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        lieNumberBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        lieNumberBtn.layer.cornerRadius = 5;
        lieNumberBtn.userInteractionEnabled=NO;
        lieNumberBtn.clipsToBounds=YES;
        [lieNumberBtn setTitle:@"8" forState:UIControlStateNormal];
        lieNumberBtn.frame = CGRectMake(startX+80+50+butGap, top+gap+gap2+5+60, 30, 30);
        [self addSubview:lieNumberBtn];
        lieNumberBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIButton *lieJiaBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        lieJiaBtn.layer.cornerRadius = 5;
        lieJiaBtn.clipsToBounds=YES;
        [lieJiaBtn setTitle:@"+" forState:UIControlStateNormal];
        lieJiaBtn.frame = CGRectMake(startX+80+70+butGap*2, top+gap+gap2+5+60, 30, 30);
        [self addSubview:lieJiaBtn];
        lieJiaBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [lieJiaBtn addTarget:self
                       action:@selector(lieJiaAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
    }
    
    return self;
}
- (void) hangJianAction:(id) sender {
    NSString *hangNumberStr = hangNumberBtn.titleLabel.text;
    int value = [hangNumberStr intValue];
    if (value >= 2) {
        value--;
        NSString *jiaNumberStr = [NSString stringWithFormat:@"%d",value];
        [hangNumberBtn setTitle:jiaNumberStr forState:UIControlStateNormal];
    }
}
- (void) hangJiaAction:(id) sender {
    NSString *hangNumberStr = hangNumberBtn.titleLabel.text;
    int value = [hangNumberStr intValue];
    value++;
    
    NSString *jiaNumberStr = [NSString stringWithFormat:@"%d",value];
    [hangNumberBtn setTitle:jiaNumberStr forState:UIControlStateNormal];
}
- (void) lieJianAction:(id) sender {
    NSString *hangNumberStr = lieNumberBtn.titleLabel.text;
    int value = [hangNumberStr intValue];
    if (value >= 2) {
        value--;
        NSString *jiaNumberStr = [NSString stringWithFormat:@"%d",value];
        [lieNumberBtn setTitle:jiaNumberStr forState:UIControlStateNormal];
    }
}
- (void) lieJiaAction:(id) sender {
    NSString *hangNumberStr = lieNumberBtn.titleLabel.text;
    int value = [hangNumberStr intValue];
    value++;
    
    NSString *jiaNumberStr = [NSString stringWithFormat:@"%d",value];
    [lieNumberBtn setTitle:jiaNumberStr forState:UIControlStateNormal];
}
- (void) didConfirmPickerValue:(NSString*) pickerValue{
    if (selectedCustomer == 1) {
        [btnSelectSecs setTitle:pickerValue forState:UIControlStateNormal];
        
        _picker.hidden = YES;
    } else {
        [btnSelectSecs2 setTitle:pickerValue forState:UIControlStateNormal];
        
        _picker2.hidden = YES;
    }
    selectedCustomer = -1;
}

- (void) chooseSecs:(id) sender {
    _picker.hidden=NO;
    selectedCustomer = 1;
}

- (void) chooseSecs2:(id) sender {
    _picker2.hidden=NO;
    selectedCustomer = 2;
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




