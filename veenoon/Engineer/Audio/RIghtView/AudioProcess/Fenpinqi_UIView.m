//
//  Fenpinqi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "Fenpinqi_UIView.h"
#import "veenoon-Swift.h"
#import "SlideButton.h"
@interface Fenpinqi_UIView () {
    UILabel *gaotongL;
    UILabel *gaotongL2;
}
@end

@implementation Fenpinqi_UIView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        CGRect rc = CGRectMake(0, 40, frame.size.width, 320);
        UIView *bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        
        rc = CGRectMake(10, 50, frame.size.width-20, 300);
        FilterGraphView *lm = [[FilterGraphView alloc] initWithFrame:rc];
        lm.backgroundColor = [UIColor clearColor];
        [self addSubview:lm];
        
        int startH = CGRectGetMaxY(lm.frame) + 30;
        int startX = 180;
        
        UILabel *addLabel = [[UILabel alloc] init];
        addLabel.text = @"高通 (HP)";
        addLabel.font = [UIFont systemFontOfSize: 13];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.frame = CGRectMake(startX, startH+15, 120, 20);
        [self addSubview:addLabel];
        
        addLabel = [[UILabel alloc] init];
        addLabel.text = @"50Hz";
        addLabel.font = [UIFont systemFontOfSize: 13];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.frame = CGRectMake(startX-60, startH+115, 120, 20);
        [self addSubview:addLabel];
        
        addLabel = [[UILabel alloc] init];
        addLabel.text = @"250Hz";
        addLabel.font = [UIFont systemFontOfSize: 13];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.frame = CGRectMake(startX+80, startH+115, 120, 20);
        [self addSubview:addLabel];
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33, startH+30, 120, 120)];
        btn._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
        btn._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
        [btn enableValueSet:YES];
        
        [self addSubview:btn];
        
        gaotongL = [[UILabel alloc] init];
        gaotongL.text = @"100Hz";
        gaotongL.font = [UIFont systemFontOfSize: 13];
        gaotongL.textColor = [UIColor whiteColor];
        gaotongL.frame = CGRectMake(startX+10, startH+75, 50, 20);
        [self addSubview:gaotongL];
        
        int gap = 450;
        
        UILabel *addLabel2 = [[UILabel alloc] init];
        addLabel2.text = @"低通 (LP)";
        addLabel2.font = [UIFont systemFontOfSize: 13];
        addLabel2.textColor = [UIColor whiteColor];
        addLabel2.frame = CGRectMake(startX+gap, startH+15, 120, 20);
        [self addSubview:addLabel2];
        
        addLabel2 = [[UILabel alloc] init];
        addLabel2.text = @"50Hz";
        addLabel2.font = [UIFont systemFontOfSize: 13];
        addLabel2.textColor = [UIColor whiteColor];
        addLabel2.frame = CGRectMake(startX-60+gap, startH+115, 120, 20);
        [self addSubview:addLabel2];
        
        addLabel2 = [[UILabel alloc] init];
        addLabel2.text = @"250Hz";
        addLabel2.font = [UIFont systemFontOfSize: 13];
        addLabel2.textColor = [UIColor whiteColor];
        addLabel2.frame = CGRectMake(startX+80+gap, startH+115, 120, 20);
        [self addSubview:addLabel2];
        
        SlideButton *btn2 = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33+gap, startH+30, 120, 120)];
        UIImage *image2 = [UIImage imageNamed:@"yinpinchuli_anniu.png"];
        [btn2 changeButtonBackgroundImage:image2];
        [self addSubview:btn2];
        
        gaotongL2 = [[UILabel alloc] init];
        gaotongL2.text = @"100Hz";
        gaotongL2.font = [UIFont systemFontOfSize: 13];
        gaotongL2.textColor = [UIColor whiteColor];
        gaotongL2.frame = CGRectMake(startX+10+gap, startH+75, 50, 20);
        [self addSubview:gaotongL2];
    }
    
    return self;
}

@end
