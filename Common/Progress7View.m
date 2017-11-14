//
//  ProgressView.m
//  ZhiHui_CR
//
//  Created by jack on 7/11/14.
//
//

#import "Progress7View.h"

@implementation Progress7View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.backgroundColor = [UIColor colo]
        
        self.backgroundColor = [UIColor clearColor];
        
        progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        progressBar.backgroundColor = THEME_COLOR_A(0.5);
        [self addSubview:progressBar];
        
        _progressL = [[UILabel alloc] initWithFrame:self.bounds];
        _progressL.backgroundColor = [UIColor clearColor];
        _progressL.textAlignment = NSTextAlignmentRight;
        _progressL.textColor = [UIColor redColor];
        [self addSubview:_progressL];
        _progressL.font = [UIFont boldSystemFontOfSize:16];
    }
    return self;
}

- (id) initWithProgressBar{

    CGRect frame = CGRectMake(0, 0, 300, 40);
    
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        
        progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 0, frame.size.height-12)];
        progressBar.backgroundColor = THEME_COLOR_A(0.8);
        [self addSubview:progressBar];
        progressBar.clipsToBounds = YES;
        progressBar.layer.cornerRadius = 6;
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress_biankuang.png"]];
        [self addSubview:bg];
        
        _progressL = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 6, 0)];
        _progressL.backgroundColor = [UIColor clearColor];
        _progressL.textAlignment = NSTextAlignmentCenter;
        _progressL.textColor = [UIColor redColor];
        [self addSubview:_progressL];
        _progressL.alpha  = 0.8;
        _progressL.font = M_FONT(13);
    }
 
    return self;
}

- (void) setProgress:(float)value{
    
    
    CGRect rc  = progressBar.frame;
    rc.size.width = value*self.frame.size.width;
    rc.origin.x = 0;
    
    progressBar.frame = rc;
    
    if(value <= 0.0001)
        _progressL.hidden = YES;
    else
        _progressL.hidden = NO;
    
    _progressL.text = [NSString stringWithFormat:@"%0.0f%%", value*100];
    _progressL.textColor = THEME_COLOR;
    
}

- (void) errorFlag{
    
    _progressL.text = @"网络中断";
   // _progressL.font = M_FONT(13);
    _progressL.textColor = RGB(88, 11, 106);
}

- (void) prepare
{
    _progressL.hidden = NO;

    //_progressL.font = M_FONT(15);
    _progressL.text = @"排队中";
    _progressL.textColor  = COLOR_TEXT_B;
}

- (void) updateProgressBar:(float) value{
    
    CGRect rc  = progressBar.frame;
    rc.size.width = value*(self.frame.size.width-12);
    
    [UIView beginAnimations:nil context:nil];
    progressBar.frame = rc;
    [UIView commitAnimations];
    
    if(value <= 0.0)
    {
        _progressL.text = @"加载中...";
    }
    else
    {
        _progressL.text = [NSString stringWithFormat:@"加载中...%0.0f%%", value*100];
    }
    
    
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
