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
    
    self.backgroundColor = [UIColor clearColor];
    
    int h = yStepPixel * (int)[yStepValues count] + 40 + 40;
    int w = xStepPixel * (int)[xStepValues count] + 80 + 40;
    
    
    
    yLine = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 1, h-40)];
    yLine.backgroundColor = _themeColor;
    [self addSubview:yLine];
    
    xLine = [[UILabel alloc] initWithFrame:CGRectMake(80, h-40, w, 1)];
    xLine.backgroundColor = _themeColor;
    [self addSubview:xLine];
    
    int max = h - 40;
    
    int xx = 80+xStepPixel;
    for(NSString * xv in xStepValues){
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx, max, 1, 14)];
        kdl.backgroundColor = _themeColor;
        [self addSubview:kdl];
        
        UILabel *xLName = [[UILabel alloc] initWithFrame:CGRectMake(xx-20, max+14, 40, 20)];
        xLName.text = xv;
        xLName.textColor  = _themeColor;
        xLName.textAlignment = NSTextAlignmentCenter;
        xLName.font = [UIFont systemFontOfSize:14];
        [self addSubview:xLName];
        
        xx+=xStepPixel;
    }
    
    int yy = max - yStepPixel;
    for(NSString * yv in yStepValues){
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(80 - 14,
                                                                 yy, 14, 1)];
        kdl.backgroundColor = _themeColor;
        [self addSubview:kdl];
        
        UILabel *yLName = [[UILabel alloc] initWithFrame:CGRectMake(80-40-14,
                                                                    yy, 20, 20)];
        yLName.text = yv;
        yLName.textAlignment = NSTextAlignmentCenter;
        yLName.font = [UIFont systemFontOfSize:14];
        yLName.textColor = _themeColor;
        [self addSubview:yLName];
        
        yy-=yStepPixel;
    }
    
    CGRect rc = self.frame;
    rc.size.width = w;
    rc.size.height = h;
    self.frame = rc;
    
    

    
}
- (void) draw{
    
    int h = self.frame.size.height;
    int w = self.frame.size.width;
    int max = h - 40;
    int xx = 80+xStepPixel;
    
    int mValue = h - 80;
    
    for(NSString * xv in colValues){
        
        float v = [xv floatValue];
        int temp = v*mValue/maxColValue;
        
        
        UILabel *kdl = [[UILabel alloc] initWithFrame:CGRectMake(xx-colWidth/2, max-temp, colWidth, temp)];
        kdl.backgroundColor = _themeColor;
        [self addSubview:kdl];
        
    
        UILabel *LName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(kdl.frame)-20,
                                                                   max-temp-20, colWidth+40, 20)];
        LName.text = xv;
        LName.textColor  = _themeColor;
        LName.textAlignment = NSTextAlignmentCenter;
        LName.font = [UIFont systemFontOfSize:14];
        [self addSubview:LName];

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
