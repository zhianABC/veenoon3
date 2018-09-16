//
//  JSlideView.m
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import "JSlideView.h"

@interface JSlideView ()
{
    UIImageView *roadSlider;
    
    UIImageView *roadSliderHighlight;
    
    CGPoint beginPoint;
    
    float curValue;
    
    BOOL mute;
}

@end

@implementation JSlideView
@synthesize delegate;
@synthesize topEdge;
@synthesize bottomEdge;
@synthesize maxValue;
@synthesize minValue;
@synthesize stepValue;

@synthesize data;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        slider = [[UIImageView alloc] initWithImage:sliderBg];
        [self addSubview:slider];
        
        frame.size.width = slider.frame.size.width;
        frame.size.height = slider.frame.size.height;
        
        self.frame = frame;
        
        roadSlider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_slider_road.png"]];
        [self addSubview:roadSlider];
        roadSlider.image = [UIImage imageNamed:@"user_audio_slider_road_gray.png"];
        roadSlider.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)+2);;
        roadSlider.clipsToBounds = YES;
        
        roadSliderHighlight = [[UIImageView alloc] initWithFrame:roadSlider.frame];
        [self addSubview:roadSliderHighlight];
        UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v_slider_road.png"]];
        [roadSliderHighlight addSubview:imv];
        roadSliderHighlight.clipsToBounds = YES;

        
        sliderThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jslide_thumb.png"]];
        [self addSubview:sliderThumb];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [self addSubview:valueLabel];
        valueLabel.textColor = [UIColor whiteColor];
        valueLabel.font = [UIFont systemFontOfSize:13];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        
        stepValue = 1;
        
        mute = NO;
        
        [self setIndicatorImage: [UIImage imageNamed:@"wireless_slide_n.png"]];
    }
    
    return self;
}

- (void) setShowIconImage:(UIImage *)image{
    
    
}

- (void) setRoadImage:(UIImage *)image{
    
    //roadSlider.image = image;
}

- (void) resetScalValue:(int) scalValue {
    
    valueLabel.text = [NSString stringWithFormat:@"%d", (scalValue)];
    curValue = scalValue;
    
    if (scalValue <= minValue)
    {
        
        sliderThumb.image = [UIImage imageNamed:@"jslide_thumb_n.png"];
        
        if(!mute)
         indicator.image = [UIImage imageNamed:@"wireless_slide_n.png"];
        
    }
    else
    {
        
        sliderThumb.image = [UIImage imageNamed:@"jslide_thumb.png"];
        
        if(!mute)
        indicator.image = [UIImage imageNamed:@"wireless_slide_s.png"];
        
    }
    
    CGRect rc = roadSliderHighlight.frame;
    rc.origin.y = CGRectGetMidY(sliderThumb.frame);
    float offset = CGRectGetMinY(roadSlider.frame);
    rc.size.height = CGRectGetHeight(roadSlider.frame) - rc.origin.y + offset;
    roadSliderHighlight.frame = rc;
    
}

