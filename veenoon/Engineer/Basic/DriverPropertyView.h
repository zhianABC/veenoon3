//
//  DriverPropertyView.h
//  veenoon
//
//  Created by chen jack on 2018/5/10.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasePlugElement;

@interface DriverPropertyView : UIView
{
    BOOL _isAirQuality;
}
@property (nonatomic, strong) BasePlugElement *_plugDriver;
@property (nonatomic, assign) BOOL _isAirQuality;


- (void) saveCurrentSetting;
- (void) recoverSetting;

- (void) updateConnectionSet;
- (void) refreshLabelToAirQuality;
@end
