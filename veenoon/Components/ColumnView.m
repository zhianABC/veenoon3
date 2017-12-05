//
//  ColumnView.m
//  veenoon
//
//  Created by chen jack on 2017/12/5.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "ColumnView.h"

@interface ColumnView ()
{
    UIImageView *_val;
}
@end

@implementation ColumnView
@synthesize borderColor;
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
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 1;
        
        _val = [[UIImageView alloc] initWithFrame:self.bounds];
        _val.backgroundColor = [UIColor greenColor];
        [self addSubview:_val];
    }
    
    return self;
}

- (void) setHValue:(float)value{
    
    int h = value * self.frame.size.height;
    int w = self.frame.size.width;
    
    if(borderColor)
    {
        self.layer.borderColor = borderColor.CGColor;
        _val.backgroundColor = borderColor;
    }
    
    _val.frame = CGRectMake(0, self.frame.size.height-h, w, h);
    
}

@end
