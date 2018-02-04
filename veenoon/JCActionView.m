//
//  JCActionView.m
//  Gemini
//
//  Created by jack on 1/29/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import "JCActionView.h"
#import "UIButton+Color.h"
#import "UILabel+ContentSize.h"

@interface JCActionView ()
{
    UIView *content;
}
@end

@implementation JCActionView
@synthesize delegate_;
@synthesize _clickeTxt;


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
        
        content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156)];
        content.backgroundColor = [UIColor whiteColor];
        [self addSubview:content];
        
        self.backgroundColor = RGBA(0, 0, 0, 0.8);
        
        UIButton *btnOK = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btnOK.frame = CGRectMake(0, 0, CGRectGetWidth(content.frame), 50);
        [content addSubview:btnOK];
        [btnOK setTitle:@"直接拍照" forState:UIControlStateNormal];
        btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btnOK setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btnOK addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(content.frame), 1)];
        line.backgroundColor = LINE_COLOR;
        [content addSubview:line];
        
        UIButton *btn2 = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btn2.frame = CGRectMake(0, 51, CGRectGetWidth(content.frame), 50);
        [content addSubview:btn2];
        [btn2 setTitle:@"从相册中选取" forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn2 setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 101, CGRectGetWidth(content.frame), 5)];
        line.backgroundColor = RGB(0xf2, 0xf2, 0xf2);
        [content addSubview:line];
        
        UIButton *btnCancel = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btnCancel.frame = CGRectMake(0, 106, CGRectGetWidth(content.frame), 50);
        [content addSubview:btnCancel];
        [btnCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btnCancel setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return self;
}

- (id)initWithTitles:(NSArray*)titles frame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame])
    {
        
        int h = (int)[titles count]*51 - 1 + 55;
        
        content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        content.backgroundColor = [UIColor whiteColor];
        [self addSubview:content];
    
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        
        int top = 0;
        int tagIdx = 0;
        for(NSString *til in titles)
        {
            UIButton *btnOK = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
            btnOK.frame = CGRectMake(0, top, CGRectGetWidth(content.frame), 50);
            [content addSubview:btnOK];
            [btnOK setTitle:til forState:UIControlStateNormal];
            btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btnOK setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
            [btnOK addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            btnOK.tag = tagIdx;
            tagIdx++;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnOK.frame)+1, CGRectGetWidth(content.frame), 1)];
            line.backgroundColor = LINE_COLOR;
            [content addSubview:line];
            
            
            top = CGRectGetMaxY(line.frame);
            
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, top-1, CGRectGetWidth(content.frame), 5)];
        line.backgroundColor = RGB(0xf2, 0xf2, 0xf2);
        [content addSubview:line];
        
        UIButton *btnCancel = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btnCancel.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(content.frame), 50);
        [content addSubview:btnCancel];
        [btnCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btnCancel setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return self;
}

- (id)initWithTils:(NSArray*)tils frame:(CGRect)frame title:(NSString *)title{
    
    if(self = [super initWithFrame:frame])
    {
        
        int h = (int)[tils count]*51 - 1 + 55;
        
        content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        content.backgroundColor = [UIColor whiteColor];
        [self addSubview:content];
        
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH-20, 20)];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = title;
        titleL.textColor = COLOR_TEXT_A;
        [content addSubview:titleL];
        [titleL contentSize];
        
        int top = CGRectGetMaxY(titleL.frame)+10;
        
        h+=top;
        content.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
        
        int tagIdx = 0;
        for(NSString *til in tils)
        {
            UIButton *btnOK = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
            btnOK.frame = CGRectMake(0, top, CGRectGetWidth(content.frame), 50);
            [content addSubview:btnOK];
            [btnOK setTitle:til forState:UIControlStateNormal];
            btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btnOK setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
            [btnOK addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            btnOK.tag = tagIdx;
            tagIdx++;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnOK.frame)+1, CGRectGetWidth(content.frame), 1)];
            line.backgroundColor = LINE_COLOR;
            [content addSubview:line];
            
            
            top = CGRectGetMaxY(line.frame);
            
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, top-1, CGRectGetWidth(content.frame), 5)];
        line.backgroundColor = RGB(0xf2, 0xf2, 0xf2);
        [content addSubview:line];
        
        UIButton *btnCancel = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
        btnCancel.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(content.frame), 50);
        [content addSubview:btnCancel];
        [btnCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btnCancel setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return self;
}

- (void) buttonAction:(UIButton*)btn{

    if(delegate_ && [delegate_ respondsToSelector:@selector(didJCActionButtonIndex:actionView:)])
    {
        [delegate_ didJCActionButtonIndex:(int)btn.tag actionView:self];
    }
    
    [self stopAction:nil];
}


- (void) cameraAction:(id)sender{
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didJCActionButtonIndex:actionView:)])
    {
        [delegate_ didJCActionButtonIndex:0 actionView:self];
    }
    
    [self stopAction:nil];
}

- (void) photoAction:(id)sender{
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didJCActionButtonIndex:actionView:)])
    {
        [delegate_ didJCActionButtonIndex:1 actionView:self];
    }
    
    [self stopAction:nil];
}



- (void) flashIcon{
    
   

}

- (void) animatedShow
{
    self.alpha = 0.0;
    
    int h = CGRectGetHeight(content.frame);
    content.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, h);

    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         self.alpha = 1.0;
                         content.frame = CGRectMake(0, SCREEN_HEIGHT-h, SCREEN_WIDTH, h);
                
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
