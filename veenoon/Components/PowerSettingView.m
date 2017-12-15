//
//  PowerSettingView.m
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "PowerSettingView.h"
#import "JHSlideView.h"

@interface PowerSettingView ()
{
    UILabel *_secs;
    
    UIScrollView *_sliders;
}
@end

@implementation PowerSettingView

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
        
        self.backgroundColor = RGB(0, 89, 118);
        
       
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 1)];
        line.backgroundColor = RGB(1, 138, 182);
        [self addSubview:line];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, frame.size.width, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        titleL.text = @"开机通道切换时间";
        
        _secs = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, frame.size.width-50, 20)];
        _secs.backgroundColor = [UIColor clearColor];
        [self addSubview:_secs];
        _secs.textAlignment = NSTextAlignmentRight;
        _secs.font = [UIFont systemFontOfSize:13];
        _secs.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        _secs.text = @"1s";
        
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(_secs.frame)+5, 75, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [self addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        
        
        _sliders = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                            100,
                                                            frame.size.width,
                                                            frame.size.height-100)];
        [self addSubview:_sliders];
        
    }
    return self;
}

- (void) show8Labs{
    
    [[_sliders subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int xx = 15;
    int yy = 10;
    for(int i = 0; i < 8; i++)
    {
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, 50, 50)];
        tL.backgroundColor = [UIColor clearColor];
        [_sliders addSubview:tL];
        tL.font = [UIFont boldSystemFontOfSize:14];
        tL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        tL.text = [NSString stringWithFormat:@"%d", i+1];
        
        JHSlideView *slider = [[JHSlideView alloc] initWithSliderBg:nil
                                                              frame:CGRectMake(xx+40,
                                                                               yy,
                                                                               230,
                                                                               50)];
        [_sliders addSubview:slider];
        slider.minValue = 1;
        slider.maxValue = 180;
        [slider setScaleValue:1];
        
        yy+=50;
        
    }
    
    _sliders.contentSize = CGSizeMake(_sliders.frame.size.width, yy);
}

- (void) show16Labs{
    
    [[_sliders subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int xx = 15;
    int yy = 10;
    for(int i = 0; i < 16; i++)
    {
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, 50, 50)];
        tL.backgroundColor = [UIColor clearColor];
        [_sliders addSubview:tL];
        tL.font = [UIFont boldSystemFontOfSize:14];
        tL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        tL.text = [NSString stringWithFormat:@"%d", i+1];
        
        JHSlideView *slider = [[JHSlideView alloc] initWithSliderBg:nil
                                                              frame:CGRectMake(xx+40,
                                                                               yy,
                                                                               230,
                                                                               50)];
        [_sliders addSubview:slider];
        slider.minValue = 1;
        slider.maxValue = 180;
        [slider setScaleValue:1];
        
        yy+=50;
        
    }
    
    _sliders.contentSize = CGSizeMake(_sliders.frame.size.width, yy);
}

@end
