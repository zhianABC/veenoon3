//
//  GradeLineView.h
//  veenoon
//
//  Created by chen jack on 2018/2/26.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeLineView : UIView
{
    
}

- (void) drawXY:(NSArray*)xs y:(NSArray*)ys;
- (void) processValueToPoints;
@end