- (void) setIndicatorImage:(UIImage *)image{
    
    if(indicator == nil)
    {
        indicator = [[UIImageView alloc] initWithImage:image];
    }
    else
    {
        indicator.image = image;
    }
    
    [self addSubview:indicator];
    
    indicator.center = CGPointMake(self.bounds.size.width/2, CGRectGetMaxY(self.bounds)-16);
    
    [self bringSubviewToFront:sliderThumb];
    
    UIButton *btnMute = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMute.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    btnMute.center = indicator.center;
    [self addSubview:btnMute];
    [btnMute addTarget:self
                action:@selector(muteAction:)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void) muteAction:(id)sender{
    
    if(mute)
    {
        mute = NO;
        //indicator.alpha = 1;
        
        float f = [self getScaleValue];
        if(f > minValue)
        {
            indicator.image = [UIImage imageNamed:@"wireless_slide_s.png"];
        }
        else
        {
            indicator.image = [UIImage imageNamed:@"wireless_slide_n.png"];
        }
    }
    else
    {
        mute = YES;
        //indicator.alpha = 0.3;
        
        indicator.image = [UIImage imageNamed:@"wireless_slide_mute.png"];
    }
    
    if(delegate && [delegate respondsToSelector:@selector(didSliderMuteChanged:object:)])
    {
        [delegate didSliderMuteChanged:mute object:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint p = [[touches anyObject] locationInView:self];
    beginPoint = p;
    
    if(beginPoint.y < CGRectGetMinY(roadSlider.frame))
    {
        beginPoint.y = CGRectGetMinY(roadSlider.frame);
    }
    if(beginPoint.y > CGRectGetMaxY(roadSlider.frame))
    {
        beginPoint.y = CGRectGetMaxY(roadSlider.frame);
    }
}

- (void) moveToBeginPoint{
    
    CGRect rc = slider.frame;
    
    rc = CGRectMake(rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
    
    if (CGRectContainsPoint(rc, beginPoint)) {
        
        CGPoint colorPoint = beginPoint;
        colorPoint.x = slider.center.x;
        if(colorPoint.y < topEdge)
            colorPoint.y = topEdge;
        if(colorPoint.y > rc.size.height - bottomEdge)
            colorPoint.y = rc.size.height - bottomEdge;
        sliderThumb.center = colorPoint;
        
        float h = rc.size.height - topEdge - bottomEdge;
        float subh = (rc.size.height - bottomEdge) - sliderThumb.center.y;
        float value = (maxValue - minValue)*(float)subh/h + minValue;
        
        [self resetScalValue:value];
        
        if(delegate && [delegate respondsToSelector:@selector(didSliderValueChanged:object:)])
        {
            [delegate didSliderValueChanged:value object:self];
        }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
    if(!CGPointEqualToPoint(beginPoint, CGPointZero))
    {
        [self moveToBeginPoint];
        beginPoint = CGPointZero;
    }
    
    CGPoint p = [[touches anyObject] locationInView:self];
    
    CGRect rc = slider.frame;
    rc = CGRectMake(rc.origin.x, rc.origin.y, rc.size.width, rc.size.height);
    
    CGPoint colorPoint = p;
    colorPoint.x = slider.center.x;
    if(colorPoint.y < topEdge)
        colorPoint.y = topEdge;
    if(colorPoint.y > rc.size.height - bottomEdge)
        colorPoint.y = rc.size.height - bottomEdge;
    sliderThumb.center = colorPoint;
    
    
    float h = rc.size.height - topEdge - bottomEdge;
    float subh = (rc.size.height - bottomEdge) - sliderThumb.center.y;
    
    float value = (maxValue - minValue)*(float)subh/h + minValue;
    
    //        valueLabel.text = [NSString stringWithFormat:@"%d", (value)];
    [self resetScalValue:value];
    //NSLog(@"value = %d", value);
    
    if(delegate && [delegate respondsToSelector:@selector(didSliderValueChanged:object:)])
    {
        
        [delegate didSliderValueChanged:value object:self];
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(!CGPointEqualToPoint(beginPoint, CGPointZero))
    {
        if(beginPoint.y < sliderThumb.center.y)
        {
            //向上增加
            curValue+=stepValue;
        }
        else if(beginPoint.y > sliderThumb.center.y)
        {
            curValue-=stepValue;
        }
        
        
        [self setScaleValue:curValue];
        
        beginPoint = CGPointZero;
    }
    
    if(delegate && [delegate respondsToSelector:@selector(didSliderEndChanged:)])
    {
        [delegate didSliderEndChanged:self];
    }
    
}

- (float) getScaleValue{
   
    CGRect rc = slider.frame;
    float h = rc.size.height - topEdge - bottomEdge;
    float subh = (rc.size.height - bottomEdge) - sliderThumb.center.y;
    
    float value = (maxValue - minValue)*(float)subh/h + minValue;
    
    
    return value;
}

- (void) resetScale{
    
    sliderThumb.center = CGPointMake(slider.frame.origin.x+slider.bounds.size.width/2.0,
                                     self.frame.size.height - bottomEdge);
    
    float value = [self getScaleValue];
//    valueLabel.text = [NSString stringWithFormat:@"%d", (value)];
    [self resetScalValue:value];
}

- (void) setScaleValue:(float)value{
    
    CGRect rc = slider.frame;
    float h = rc.size.height - topEdge - bottomEdge;
    float subh = ((float)(value - minValue)*h)/(maxValue - minValue);
    float cy = (rc.size.height - bottomEdge) - subh;
    
    sliderThumb.center = CGPointMake(slider.frame.origin.x+slider.bounds.size.width/2.0,
                                     cy);
    
    valueLabel.text = [NSString stringWithFormat:@"%0.1f", (value)];
    [self resetScalValue:value];
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
