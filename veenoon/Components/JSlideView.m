//
//  JSlideView.m
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import "JSlideView.h"

@implementation JSlideView
@synthesize delegate;
@synthesize topEdge;
@synthesize bottomEdge;
@synthesize maxValue;
@synthesize minValue;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        slider = [[UIImageView alloc] initWithImage:sliderBg];
        [self addSubview:slider];
        
        frame.size.width = slider.frame.size.width;
        frame.size.height = slider.frame.size.height;
        
        self.frame = frame;
        
        sliderThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jslide_thumb.png"]];
        [self addSubview:sliderThumb];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [self addSubview:valueLabel];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:14];
        valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void) setRoadImage:(UIImage *)image{
    
    if(roadSlider == nil)
    {
        roadSlider = [[UIImageView alloc] initWithImage:image];
    }
    else
    {
        roadSlider.image = image;
    }
    
    [self addSubview:roadSlider];
    
    roadSlider.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    [self bringSubviewToFront:sliderThumb];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint p = [[touches anyObject] locationInView:self];
    CGRect rc = slider.frame;
    
    rc = CGRectMake(rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
    
	if (CGRectContainsPoint(rc, p)) {
        
        CGPoint colorPoint = p;
        colorPoint.x = slider.center.x;
        if(colorPoint.y < topEdge)
            colorPoint.y = topEdge;
        if(colorPoint.y > rc.size.height - bottomEdge)
            colorPoint.y = rc.size.height - bottomEdge;
        sliderThumb.center = colorPoint;
        
        
        int h = rc.size.height - topEdge - bottomEdge;
        int subh = (rc.size.height - bottomEdge) - sliderThumb.center.y;
        int value = (maxValue - minValue)*(float)subh/h + minValue;
        
       // NSLog(@"value = %d", value);
        
        valueLabel.text = [NSString stringWithFormat:@"%d", (value)];
        
        if(delegate && [delegate respondsToSelector:@selector(didSliderValueChanged:object:)])
        {
            
            [delegate didSliderValueChanged:value object:self];
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint p = [[touches anyObject] locationInView:self];
    
    CGRect rc = slider.frame;
    rc = CGRectMake(rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
    
	if (CGRectContainsPoint(rc, p)) {
		
        CGPoint colorPoint = p;
        colorPoint.x = slider.center.x;
        if(colorPoint.y < topEdge)
            colorPoint.y = topEdge;
        if(colorPoint.y > rc.size.height - bottomEdge)
            colorPoint.y = rc.size.height - bottomEdge;
        sliderThumb.center = colorPoint;
        
        
        int h = rc.size.height - topEdge - bottomEdge;
        int subh = (rc.size.height - bottomEdge) - sliderThumb.center.y;

        int value = (maxValue - minValue)*(float)subh/h + minValue;
        
        valueLabel.text = [NSString stringWithFormat:@"%d", (value)];
        
        //NSLog(@"value = %d", value);
        
        if(delegate && [delegate respondsToSelector:@selector(didSliderValueChanged:object:)])
        {
            
            [delegate didSliderValueChanged:value object:self];
        }
        
	}

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(delegate && [delegate respondsToSelector:@selector(didSliderEndChanged:)])
    {
        [delegate didSliderEndChanged:self];
    }
    
}

- (int) getScaleValue{
   
    CGRect rc = slider.frame;
    int h = rc.size.height - topEdge - bottomEdge;
    int subh = (rc.size.height - bottomEdge) - sliderThumb.center.y;
    
    int value = (maxValue - minValue)*(float)subh/h + minValue;
    
    return value;
}

- (void) resetScale{
    
    sliderThumb.center = CGPointMake(slider.frame.origin.x+slider.bounds.size.width/2.0,
                                     self.frame.size.height - bottomEdge);
    
    int value = [self getScaleValue];
    valueLabel.text = [NSString stringWithFormat:@"%d", (value)];
}

- (void) setScaleValue:(int)value{
    
    CGRect rc = slider.frame;
    int h = rc.size.height - topEdge - bottomEdge;
    int subh = ((float)(value - minValue)*h)/(maxValue - minValue);
    int cy = (rc.size.height - bottomEdge) - subh;
    
    sliderThumb.center = CGPointMake(slider.frame.origin.x+slider.bounds.size.width/2.0,
                                     cy);
    
    valueLabel.text = [NSString stringWithFormat:@"%d", (value)];
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
