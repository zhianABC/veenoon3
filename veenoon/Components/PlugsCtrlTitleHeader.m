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
    UILabel *_nameL1;
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
        
        _nameL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _nameL1.textColor = [UIColor whiteColor];
        _nameL1.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameL1];
        _nameL1.hidden = YES;
        
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"]];
        [self addSubview:_icon];
        
        _nameL.center = CGPointMake(_nameL.center.x, _nameL.center.y);
        _icon.center = CGPointMake(CGRectGetMaxX(_nameL.frame), _nameL.center.y);
        
        _icon.hidden = YES;
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void) setShowText:(NSString*)text{
    
    
    if([_nameL.text length] && ![_nameL.text isEqualToString:text])
    {
        _nameL1.hidden = NO;
        
        _nameL1.text = _nameL.text;
        _nameL1.frame = _nameL.frame;
        
        CGRect rc = _nameL1.frame;
        rc.origin.y = -50;
        
        
        _nameL.text = text;
        CGSize s = [_nameL.text sizeWithAttributes:@{NSFontAttributeName:_nameL.font}];
        CGRect rc1 = _nameL.frame;
        rc1.size.width = s.width+5;
        _nameL.frame = rc1;
        _nameL.center = CGPointMake(_nameL.center.x, CGRectGetHeight(self.bounds));
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             _nameL1.frame = rc;
                             _nameL1.alpha = 0;
                             _nameL.center = CGPointMake(_nameL.center.x, CGRectGetMidY(self.bounds));
                         } completion:^(BOOL finished) {
                             
                             _nameL1.hidden = YES;
                             _nameL1.alpha = 1;
                         }];
    }
    else
    {
        _nameL.text = text;
        CGSize s = [_nameL.text sizeWithAttributes:@{NSFontAttributeName:_nameL.font}];
        CGRect rc = _nameL.frame;
        rc.size.width = s.width+5;
        _nameL.frame = rc;
        
    }

    _icon.center = CGPointMake(CGRectGetMaxX(_nameL.frame)+10, _nameL.center.y);
    
    if([text length] > 0)
        _icon.hidden = NO;
    else
        _icon.hidden = YES;
    
    CGRect rc = self.frame;
    rc.size.width = CGRectGetMaxX(_icon.frame)+10;
    self.frame = rc;
}

@end
