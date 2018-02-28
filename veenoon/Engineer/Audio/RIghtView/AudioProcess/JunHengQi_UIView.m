//
//  JunHengQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "JunHengQi_UIView.h"
#import "veenoon-Swift.h"
#import "SlideButton.h"

@interface JunHengQi_UIView () {
    UILabel *gaotongL;
    UILabel *gaotongL2;
}
@end

@implementation JunHengQi_UIView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
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
        int startX = 420;
        
        UILabel *addLabel = [[UILabel alloc] init];
        addLabel.text = @"-12dB";
        addLabel.font = [UIFont systemFontOfSize: 13];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.frame = CGRectMake(startX-60, startH+115, 120, 20);
        [self addSubview:addLabel];
        
        addLabel = [[UILabel alloc] init];
        addLabel.text = @"12dB";
        addLabel.font = [UIFont systemFontOfSize: 13];
        addLabel.textColor = [UIColor whiteColor];
        addLabel.frame = CGRectMake(startX+80, startH+115, 120, 20);
        [self addSubview:addLabel];
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33, startH+30, 120, 120)];
        [self addSubview:btn];
        
        gaotongL = [[UILabel alloc] init];
        gaotongL.text = @"10dB";
        gaotongL.font = [UIFont systemFontOfSize: 13];
        gaotongL.textColor = [UIColor whiteColor];
        gaotongL.frame = CGRectMake(startX+10, startH+75, 50, 20);
        [self addSubview:gaotongL];
    }
    
    return self;
}

@end
