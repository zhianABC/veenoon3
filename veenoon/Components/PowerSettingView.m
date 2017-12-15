//
//  PowerSettingView.m
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "PowerSettingView.h"

@interface PowerSettingView ()
{
    UILabel *_secs;
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
        
    }
    return self;
}

@end
