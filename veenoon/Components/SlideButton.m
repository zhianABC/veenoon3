//
//  SlideButton.m
//  veenoon
//
//  Created by chen jack on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SlideButton.h"
#import "CircleProgressView.h"

@interface SlideButton ()
{
    UIImageView *_radioImgV;
    UIImageView *_iconImgV;
    CircleProgressView *progress;
    
    CGPoint _beginPoint;
    
    float _vheight;
}
@end

@implementation SlideButton
@synthesize delegate;

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
        _radioImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_btn.png"]];
        [self addSubview:_radioImgV];
        _radioImgV.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
     
        
        progress = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 57, 57)];
        [self addSubview:progress];
        [progress setProgressBolder:4];
        
        progress._isShowingPoint = YES;
        [progress setProgress:0.1];
        progress.center = CGPointMake(CGRectGetWidth(frame)/2, 52);
        
        _vheight = frame.size.height;
        
    }
    
    return self;
}

- (void) changToIcon:(UIImage*)iconImg{
    
    if(iconImg == nil)
    {
        if(_iconImgV)
            [_iconImgV removeFromSuperview];
        
        _radioImgV.hidden = NO;
        progress.hidden = NO;
        
        return;
    }
    
    if(_iconImgV == nil){
        _iconImgV = [[UIImageView alloc] initWithFrame:_radioImgV.frame];
        _iconImgV.layer.contentsGravity = kCAGravityResizeAspectFill;
    }
    [self addSubview:_iconImgV];
    _iconImgV.image = iconImg;
    
    _radioImgV.hidden = YES;
    progress.hidden = YES;
    
}

- (void) changeButtonBackgroundImage:(UIImage *)image{
    
    _radioImgV.image = image;
}

- (void) setCircleValue:(float) value{
    
    [progress setProgress:value];
}


-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if(progress.hidden)
        return;
    
    CGPoint p = [[touches anyObject] locationInView:self];
    
    _beginPoint = p;
    
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if(progress.hidden)
        return;
    
    NSSet *allTouches = [event allTouches];
    switch ([allTouches count])
    {
        case 1:
        {
            UITouch* touch = [touches anyObject];
            CGPoint previous = _beginPoint;
            CGPoint current = [touch locationInView:self];
            float pan = previous.y - current.y;
            float step = pan/_vheight;
            
            [progress stepProgress:step];
        }
            break;
    }
    
    if(delegate && [delegate respondsToSelector:@selector(didSlideButtonValueChanged:)])
    {
        [delegate didSlideButtonValueChanged:[progress pgvalue]];
    }
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if(progress.hidden)
        return;
    
    [progress syncCurrentStepedValue];
    
    if(delegate && [delegate respondsToSelector:@selector(didSlideButtonValueChanged:)])
    {
        [delegate didSlideButtonValueChanged:[progress pgvalue]];
    }
    
}


@end
