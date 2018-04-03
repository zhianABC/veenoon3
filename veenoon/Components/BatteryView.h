//
//  BatteryView.h
//  veenoon
//
//  Created by chen jack on 2017/11/27.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatteryView : UIView
{
    
}
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *warningColor;
//0 - 1  (0 - 100%)
- (void) setBatteryValue:(float)value;
- (void) updateGrayBatteryView;
- (void) updateYellowBatteryView;
@end
