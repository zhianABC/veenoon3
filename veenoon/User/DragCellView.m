//
//  DragCellView.m
//  APoster
//
//  Created by chen jack on 12-10-28.
//  Copyright (c) 2012年 chen jack. All rights reserved.
//

#import "DragCellView.h"
#import <QuartzCore/QuartzCore.h>

#define D_F_SIZE        40

@interface DragCellView ()
{
    UILabel *_cptxtLabel;
}
@end

@implementation DragCellView
@synthesize delegate_;
@synthesize _element;
@synthesize selectedImg;
@synthesize normalImg;
@synthesize textLabel;
@synthesize _enableDrag;
@synthesize _resetWhenEndDrag;

- (void)dealloc
{
    
}


- (void) selected{
    
    
    _sticker.image = selectedImg;
    _stickerCopy.image = selectedImg;

    
    _isSelected = YES;

}
- (void) unselected{
    
    _isSelected = NO;
    
    _sticker.image = normalImg;
    _stickerCopy.image = normalImg;
    
    
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
        _sticker = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 frame.size.width,
                                                                 frame.size.height)];

        [self addSubview:_sticker];
        _sticker.layer.contentsGravity = kCAGravityResizeAspectFill;
        _sticker.clipsToBounds = YES;
        
        _sticker.layer.cornerRadius = 5;
        
        _stickerCopy = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                     frame.size.width,
                                                                     frame.size.height)];
        
        [self addSubview:_stickerCopy];
        _stickerCopy.layer.contentsGravity = kCAGravityResizeAspectFill;
        _stickerCopy.alpha = 0;
        _stickerCopy.clipsToBounds = YES;
        
        _stickerCopy.layer.cornerRadius = 5;
        
      self.textLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(0,
                                                   0,
                                                   frame.size.width, frame.size.height)];
        [self addSubview:textLabel];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = [UIColor whiteColor];
        
        _cptxtLabel = [[UILabel alloc]
                       initWithFrame:CGRectMake(0,
                                                0,
                                                frame.size.width, frame.size.height)];
        [_stickerCopy addSubview:_cptxtLabel];
        _cptxtLabel.textAlignment = NSTextAlignmentCenter;
        _cptxtLabel.font = [UIFont systemFontOfSize:15];
        _cptxtLabel.textColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void) setTitleTxt:(NSString*)txt{
    
    textLabel.text = txt;
    _cptxtLabel.text = txt;
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
    
    isMoving = NO;
    
    [[self superview] bringSubviewToFront:self];
    
    if([delegate_ respondsToSelector:@selector(didBeginTouchedStickerLayer:)]){
        [delegate_ didBeginTouchedStickerLayer:self];
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
    
    if(!_enableDrag)
        return;
    
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
                
                //NSLog(@"%f, %f", ncx, ncy);
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
    
    
    if(!_resetWhenEndDrag)
    {
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _stickerCopy.alpha = 0;
                             
                             
                         } completion:^(BOOL finished) {
                            
                             _stickerCopy.center = _sticker.center;
                             
                             [self unselected];
                         }];
    }
    else
    {
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _stickerCopy.center = _sticker.center;
                         
                         
                     } completion:^(BOOL finished) {
                         _stickerCopy.alpha = 0;
                         [self unselected];
                     }];
    }
    
   
}



- (void) draw{
    

    _sticker.image = normalImg;
    _stickerCopy.image = selectedImg;
    
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
