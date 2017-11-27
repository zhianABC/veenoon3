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
        
        self.frame = CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height);
        
        valueThumb = [[UIImageView alloc] initWithFrame:CGRectMake(3.5,
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
    
    valueThumb.frame = CGRectMake(3.5 + ow - w,
                                  2,
                                  w,
                                  bg.frame.size.height-4);
    
    if(value < 0.21)
    {
        if(warningColor)
        {
            valueThumb.backgroundColor = warningColor;
        }
        else
            valueThumb.backgroundColor = [UIColor redColor];
    }
    else
    {
        if(normalColor)
        {
            valueThumb.backgroundColor = normalColor;
        }
        else
            valueThumb.backgroundColor = [UIColor greenColor];
    }
    
}

@end
