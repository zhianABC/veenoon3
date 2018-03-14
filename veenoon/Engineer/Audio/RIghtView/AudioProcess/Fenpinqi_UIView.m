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


@interface Fenpinqi_UIView ()<SlideButtonDelegate> {
    UILabel *gaotongL;
    UILabel *gaotongL2;
    
    SlideButton *btnHight;
    SlideButton *btnLow;
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
        

        //50 - 250
        btnHight = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33,
                                                                 CGRectGetMaxY(addLabel.frame),
                                                                 120, 120)];
        btnHight._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
        btnHight._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
        [btnHight enableValueSet:YES];
        btnHight.delegate = self;
        [self addSubview:btnHight];
        
        gaotongL = [[UILabel alloc] init];
        gaotongL.text = @"50KHz";
        gaotongL.font = [UIFont systemFontOfSize: 13];
        gaotongL.textColor = [UIColor whiteColor];
        gaotongL.frame = CGRectMake(0, CGRectGetMaxY(btnHight.frame), 60, 20);
        [self addSubview:gaotongL];
        gaotongL.textAlignment = NSTextAlignmentCenter;
        gaotongL.layer.cornerRadius = 5;
        gaotongL.backgroundColor = RGB(0, 89, 118);
        gaotongL.center = CGPointMake(btnHight.center.x, gaotongL.center.y);
        gaotongL.clipsToBounds = YES;
        
        int gap = 450;
        
        UILabel *addLabel2 = [[UILabel alloc] init];
        addLabel2.text = @"低通 (LP)";
        addLabel2.font = [UIFont systemFontOfSize: 13];
        addLabel2.textColor = [UIColor whiteColor];
        addLabel2.frame = CGRectMake(startX+gap, startH+15, 120, 20);
        [self addSubview:addLabel2];
        
      
        //8 - 20
        btnLow = [[SlideButton alloc] initWithFrame:CGRectMake(startX-33+gap,
                                                               CGRectGetMaxY(addLabel2.frame),
                                                               120, 120)];
        btnLow._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
        btnLow._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
        [btnLow enableValueSet:YES];
        [self addSubview:btnLow];
        btnLow.delegate = self;
        
        gaotongL2 = [[UILabel alloc] init];
        gaotongL2.text = @"8KHz";
        gaotongL2.font = [UIFont systemFontOfSize: 13];
        gaotongL2.textColor = [UIColor whiteColor];
        gaotongL2.frame = CGRectMake(0, CGRectGetMaxY(btnLow.frame), 60, 20);
        [self addSubview:gaotongL2];
        gaotongL2.textAlignment = NSTextAlignmentCenter;
        gaotongL2.layer.cornerRadius = 5;
        gaotongL2.backgroundColor = RGB(0, 89, 118);
        gaotongL2.center = CGPointMake(btnLow.center.x, gaotongL2.center.y);
        gaotongL2.clipsToBounds = YES;
        
        
    }
    
    return self;
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    if(slbtn == btnHight)
    {
        int k = (value *(250-50))+50;
        gaotongL.text = [NSString stringWithFormat:@"%dKHz", k];
    }
    else
        if(slbtn == btnLow)
        {
            int k = (value *(20-8))+8;
            gaotongL2.text = [NSString stringWithFormat:@"%dKHz", k];
        }
}

@end
