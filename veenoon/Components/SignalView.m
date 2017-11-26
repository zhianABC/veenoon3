//
//  SignalView.m
//  veenoon
//
//  Created by chen jack on 2017/11/26.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SignalView.h"

@interface SignalView ()
{
    UIImageView *_col1;
    UIImageView *_col2;
    UIImageView *_col3;
    UIImageView *_col4;
    UIImageView *_col5;
}
@property (nonatomic, strong) UIColor *_lightColor;
@property (nonatomic, strong) UIColor *_grayColor;

@end

@implementation SignalView
@synthesize _lightColor;
@synthesize _grayColor;

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        int space = 5;
        int w = (frame.size.width - space*6)/5;
    
        int x = space;
        
        int h = frame.size.height*0.2;
        _col1 = [[UIImageView alloc] initWithFrame:CGRectMake(x, frame.size.height - h, w, h)];
        [self addSubview:_col1];
        
        x+=w;
        x+=space;
        h = frame.size.height*0.4;
        _col2 = [[UIImageView alloc] initWithFrame:CGRectMake(x, frame.size.height - h, w, h)];
        [self addSubview:_col2];
        
        x+=w;
        x+=space;
        h = frame.size.height*0.6;
        _col3 = [[UIImageView alloc] initWithFrame:CGRectMake(x, frame.size.height - h, w, h)];
        [self addSubview:_col3];
        
        x+=w;
        x+=space;
        h = frame.size.height*0.8;
        _col4 = [[UIImageView alloc] initWithFrame:CGRectMake(x, frame.size.height - h, w, h)];
        [self addSubview:_col4];
        
        x+=w;
        x+=space;
        _col5 = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, w, frame.size.height)];
        [self addSubview:_col5];
    }
    return self;
}

- (void) setLightColor:(UIColor *)color{
    _col1.backgroundColor = color;
    _col2.backgroundColor = color;
    _col3.backgroundColor = color;
    _col4.backgroundColor = color;
    _col5.backgroundColor = color;
    
    self._lightColor = color;
}
- (void) setGrayColor:(UIColor *)color{
    self._grayColor = color;
}

- (void) setSignalValue:(int)value{
    
    switch (value) {
        case 1:
            _col1.backgroundColor = _lightColor;
            _col2.backgroundColor = _grayColor;
            _col3.backgroundColor = _grayColor;
            _col4.backgroundColor = _grayColor;
            _col5.backgroundColor = _grayColor;
            break;
        case 2:
            _col1.backgroundColor = _lightColor;
            _col2.backgroundColor = _lightColor;
            _col3.backgroundColor = _grayColor;
            _col4.backgroundColor = _grayColor;
            _col5.backgroundColor = _grayColor;
            break;
        case 3:
            _col1.backgroundColor = _lightColor;
            _col2.backgroundColor = _lightColor;
            _col3.backgroundColor = _lightColor;
            _col4.backgroundColor = _grayColor;
            _col5.backgroundColor = _grayColor;
            break;
        case 4:
            _col1.backgroundColor = _lightColor;
            _col2.backgroundColor = _lightColor;
            _col3.backgroundColor = _lightColor;
            _col4.backgroundColor = _lightColor;
            _col5.backgroundColor = _grayColor;
            break;
        case 5:
            _col1.backgroundColor = _lightColor;
            _col2.backgroundColor = _lightColor;
            _col3.backgroundColor = _lightColor;
            _col4.backgroundColor = _lightColor;
            _col5.backgroundColor = _lightColor;
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
