//
//  ColumnsView.m
//  veenoon
//
//  Created by chen jack on 2017/11/21.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "ColumnsView.h"

@interface ColumnsView ()
{
    UILabel *xLine;
    UILabel *yLine;
    
    int leftEdage;
    int bottomEdage;
    int topEdage;
    
    UILabel *_xNameL;
    UILabel *_yNameL;
    
    UIView *_drawView;

}
@end

@implementation ColumnsView

@synthesize xStepPixel;
@synthesize yStepPixel;
@synthesize yStepValues;
@synthesize xStepValues;
@synthesize yName;
@synthesize xName;
@synthesize _themeColor;
@synthesize colValues;
@synthesize colWidth;
@synthesize maxColValue;

- (void) initXY{
    
    leftEdage = 80;
    bottomEdage = 40;
    topEdage = 40;
    
    self.backgroundColor = [UIColor clearColor];
    
    int h = yStepPixel * ((int)[yStepValues count]-1) + bottomEdage + topEdage;
    int w = xStepPixel * (int)[xStepValues count] + leftEdage + 40;
    
    
    
    yLine = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage, 0, 1, h-bottomEdage)];
    yLine.backgroundColor = _themeColor;
    [self addSubview:yLine];
    
    xLine = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage, h-40, w-leftEdage, 1)];
    xLine.backgroundColor = _themeColor;
    [self addSubview:xLine];
    
    int topForX = h - bottomEdage;
    
    int xx = 80+xStepPixel;
    for(NSString * xv in xStepValues){
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx, topForX, 1, 14)];
        kdl.backgroundColor = _themeColor;
        [self addSubview:kdl];
        
        UILabel *xLName = [[UILabel alloc] initWithFrame:CGRectMake(xx-20, topForX+14, 40, 20)];
        xLName.text = xv;
        xLName.textColor  = _themeColor;
        xLName.textAlignment = NSTextAlignmentCenter;
        xLName.font = [UIFont systemFontOfSize:14];
        [self addSubview:xLName];
        
        xx+=xStepPixel;
    }
    
    //从0开始，0抬起10 pixel
    int topForY = h - bottomEdage - 10;
    
    for(NSString * yv in yStepValues){
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(80 - 14,
                                                                 topForY, 14, 1)];
        kdl.backgroundColor = _themeColor;
        [self addSubview:kdl];
        
        UILabel *yLName = [[UILabel alloc] initWithFrame:CGRectMake(80-40-14,
                                                                    topForY-10, 20, 20)];
        yLName.text = yv;
        yLName.textAlignment = NSTextAlignmentCenter;
        yLName.font = [UIFont systemFontOfSize:14];
        yLName.textColor = _themeColor;
        [self addSubview:yLName];
        yLName.backgroundColor = [UIColor clearColor];
        
        topForY-=yStepPixel;
    }
    
    
    _xNameL = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage-15,
                                                        CGRectGetMaxY(xLine.frame)+5,
                                                        xStepPixel+20,
                                                        20)];
    _xNameL.textColor = [UIColor whiteColor];
    _xNameL.textAlignment = NSTextAlignmentCenter;
    _xNameL.font = [UIFont systemFontOfSize:13];
    [self addSubview:_xNameL];
    
    _xNameL.text = xName;
    
    _yNameL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                        0,
                                                        leftEdage-10,
                                                        20)];
    _yNameL.textColor = [UIColor whiteColor];
    _yNameL.textAlignment = NSTextAlignmentRight;
    _yNameL.font = [UIFont systemFontOfSize:13];
    [self addSubview:_yNameL];
    
    _yNameL.text = yName;
    
    CGRect rc = self.frame;
    rc.size.width = w;
    rc.size.height = h;
    self.frame = rc;
    
    
    _drawView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_drawView];
    
}
- (void) draw{
    
    [[_drawView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //原点(leftEdage, h-bottomEdage-20)
    
    int h = self.frame.size.height;
 
    int maxYForX = h - bottomEdage - 10;
    int xx = leftEdage+xStepPixel;
    
    int mValue = h - bottomEdage - topEdage;
    
    for(NSString * xv in colValues){
        
        float v = [xv floatValue];
        int temp = v*mValue/maxColValue;
        
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx-colWidth/2,
                                                                 maxYForX-temp,
                                                                 colWidth, temp)];
        kdl.backgroundColor = _themeColor;
        [_drawView addSubview:kdl];
        
    
        UILabel *LName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(kdl.frame)-20,
                                                                   maxYForX-temp-20, colWidth+40, 20)];
        LName.text = xv;
        LName.textColor  = _themeColor;
        LName.textAlignment = NSTextAlignmentCenter;
        LName.font = [UIFont systemFontOfSize:14];
        [_drawView addSubview:LName];

        xx+=xStepPixel;
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
