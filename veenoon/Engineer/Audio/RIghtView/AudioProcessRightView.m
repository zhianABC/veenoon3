//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "AudioProcessRightView.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "ComSettingView.h"

@interface AudioProcessRightView () <CustomPickerViewDelegate> {
    
    ComSettingView *_com;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
}
@end

@implementation AudioProcessRightView 
@synthesize delegate_;

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(0, 89, 118);
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        int bw = 120;
        int x = (frame.size.width - bw)/2;
        int top = (frame.size.height/2 - 40*2 - 5*3);
        btn1 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn1.frame = CGRectMake(x, top, bw, 40);
        btn1.clipsToBounds = YES;
        btn1.layer.cornerRadius = 5;
        [self addSubview:btn1];
        
        [btn1 setTitle:@"输入设置" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(yuyinjiliAction:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn2 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn2.frame = CGRectMake(x, top, bw, 40);
        btn2.clipsToBounds = YES;
        btn2.layer.cornerRadius = 5;
        [self addSubview:btn2];
        
        [btn2 setTitle:@"输出设置" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(biaozhunfayanAction:) forControlEvents:UIControlEventTouchUpInside];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn3 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn3.frame = CGRectMake(x, top, bw, 40);
        btn3.clipsToBounds = YES;
        btn3.layer.cornerRadius = 5;
        [self addSubview:btn3];
        
        [btn3 setTitle:@"矩阵路由" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(yinpinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
        btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn4 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn4.frame = CGRectMake(x, top, bw, 40);
        btn4.clipsToBounds = YES;
        btn4.layer.cornerRadius = 5;
        [self addSubview:btn4];
        
        [btn4 setTitle:@"标识图标" forState:UIControlStateNormal];
        [btn4 addTarget:self action:@selector(shexiangzhuizongAction:) forControlEvents:UIControlEventTouchUpInside];
        btn4.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
    }
    
    return self;
}

- (void) yuyinjiliAction:(id)sender{
    [btn1 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self selectBtnAction:btn1.titleLabel.text];
}
- (void) biaozhunfayanAction:(id)sender{
    [btn2 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self selectBtnAction:btn2.titleLabel.text];
}
- (void) yinpinchuliAction:(id)sender{
    [btn3 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self selectBtnAction:btn3.titleLabel.text];
}
- (void) shexiangzhuizongAction:(id)sender{
    [btn4 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self selectBtnAction:btn4.titleLabel.text];
}

- (void) selectBtnAction:(NSString*)btnTitle {
    if([delegate_ respondsToSelector:@selector(didSelectButtonAction:)]){
        [delegate_ didSelectButtonAction:btnTitle];
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



