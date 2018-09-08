//
//  DimmerLightSwitchView.h
//  veenoon
//
//  Created by chen jack on 2018/9/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDimmerSwitchLight;

@interface DimmerLightSwitchView : UIView
@property (nonatomic, strong) EDimmerSwitchLight *_curProcessor;

- (void) load;

@end
