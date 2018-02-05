//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "MixVoiceSettingsView.h"
#import "UIButton+Color.h"

@interface MixVoiceSettingsView ()
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
}
@end

@implementation MixVoiceSettingsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGB(0, 89, 118);
        
        int bw = 120;
        int x = (frame.size.width - bw)/2;
        int top = (frame.size.height/2 - 40*4 - 5*3)/2;
        btn1 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn1.frame = CGRectMake(x, top, bw, 40);
        btn1.clipsToBounds = YES;
        btn1.layer.cornerRadius = 5;
        [self addSubview:btn1];
        
        [btn1 setTitle:@"语音激励" forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn2 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn2.frame = CGRectMake(x, top, bw, 40);
        btn2.clipsToBounds = YES;
        btn2.layer.cornerRadius = 5;
        [self addSubview:btn2];
        
        [btn2 setTitle:@"标准发言" forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn3 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn3.frame = CGRectMake(x, top, bw, 40);
        btn3.clipsToBounds = YES;
        btn3.layer.cornerRadius = 5;
        [self addSubview:btn3];
        
        [btn3 setTitle:@"音频处理" forState:UIControlStateNormal];
        btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn4 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn4.frame = CGRectMake(x, top, bw, 40);
        btn4.clipsToBounds = YES;
        btn4.layer.cornerRadius = 5;
        [self addSubview:btn4];
        
        [btn4 setTitle:@"摄像追踪" forState:UIControlStateNormal];
        btn4.titleLabel.font = [UIFont systemFontOfSize:15];

        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2,
                                                                  self.frame.size.width, 1)];
        line.backgroundColor =  M_GREEN_LINE;
        [self addSubview:line];
        
        
    }
    
    return self;
}


@end
