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
    int rightEdage;
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
@synthesize _lineColor;

- (void) initXY{
    
    leftEdage = 0;
    rightEdage = 50;
    bottomEdage = 40;
    topEdage = 40;
    
    self.backgroundColor = [UIColor clearColor];
    
    int h = yStepPixel * ((int)[yStepValues count]-1) + bottomEdage + topEdage;
    
    int regW = xStepPixel * (int)[xStepValues count];
    int regH = h-bottomEdage/2-topEdage;
    int w = regW + leftEdage + 40 + rightEdage;
    
    
    
    //纵向左侧坐标线
    yLine = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage,
                                                      topEdage-1,
                                                      1,
                                                      regH)];
    yLine.backgroundColor = _lineColor;
    [self addSubview:yLine];
    
    //顶部封口线
    UIImageView *txLine = [[UIImageView alloc] initWithFrame:CGRectMake(leftEdage,
                                                      topEdage-1,
                                                      regW, 1)];
    txLine.backgroundColor = _lineColor;
    [self addSubview:txLine];
    
    //横向底部坐标线
    xLine = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage,
                                                      h-40,
                                                      regW,
                                                      1)];
    xLine.backgroundColor = _lineColor;
    [self addSubview:xLine];
    
    int topForX = h - bottomEdage;
    
    //////横坐标
    int xx = leftEdage;
    for(NSString * xv in xStepValues){
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx, topEdage, 1, regH)];
        kdl.backgroundColor = _lineColor;
        kdl.alpha = 0.3;
        [self addSubview:kdl];
        
        UILabel *xLName = [[UILabel alloc] initWithFrame:CGRectMake(xx+5, topForX, 40, 30)];
        xLName.text = xv;
        xLName.textColor  = _lineColor;
        xLName.textAlignment = NSTextAlignmentLeft;
        xLName.font = [UIFont systemFontOfSize:14];
        [self addSubview:xLName];
        
        xx+=xStepPixel;
    }
    
    //右侧封口
    UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx, topEdage, 1, regH)];
    kdl.backgroundColor = _lineColor;
    kdl.alpha = 0.3;
    [self addSubview:kdl];
    
    //纵坐标 从0开始，0抬起10 pixel
    int topForY = h - bottomEdage;
    
    for(NSString * yv in yStepValues){
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage,
                                                                 topForY, regW, 1)];
        kdl.backgroundColor = _lineColor;
        kdl.alpha = 0.3;
        [self addSubview:kdl];
        
        UILabel *yLName = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage+regW+5,
                                                                    topForY-10, 40, 20)];
        yLName.text = yv;
        yLName.textAlignment = NSTextAlignmentLeft;
        yLName.font = [UIFont systemFontOfSize:14];
        yLName.textColor = _lineColor;
        [self addSubview:yLName];
        yLName.backgroundColor = [UIColor clearColor];
        
        topForY-=yStepPixel;
    }
    
    /*
    _xNameL = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage-15,
                                                        CGRectGetMaxY(xLine.frame)+5,
                                                        xStepPixel+20,
                                                        20)];
    _xNameL.textColor = [UIColor whiteColor];
    _xNameL.textAlignment = NSTextAlignmentCenter;
    _xNameL.font = [UIFont systemFontOfSize:13];
    [self addSubview:_xNameL];
    
    _xNameL.text = xName;
     */
    
    _yNameL = [[UILabel alloc] initWithFrame:CGRectMake(leftEdage+regW+30,
                                                        topEdage-10,
                                                        80,
                                                        20)];
    _yNameL.textColor = [UIColor whiteColor];
    _yNameL.textAlignment = NSTextAlignmentLeft;
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
 
    int maxYForX = h - bottomEdage;
    int xx = leftEdage;
    
    int mValue = h - bottomEdage - topEdage;
    
    float spaceWith2Sides = (xStepPixel - colWidth)/2.0;
    
    for(NSString * xv in colValues){
        
        float v = [xv floatValue];
        int temp = v*mValue/maxColValue;
        
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx+spaceWith2Sides,
                                                                 maxYForX-temp,
                                                                 colWidth, temp)];
        kdl.backgroundColor = _themeColor;
        [_drawView addSubview:kdl];
        kdl.layer.cornerRadius = 2;
        kdl.clipsToBounds = YES;
        
    
        UILabel *LName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(kdl.frame)-20,
                                                                   maxYForX-temp-20, colWidth+40, 20)];
        LName.text = xv;
        LName.textColor  = _lineColor;
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
