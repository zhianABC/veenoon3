//
//  IconTextButton.m
//  CMAForiPad
//
//  Created by jack on 2/28/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import "IconCenterTextButton.h"

@interface IconCenterTextButton ()
{
    
}
@property (nonatomic, strong) UIImage *_selImg;
@property (nonatomic, strong) UIImage *_normalImg;
@property (nonatomic, strong) UIColor *_normalColor;
@property (nonatomic, strong) UIColor *_selColor;
@end

@implementation IconCenterTextButton
@synthesize _selImg;
@synthesize _normalImg;
@synthesize _normalColor;
@synthesize _selColor;
@synthesize _titleL;

@synthesize vdata;


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void) buttonWithIcon:(UIImage*)normalIcon selectedIcon:(UIImage*)sIcon text:(NSString*)text normalColor:(UIColor*) normalColor
               selColor:(UIColor*)selColor {
    
    self._normalImg = normalIcon;
    self._selImg = sIcon;
    self._selColor = selColor;
    self._normalColor = normalColor;
    
    _icon = [[UIImageView alloc] initWithImage:normalIcon];
    [self addSubview:_icon];
    _icon.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height - 30)/2);
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                        self.frame.size.height - 30,
                                                        self.frame.size.width, 20)];
    _titleL.backgroundColor = [UIColor clearColor];
    _titleL.font = [UIFont systemFontOfSize:15];
    _titleL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleL];
    _titleL.textColor = _normalColor;
    _titleL.text = text;
    
    [self addTarget:self action:@selector(touchDown:)
   forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside:)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUpOutside:)
   forControlEvents:UIControlEventTouchUpOutside];
    
    [self addTarget:self action:@selector(touchUpOutside:)
   forControlEvents:UIControlEventTouchCancel];
}
- (void) touchDown:(id)sender{
    _icon.image = _selImg;
    _titleL.textColor = _selColor;
}
- (void) touchUpInside:(id)sender{
    _icon.image = _normalImg;
    _titleL.textColor = _normalColor;
}
- (void) touchUpOutside:(id)sender{
    _icon.image = _normalImg;
    _titleL.textColor = _normalColor;
}

- (void) setBtnHighlited:(BOOL)isSel {
    if (isSel) {
        _icon.image = _selImg;
        _titleL.textColor = _selColor;
    } else {
        _icon.alpha = 1;
        _titleL.alpha = 1;
        _icon.image = _normalImg;
        _titleL.textColor = _normalColor;
    }
}

- (void) setBtnAlpha:(float)alpha{
    
    _icon.alpha = alpha;
    _titleL.alpha = alpha;
}

@end

