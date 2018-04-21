//
//  PlugsCtrlTitleHeader.m
//  veenoon
//
//  Created by chen jack on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "PlugsCtrlTitleHeader.h"

@interface PlugsCtrlTitleHeader ()
{
    UILabel *_nameL;
    UIImageView *_icon;
}
@end

@implementation PlugsCtrlTitleHeader

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
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _nameL.textColor = [UIColor whiteColor];
        _nameL.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameL];
        
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"]];
        [self addSubview:_icon];
        
        _nameL.center = CGPointMake(_nameL.center.x, _nameL.center.y);
        _icon.center = CGPointMake(CGRectGetMaxX(_nameL.frame), _nameL.center.y);
    }
    
    return self;
}

- (void) setShowText:(NSString*)text{
    
    _nameL.text = text;
    
    CGSize s = [_nameL.text sizeWithAttributes:@{NSFontAttributeName:_nameL.font}];
    
    CGRect rc = _nameL.frame;
    rc.size.width = s.width+5;
    
    _nameL.frame = rc;
    
    _icon.center = CGPointMake(CGRectGetMaxX(_nameL.frame)+10, _nameL.center.y);
    
    rc = self.frame;
    rc.size.width = CGRectGetMaxX(_icon.frame)+10;
    self.frame = rc;
}

@end
