//
//  BatteryView.m
//  veenoon
//
//  Created by chen jack on 2017/11/27.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "BatteryView.h"

@interface BatteryView ()
{
    UIImageView *bg;
    
    UIImageView *valueThumb;
    
    int ow;
    
    UILabel * percent;
    
    int left;
}

@end

@implementation BatteryView
@synthesize normalColor;
@synthesize warningColor;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        bg = [[UIImageView alloc]
              initWithImage:[UIImage imageNamed:@"battery.png"]];
        [self addSubview:bg];
        
        left = 53;
        
        bg.frame = CGRectMake(left, 0, bg.frame.size.width, bg.frame.size.height);
        
        
        percent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, left-3, bg.frame.size.height)];
        [self addSubview:percent];
        percent.textAlignment = NSTextAlignmentRight;
        percent.font = [UIFont systemFontOfSize:9];
        
        self.frame = CGRectMake(0, 0, bg.frame.size.width+left, bg.frame.size.height);
        
        valueThumb = [[UIImageView alloc] initWithFrame:CGRectMake(left,
                                                                   2,
                                                                   bg.frame.size.width-5,
                                                                   bg.frame.size.height-4)];
        [self addSubview:valueThumb];
        valueThumb.backgroundColor = [UIColor greenColor];
        
        ow = bg.frame.size.width-5;
    }
    
    return self;
}

- (void) setBatteryValue:(float)value{
    
    int w = value * CGRectGetWidth(valueThumb.frame);
    
    valueThumb.frame = CGRectMake(left + ow - w,
                                  2,
                                  w,
                                  bg.frame.size.height-4);
    
    percent.text = [NSString stringWithFormat:@"%0.0f%%", value*100.0];
    
    if(value < 0.21)
    {
        if(warningColor)
        {
            valueThumb.backgroundColor = warningColor;
            percent.textColor = warningColor;
        }
        else{
            valueThumb.backgroundColor = [UIColor redColor];
            percent.textColor = [UIColor redColor];
        }
    }
    else
    {
        if(normalColor)
        {
            valueThumb.backgroundColor = normalColor;
            percent.textColor = normalColor;
        }
        else{
            valueThumb.backgroundColor = [UIColor greenColor];
            percent.textColor = [UIColor greenColor];
        }
    }
    
}
- (void) updateGrayBatteryView{
    if (bg) {
        [bg removeFromSuperview];
    }
    
    bg = [[UIImageView alloc]
          initWithImage:[UIImage imageNamed:@"huisedianchi.png"]];
    [self addSubview:bg];
    
    left = 53;
    
    bg.frame = CGRectMake(left, 0, bg.frame.size.width, bg.frame.size.height);
    percent.textColor = [UIColor whiteColor];
    valueThumb.backgroundColor = [UIColor whiteColor];
}
- (void) updateYellowBatteryView {
    if (bg) {
        [bg removeFromSuperview];
    }
    
    bg = [[UIImageView alloc]
          initWithImage:[UIImage imageNamed:@"huangsedianchi.png"]];
    [self addSubview:bg];
    
    left = 53;
    
    bg.frame = CGRectMake(left, 0, bg.frame.size.width, bg.frame.size.height);
    percent.textColor = YELLOW_COLOR;
    valueThumb.backgroundColor = YELLOW_COLOR;
}
@end
