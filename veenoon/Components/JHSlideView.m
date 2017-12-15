//
//  JHSlideView.m
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import "JHSlideView.h"

@implementation JHSlideView
@synthesize maxValue;
@synthesize minValue;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        slider = [[UISlider alloc] initWithFrame:CGRectMake(0, frame.size.height/2-10+10,
                                                            frame.size.width-40, 20)];
        slider.minimumValue = 1;// 设置最小值
        slider.maximumValue = 180;// 设置最大值
        slider.continuous = YES;// 设置可连续变化
        [self addSubview:slider];
        [slider addTarget:self
                   action:@selector(sliderValueChanged:)
         forControlEvents:UIControlEventValueChanged];
        
        if(sliderBg)
        {
            [slider setMaximumTrackImage:sliderBg forState:UIControlStateNormal];
        }
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        [self addSubview:valueLabel];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:13];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        
        maxL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-40,
                                                         0,
                                                         40, frame.size.height)];
        [self addSubview:maxL];
        maxL.textColor = [UIColor whiteColor];
        maxL.font = [UIFont systemFontOfSize:12];
        maxL.textAlignment = NSTextAlignmentRight;
        maxL.text = @"180s";
        
    }
    
    return self;
}

- (void) setRoadImage:(UIImage *)image{
    
    [slider setMinimumTrackImage:image forState:UIControlStateNormal];
    
}


- (void) sliderValueChanged:(UISlider*)sender{
    
    UISlider *slider = (UISlider *)sender;
    valueLabel.text = [NSString stringWithFormat:@"%.0fs", slider.value];
    
    int v = [valueLabel.text intValue];
    
    int ww = CGRectGetWidth(slider.frame) - 30;
    int xx = 15+v*ww/(maxValue - minValue + 1);
    
    NSLog(@"%d-%d", v, xx);
    
    valueLabel.center  = CGPointMake(xx, valueLabel.center.y);
    
}


- (int) getScaleValue{
   
    int value = slider.value;
    return value;
}

- (void) resetScale{
    
    
    int value = [self getScaleValue];
    valueLabel.text = [NSString stringWithFormat:@"%ds", (value)];
    
    int ww = CGRectGetWidth(slider.frame) - 30;
    int xx = 15+value*ww/(maxValue - minValue + 1);
    
    
    valueLabel.center  = CGPointMake(xx, valueLabel.center.y);
    
}

- (void) setScaleValue:(int)value{
    
    
    [slider setValue:value];
    
    valueLabel.text = [NSString stringWithFormat:@"%ds", (value)];
    
    int ww = CGRectGetWidth(slider.frame) - 30;
    int xx = 15+value*ww/(maxValue - minValue + 1);
    
    valueLabel.center  = CGPointMake(xx, valueLabel.center.y);
  
}


- (void) dealloc
{
  
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
