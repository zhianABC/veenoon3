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
    
    BOOL _enabledTouchMove;

    BOOL _isMoved;
    
    UILabel *_titleLabel;
    UILabel *_valueLabel;
}
@end

@implementation SlideButton
@synthesize delegate;
@synthesize _titleLabel;
@synthesize _valueLabel;

@synthesize _grayBackgroundImage;
@synthesize _lightBackgroundImage;

@synthesize data;
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
        _radioImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_btn_gray.png"]];
        [self addSubview:_radioImgV];
        _radioImgV.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
     
        
        progress = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self addSubview:progress];
        [progress setProgressBolder:4];
        
        progress._isShowingPoint = YES;
        [progress setProgress:0];
        progress.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2);
        
        _vheight = frame.size.height;
        
        _enabledTouchMove = NO;
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont boldSystemFontOfSize:11];
        _titleLabel.textColor  = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-30,
                                                                CGRectGetHeight(frame)-20,
                                                                60, 20)];
        _valueLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_valueLabel];
        _valueLabel.font = [UIFont boldSystemFontOfSize:11];
        _valueLabel.textColor  = [UIColor whiteColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray.png"];
        self._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light.png"];
        
    }
    
    return self;
}
-(void) setTitle:(NSString*)title {
    _titleLabel.text = title;
}
-(void) setvalueTitle:(NSString*)title {
    _valueLabel.text = title;
}

- (void) enableValueSet:(BOOL)enabled{
    
    if(enabled)
    {
        _enabledTouchMove = YES;
        _titleLabel.textColor = YELLOW_COLOR;
        _radioImgV.image = _lightBackgroundImage;
    }
    else
    {
        _enabledTouchMove = NO;
        _titleLabel.textColor = [UIColor whiteColor];
        _radioImgV.image = _grayBackgroundImage;
    }
}

- (void) changToIcon:(UIImage*)iconImg{
    
    if(iconImg == nil)
    {
        if(_iconImgV)
            [_iconImgV removeFromSuperview];
        
        //_radioImgV.hidden = NO;
        //progress.hidden = NO;
        
        return;
    }
    
    if(_iconImgV == nil){
        _iconImgV = [[UIImageView alloc] initWithFrame:_radioImgV.frame];
        _iconImgV.layer.contentsGravity = kCAGravityCenter;
    }
    [self addSubview:_iconImgV];
    _iconImgV.image = iconImg;
    
    //_radioImgV.hidden = YES;
    //progress.hidden = YES;
    
}

- (void) changeButtonBackgroundImage:(UIImage *)image{
    
    _radioImgV.image = image;
}

- (void) setCircleValue:(float) value{
    
    [progress setProgress:value];
}

- (void) muteSlider:(BOOL)mute{
    
    if(mute)
    {
        progress.progressColor = THEME_RED_COLOR;
        [progress setNeedsDisplay];
    }
    else
    {
        progress.progressColor = RGB(242, 148, 20);
        [progress setNeedsDisplay];
    }
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    _isMoved = NO;
    
    if(progress.hidden)
        return;
    
    if(!_enabledTouchMove)
        return;
    
    CGPoint p = [[touches anyObject] locationInView:self];
    
    _beginPoint = p;
    
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    _isMoved = YES;
    
    if(progress.hidden)
        return;
    
    if(!_enabledTouchMove)
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
    
    if(delegate && [delegate respondsToSelector:@selector(didSlideButtonValueChanged:slbtn:)])
    {
        [delegate didSlideButtonValueChanged:[progress pgvalue] slbtn:self];
    }
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if(!_isMoved)
    {
        if(delegate && [delegate respondsToSelector:@selector(didTappedMSelf:)])
        {
            [delegate didTappedMSelf:self];
        }
    }
    
    if(progress.hidden)
        return;
    
    if(!_enabledTouchMove)
        return;
    
    [progress syncCurrentStepedValue];
    
//    if(delegate && [delegate respondsToSelector:@selector(didSlideButtonValueChanged:slbtn:)])
//    {
//        [delegate didSlideButtonValueChanged:[progress pgvalue] slbtn:self];
//    }
    
    if(delegate && [delegate respondsToSelector:@selector(didEndSlideButtonValueChanged:slbtn:)])
    {
        [delegate didEndSlideButtonValueChanged:[progress pgvalue] slbtn:self];
    }
}


@end
