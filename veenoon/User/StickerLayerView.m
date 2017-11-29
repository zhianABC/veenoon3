//
//  StickerLayerView.m
//  APoster
//
//  Created by chen jack on 12-10-28.
//  Copyright (c) 2012年 chen jack. All rights reserved.
//

#import "StickerLayerView.h"
#import <QuartzCore/QuartzCore.h>

#define D_F_SIZE        40

@implementation StickerLayerView
@synthesize delegate_;
@synthesize _element;
@synthesize selectedImg;
@synthesize normalImg;


- (void)dealloc
{
    
}


- (void) selected{
    
    
    _sticker.image = selectedImg;
    _stickerCopy.image = selectedImg;
    

}
- (void) unselected{
    
    _sticker.image = normalImg;
    _stickerCopy.image = normalImg;
    
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        _sticker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 frame.size.width,
                                                                 frame.size.height)];

        [self addSubview:_sticker];
        _sticker.layer.contentsGravity = kCAGravityCenter;
        
        _stickerCopy = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     frame.size.width,
                                                                     frame.size.height)];
        
        [self addSubview:_stickerCopy];
        _stickerCopy.layer.contentsGravity = kCAGravityCenter;
        _stickerCopy.alpha = 0;
    }
    return self;
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

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    isZooming = NO;
    isMoving = NO;
    
    [[self superview] bringSubviewToFront:self];
    
    if([delegate_ respondsToSelector:@selector(didBeginTouchedStickerLayer:)]){
        [delegate_ didBeginTouchedStickerLayer:self];
    }
    
    [self selected];
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
    isMoving = YES;
    
	NSSet *allTouches = [event allTouches];
    switch ([allTouches count])
    {
        case 1:
        {
			UITouch* touch = [touches anyObject];
			CGPoint previous = [touch previousLocationInView:self.superview];
			CGPoint current = [touch locationInView:self.superview];
            CGPoint offset = CGPointMake(current.x - previous.x, current.y - previous.y);
            
            if(isMoving){
                
                _stickerCopy.alpha = 0.5;
                
                float ncx= _stickerCopy.center.x+offset.x;
                float ncy = _stickerCopy.center.y+offset.y;
                
                _stickerCopy.center = CGPointMake(ncx, ncy);
                
                
                
            }
            
		}
            break;
    }
	
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	
	isZooming = NO;
	
    if([delegate_ respondsToSelector:@selector(didEndTouchedStickerLayer:)]){
        [delegate_ didEndTouchedStickerLayer:_stickerCopy];
    }
    
    if(!isMoving)
    {
        if([delegate_ respondsToSelector:@selector(didTappedStickerLayer:)]){
            [delegate_ didTappedStickerLayer:self];
        }
    }
    
    
    [UIView beginAnimations:nil context:nil];
    _stickerCopy.center = _sticker.center;
    [UIView commitAnimations];
 
    
    [self unselected];
}



- (void) setSticker:(NSString*)sticker{
    
    UIImage *img = [UIImage imageNamed:sticker];
    _sticker.image = img;
    _sticker.frame  = self.bounds;
    
    self.normalImg = img;
    
    _stickerCopy.image = img;
     _stickerCopy.frame  = self.bounds;
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
