//
//  ColumnsView.h
//  veenoon
//
//  Created by chen jack on 2017/11/21.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnsView : UIView
{
    
}
@property (nonatomic, assign) int xStepPixel;
@property (nonatomic, assign) int yStepPixel;
@property (nonatomic, strong) NSArray* yStepValues;
@property (nonatomic, strong) NSArray* xStepValues;
@property (nonatomic, strong) NSString *yName;
@property (nonatomic, strong) NSString *xName;
@property (nonatomic, strong) UIColor *_themeColor;
@property (nonatomic, assign) int colWidth;

@property (nonatomic, assign) float maxColValue;
@property (nonatomic, strong) NSArray* colValues;

- (void) initXY;

- (void) draw;

@end
