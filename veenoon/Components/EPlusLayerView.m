//
//  EPlusLayerView.m
//  APoster
//
//  Created by chen jack on 12-10-28.
//  Copyright (c) 2012年 chen jack. All rights reserved.
//

#import "EPlusLayerView.h"
#import <QuartzCore/QuartzCore.h>

#define D_F_SIZE        40

@implementation EPlusLayerView
@synthesize delegate_;
@synthesize _element;
@synthesize selectedImg;
@synthesize normalImg;
@synthesize textLabel;
@synthesize _enableDrag;
@synthesize _resetWhenEndDrag;
@synthesize detailLabel;

- (void)dealloc
{
    
}


- (void) selected{
    
    /*
    _sticker.image = selectedImg;
    _stickerCopy.image = selectedImg;

    textLabel.textColor = [UIColor orangeColor];
    detailLabel.textColor = [UIColor orangeColor];
    */
    
    self.backgroundColor = RGBA(253, 180, 0, 0.5);
    
    _isSelected = YES;

}
- (void) unselected{
    
    _isSelected = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    /*
    _sticker.image = normalImg;
    _stickerCopy.image = normalImg;
    
    textLabel.textColor = [UIColor whiteColor];
    detailLabel.textColor = [UIColor whiteColor];
    */
}
- (BOOL) getIsSelected{
    
    return _isSelected;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        _sticker = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [self addSubview:_sticker];
        _sticker.layer.contentsGravity = kCAGravityResizeAspect;
        
        
        _stickerCopy = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10,
                                                                     60,
                                                                     60)];
        
        [self addSubview:_stickerCopy];
        _stickerCopy.layer.contentsGravity = kCAGravityResizeAspect;
        _stickerCopy.alpha = 0;
        
        
        
        int xx = CGRectGetMaxX(_sticker.frame)+10;
        self.textLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(xx,
                                                   20,
                                                   frame.size.width-xx-10, 20)];
        [self addSubview:textLabel];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = [UIColor whiteColor];
        
        self.detailLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(xx,
                                                   40,
                                                   frame.size.width-xx-10, 20)];
        [self addSubview:detailLabel];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:15];
        detailLabel.textColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void) moveTitleToLeft {
    textLabel.frame = CGRectMake(15,
                                 40,
                                 self.frame.size.width-15-10, 20);
}

- (void) enableLongPressed {
    UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
    [self addGestureRecognizer:longPress0];
}

- (void) longPressed0:(id)sender {
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        if([delegate_ respondsToSelector:@selector(longPressed:)]){
            [delegate_ longPressed:self];
        }
    }
}

- (void) removeSelf{
    
    //CGAffineTransform f1 = CGAffineTransformMakeRotation(M_PI);
    CGAffineTransform f2 = CGAffineTransformMakeScale(0.2, 0.2);
    
    [UIView animateWithDuration:0.15
                     animations:(^(void){
        self.alpha = 0.0;
        self.transform  =f2;
        
    })
                     completion:(^(BOOL finished){
        
        if(finished){
            
            if([delegate_ respondsToSelector:@selector(didRemoveStickerLayer:)]){
                [delegate_ didRemoveStickerLayer:self];
            }
            [self removeFromSuperview];
            
            
        }
    })];
}

- (void) drawRect:(CGRect)rect
{
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 2012 && buttonIndex != alertView.cancelButtonIndex)
    {
        [UIView animateWithDuration:0.35
                         animations:(^(void){
            self.alpha = 0.0;
            
        })
                         completion:(^(BOOL finished){
            
            if(finished){
                
                
                [self removeFromSuperview];
                
                
            }
        })];
        
        
        
    }
    
}

- (BOOL) testClickedArea:(CGPoint )pt{
    
    CGRect rc = CGRectMake(0, 0,
                           self.frame.size.width*0.6,
                           self.frame.size.height);
    
    if(CGRectContainsPoint(rc, pt))
    {
        return YES;
    }
    return NO;
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    
    isMoving = NO;
    
    //[[self superview] bringSubviewToFront:self];
    
    if([delegate_ respondsToSelector:@selector(didBeginTouchedStickerLayer:sticker:)]){
        [delegate_ didBeginTouchedStickerLayer:self sticker:_sticker];
    }
    
    if(!_enableDrag)
    {
        if(_isSelected)
            [self unselected];
        else
            [self selected];
    }
    else
        [self selected];
    
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    NSSet *allTouches = [event allTouches];
    UITouch* touch = [touches anyObject];
    
    if(!_enableDrag)
        return;
    
    isMoving = YES;
    
    switch ([allTouches count])
    {
        case 1:
        {
			
			CGPoint previous = [touch previousLocationInView:self.superview];
			CGPoint current = [touch locationInView:self.superview];
            CGPoint offset = CGPointMake(current.x - previous.x, current.y - previous.y);
            
            if(isMoving){
                
                _stickerCopy.alpha = 0.5;
                
                float ncx= _stickerCopy.center.x+offset.x;
                float ncy = _stickerCopy.center.y+offset.y;
                
                _stickerCopy.center = CGPointMake(ncx, ncy);
                
                
                if([delegate_ respondsToSelector:@selector(didMovedStickerLayer:sticker:)]){
                    [delegate_ didMovedStickerLayer:self sticker:_stickerCopy];
                }
            }
            
		}
            break;
    }
	
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {

    
    
    if(!_enableDrag)
        return;
    
    
    if([delegate_ respondsToSelector:@selector(didEndTouchedStickerLayer:sticker:)]){
        [delegate_ didEndTouchedStickerLayer:self sticker:_stickerCopy];
    }
    
    if(!isMoving)
    {
        if([delegate_ respondsToSelector:@selector(didTappedStickerLayer:)]){
            [delegate_ didTappedStickerLayer:self];
        }
    }
    
    
    if(!_resetWhenEndDrag)
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _stickerCopy.alpha = 0;
                             
                             
                         } completion:^(BOOL finished) {
                            
                             _stickerCopy.center = CGPointMake(30+15, 18+15);
                             
                             [self unselected];
                         }];
    }
    else
    {
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _stickerCopy.center = CGPointMake(30+15, 18+15);
                         
                         
                     } completion:^(BOOL finished) {
                         _stickerCopy.alpha = 0;
                         [self unselected];
                     }];
    }
    
   
}

- (void) setSticker:(NSString*)sticker{
    
    UIImage *img = [UIImage imageNamed:sticker];
    _sticker.image = img;
    //_sticker.frame  = self.bounds;
    
    self.normalImg = img;
    
    _stickerCopy.image = img;
    // _stickerCopy.frame  = self.bounds;
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
