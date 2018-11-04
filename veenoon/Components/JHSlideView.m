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
@synthesize maxL;
@synthesize _isShowValue;
@synthesize ctrl;

@synthesize delegate;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _isShowValue = YES;
        
        _sliderBg = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                            frame.size.height/2,
                                                            frame.size.width-40,
                                                            6)];
        UIImage *img = [UIImage imageNamed:@"progress_bk.png"];
        img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        _sliderBg.image = img;
        //_sliderBg.layer.contentsGravity = kCAGravityCenter;
        _sliderBg.clipsToBounds = YES;
        [self addSubview:_sliderBg];
        
        _sliderFr = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                  frame.size.height/2,
                                                                  frame.size.width-40,
                                                                  6)];
        img = [UIImage imageNamed:@"process_light.png"];
        img = [img stretchableImageWithLeftCapWidth:10 topCapHeight:0];
        _sliderFr.image = img;
        //_sliderFr.layer.contentsGravity = kCAGravityResizeAspect;
        _sliderFr.center = CGPointMake(_sliderFr.center.x, _sliderBg.center.y);
        [self addSubview:_sliderFr];
        
        _thumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_thumb.png"]];
        [self addSubview:_thumb];
        _thumb.center = CGPointMake(0, _sliderFr.center.y);
        
        
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
        
        curValue = 1;
        
        UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnEdit];
        btnEdit.frame = CGRectMake(frame.size.width - 80,
                                   0,
                                   80,
                                   frame.size.height);
        [btnEdit addTarget:self
                    action:@selector(editValAction:)
          forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return self;
}

- (void) editValAction:(id)sender{
    
    NSString *defl = valueLabel.text;
    defl = [defl stringByReplacingOccurrencesOfString:@"s" withString:@""];
    
    IMP_BLOCK_SELF(JHSlideView);
    
    NSString *alert = @"设置时间，范围1s - 180s";
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil
                                                          message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"时间";
        textField.text = defl;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        NSString *val = alValTxt.text;
        if (val && [val length] > 0) {
            
            [block_self doSetValValue:[val intValue]];
        }
    }]];
    
    
    
    
    [self.ctrl presentViewController:alertController
                            animated:YES
                          completion:nil];
}

- (void) doSetValValue:(int)val{
    
    int fv = val;
    if(fv < minValue)
        fv = minValue;
    else if(fv > maxValue)
        fv = maxValue;
    
    [self setScaleValue:fv];
    
}



- (void) setRoadImage:(UIImage *)image{
    
   // [slider setMinimumTrackImage:image forState:UIControlStateNormal];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint p = [[touches anyObject] locationInView:self];
    CGRect rc = CGRectMake(0, 0,
                           self.frame.size.width-40,
                           self.frame.size.height);
    
    CGRect rc1 = CGRectMake(0, 0,
                            self.frame.size.width-30,
                            self.frame.size.height);
    
    
    if (CGRectContainsPoint(rc1, p)) {
        
        CGPoint colorPoint = p;
        colorPoint.y = _sliderFr.center.y;
        if(colorPoint.x < 0)
            colorPoint.x = 0;
        if(colorPoint.x > rc.size.width - 0)
            colorPoint.x = rc.size.width - 0;
        _thumb.center = colorPoint;
        
        
        int w = rc.size.width;
        int subw = _thumb.center.x;
        int value = (maxValue - minValue + 1)*(float)subw/w + minValue;
        
        if(value > maxValue)
            value = maxValue;

        // NSLog(@"value = %d", value);
        
        [self sliderValueChanged:value];
    
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint p = [[touches anyObject] locationInView:self];
    CGRect rc = CGRectMake(0, 0,
                           self.frame.size.width-40,
                           self.frame.size.height);
    
    CGRect rc1 = CGRectMake(0, 0,
                           self.frame.size.width-30,
                           self.frame.size.height);
    
    
    if (CGRectContainsPoint(rc1, p)) {
        
        CGPoint colorPoint = p;
        colorPoint.y = _sliderFr.center.y;
        if(colorPoint.x < 0)
            colorPoint.x = 0;
        if(colorPoint.x > rc.size.width - 0)
            colorPoint.x = rc.size.width - 0;
        _thumb.center = colorPoint;
        
        
        int w = rc.size.width;
        int subw = _thumb.center.x;
        int value = (maxValue - minValue + 1)*(float)subw/w + minValue;
        
        // NSLog(@"value = %d", value);
        if(value > maxValue)
            value = maxValue;

        [self sliderValueChanged:value];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(delegate && [delegate respondsToSelector:@selector(didSlideEndValueChanged:index:)])
    {
        [delegate didSlideEndValueChanged:curValue index:(int)self.tag];
    }
    
}

- (void) sliderValueChanged:(int)value{
    
    curValue = value;
    
    if(_isShowValue)
    {
        valueLabel.text = [NSString stringWithFormat:@"%ds", value];
        valueLabel.center  = CGPointMake(_thumb.center.x, valueLabel.center.y);
    }
    
    CGRect rc = _sliderFr.frame;
    rc.size.width = _thumb.center.x;
    _sliderFr.frame = rc;
    
    
    if(delegate && [delegate respondsToSelector:@selector(didSlideValueChanged:index:)])
    {
        [delegate didSlideValueChanged:value index:(int)self.tag];
    }
    
}


- (int) getScaleValue{
   
    CGRect rc = CGRectMake(0, 0,
                           self.frame.size.width-40,
                           self.frame.size.height);
    
        int w = rc.size.width;
        int subw = _thumb.center.x;
        int value = (maxValue - minValue + 1)*(float)subw/w + minValue;

    return value;
}


- (void) setScaleValue:(int)value{
    
    CGRect rc = CGRectMake(0, 0,
                           self.frame.size.width-40,
                           self.frame.size.height);
    
    int w = rc.size.width;
    float subw = (value - minValue)*w/(maxValue - minValue + 1);
    
    _thumb.center = CGPointMake(subw, _thumb.center.y);
    
    [self sliderValueChanged:value];
}

- (void) initScaleValue:(int)value{
    
    CGRect rc = CGRectMake(0, 0,
                           self.frame.size.width-40,
                           self.frame.size.height);
    
    int w = rc.size.width;
    float subw = (value - minValue)*w/(maxValue - minValue + 1);
    
    _thumb.center = CGPointMake(subw, _thumb.center.y);
    
    if(_isShowValue)
    {
        valueLabel.text = [NSString stringWithFormat:@"%ds", value];
        valueLabel.center  = CGPointMake(_thumb.center.x, valueLabel.center.y);
    }
    
    rc = _sliderFr.frame;
    rc.size.width = _thumb.center.x;
    _sliderFr.frame = rc;
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
