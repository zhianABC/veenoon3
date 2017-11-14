//
//  IconTextButton.m
//  CMAForiPad
//
//  Created by jack on 2/28/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import "IconTextButton.h"

@interface IconTextButton ()
{
    UIImageView *_icon;
    UILabel     *_titleL;
}
@property (nonatomic, strong) UIImage *_selImg;
@property (nonatomic, strong) UIImage *_normalImg;

@end

@implementation IconTextButton
@synthesize _selImg;
@synthesize _normalImg;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) buttonWithIcon:(UIImage*)normalIcon selectedIcon:(UIImage*)sIcon text:(NSString*)text{
    
    self._normalImg = normalIcon;
    self._selImg = sIcon;

    _icon = [[UIImageView alloc] initWithImage:normalIcon];
    [self addSubview:_icon];
    _icon.center = CGPointMake(_icon.center.x, 20);
    
   // float offsetx = self.frame.size.width - _normalImg.size.width;
    
    //[self setImage:normalIcon forState:UIControlStateNormal];
    //[self setImage:sIcon forState:UIControlStateHighlighted];
    //[self setImage:sIcon forState:UIControlStateSelected];
    
    //self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, offsetx);
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame),
                                                   0,
                                                   100, 40)];
    _titleL.backgroundColor = [UIColor clearColor];
    _titleL.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleL];
    _titleL.textColor = COLOR_TEXT_A;
    _titleL.text = text;
    
    [self addTarget:self action:@selector(touchDown:)
   forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside:)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUpOutside:)
   forControlEvents:UIControlEventTouchUpOutside];
}

- (void) touchDown:(id)sender{
    _icon.image = _selImg;
    _titleL.textColor = THEME_COLOR;
}
- (void) touchUpInside:(id)sender{
    _icon.image = _normalImg;
    _titleL.textColor = COLOR_TEXT_A;
}
- (void) touchUpOutside:(id)sender{
    _icon.image = _normalImg;
    _titleL.textColor = COLOR_TEXT_A;
}

@end
