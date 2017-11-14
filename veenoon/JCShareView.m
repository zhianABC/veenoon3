//
//  JCShareView.m
//  Gemini
//
//  Created by jack on 1/29/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import "JCShareView.h"
#import "UIButton+Color.h"


@interface JCShareView ()
{
    
}
@end

@implementation JCShareView
@synthesize delegate_;

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
        
        
        
        UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 152)];
        content.backgroundColor = [UIColor whiteColor];
        [self addSubview:content];
        content.layer.cornerRadius = 5;
        content.clipsToBounds = YES;
        
        content.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        
        UIButton *btnOK = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btnOK.frame = CGRectMake(0, 0, CGRectGetWidth(content.frame), 50);
        [content addSubview:btnOK];
        [btnOK setTitle:@"相机" forState:UIControlStateNormal];
        btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btnOK setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(content.frame), 1)];
        line.backgroundColor = LINE_COLOR;
        [content addSubview:line];
        
        UIButton *btn2 = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btn2.frame = CGRectMake(0, 51, CGRectGetWidth(content.frame), 50);
        [content addSubview:btn2];
        [btn2 setTitle:@"相册" forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn2 setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 101, CGRectGetWidth(content.frame), 1)];
        line.backgroundColor = LINE_COLOR;
        [content addSubview:line];
        
        UIButton *btn3 = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btn3.frame = CGRectMake(0, 102, CGRectGetWidth(content.frame), 50);
        [content addSubview:btn3];
        [btn3 setTitle:@"取消" forState:UIControlStateNormal];
        btn3.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn3 setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void) cancelAction:(id)sender{
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didTouchJCActionButtonIndex:)])
    {
        [delegate_ didTouchJCActionButtonIndex:99];
    }
    
    [self stopAction:nil];
}

- (void) cameraAction:(id)sender{
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didTouchJCActionButtonIndex:)])
    {
        [delegate_ didTouchJCActionButtonIndex:0];
    }
    
    [self stopAction:nil];
}

- (void) photoAction:(id)sender{
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didTouchJCActionButtonIndex:)])
    {
        [delegate_ didTouchJCActionButtonIndex:1];
    }
    
    [self stopAction:nil];
}



- (void) flashIcon{
    
   

}

- (void) animatedShow
{
    self.alpha = 0.0;

    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         self.alpha = 1.0;
                         
                
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}

- (void) flyAnimatedShow
{
    self.alpha = 0.0;
    
    
    //[self flashIcon];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         self.alpha = 1.0;
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}

- (void) stopAction:(id)sender{
    

    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}


- (void) confirmSharePoint{
    
    
   
    
}


@end
