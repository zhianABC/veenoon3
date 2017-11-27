//
//  SignalView.h
//  veenoon
//
//  Created by chen jack on 2017/11/26.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignalView : UIView
{
    
}

- (id) initWithFrameAndStep:(CGRect)frame step:(int)step;

- (void) setLightColor:(UIColor *)color;
- (void) setGrayColor:(UIColor *)color;
// from 1 to 5
- (void) setSignalValue:(int)value;
@end
