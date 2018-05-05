//
//  CircleProgressView.m
//  test
//
//  Created by jack on 06/11/13.
//  Copyright (c) 2013 jack. All rights reserved.
//

#import "CircleProgressView.h"
#import <QuartzCore/QuartzCore.h>


@interface CircleProgressView ()
{
    float _startAngle;
    
    float _totalAngel;
    
    UIImageView *_blackpoint;
    UIImageView *_pointer;


}
@property (strong, nonatomic) UIColor *backColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat currentProgress;


@end

@implementation CircleProgressView
@synthesize textL;
@synthesize _isShowingPoint;

#define SPEED_30 0.05

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
        self.backgroundColor =[UIColor clearColor];
       
        _progress = 0;
        self.currentProgress = 0;
         
        self.backColor = [UIColor colorWithWhite:1.0 alpha:0.7];  //RGB(46, 105, 106);
        self.progressColor = RGB(242, 148, 20);
        self.lineWidth = 10;
        
        textL = [[UILabel alloc] initWithFrame:self.bounds];
        textL.backgroundColor = [UIColor clearColor];
        textL.font = [UIFont systemFontOfSize:12];
        textL.textColor = RGB(242, 148, 20);
        textL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:textL];
        
        _startAngle = - M_PI - 2*M_PI/6.0;
        _totalAngel = 2*M_PI - M_PI_2 + M_PI/6.0;
        
        int ww = frame.size.width - 18;
        _blackpoint = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_point.png"]];
        
        _pointer = [[UIImageView alloc] initWithFrame:CGRectMake(9,
                                                                 frame.size.height/2-3,
                                                                 ww, 6)];
        [_pointer addSubview:_blackpoint];
        _pointer.backgroundColor = [UIColor clearColor];
        _blackpoint.center = CGPointMake(ww - CGRectGetMidX(_blackpoint.frame), 3);
        //_pointer.layer.anchorPoint = CGPointMake(1, 0.5);
        
      
        [self addSubview:_pointer];
        
        _pointer.transform = CGAffineTransformMakeRotation(_startAngle);
        _pointer.hidden = YES;
    }
    return self;
}


- (void) setProgressBolder:(float)bolder{
    
    self.lineWidth = bolder;
}


- (void)drawRect:(CGRect)rect
{
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
                                                              radius:self.bounds.size.width / 2 - self.lineWidth / 2
                                                          startAngle:_startAngle
                                                            endAngle:_startAngle+_totalAngel
                                                           clockwise:YES];
    [self.backColor setStroke];
    backCircle.lineWidth = self.lineWidth;
    backCircle.lineCapStyle =  kCGLineCapRound;
    [backCircle stroke];
    
    if (self.currentProgress != 0) {
        //draw progress circle
        
        float endangel = (CGFloat)(_startAngle + self.currentProgress * _totalAngel);
        
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:
                                        CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
                                                                      radius:self.bounds.size.width / 2 - self.lineWidth / 2
                                                                  startAngle:_startAngle
                                                                    endAngle:endangel
                                                                   clockwise:YES];
        [self.progressColor setStroke];
        progressCircle.lineWidth = self.lineWidth;
        progressCircle.lineCapStyle =  kCGLineCapRound;
        [progressCircle stroke];
        
        
        if(_isShowingPoint)
            _pointer.transform = CGAffineTransformMakeRotation(endangel);
    }
}



- (void) setProgress:(float)progress{
    
    _progress = progress;
    
    _pointer.hidden = !_isShowingPoint;
    
   // textL.text = [NSString stringWithFormat:@"%d%%",(int)(_progress*100)];
    
    self.currentProgress = _progress;
    [self setNeedsDisplay];
    
}

- (void) stepProgress:(float)step{
    
     self.currentProgress = _progress+step;
    if(self.currentProgress < 0)
        self.currentProgress = 0;
    if(self.currentProgress > 1.0)
        self.currentProgress = 1.0;
    
    [self setNeedsDisplay];
}
- (void) syncCurrentStepedValue{
    
    _progress = self.currentProgress;
}

- (void) updateOffest:(float)offset{
    
    _progress = offset;
    
    self.currentProgress = _progress;
    [self setNeedsDisplay];
}

- (void) smallRefreshMode{
    self.lineWidth = 1;
    self.backColor = [UIColor clearColor];
    
}

- (float) pgvalue{

    return self.currentProgress;
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
