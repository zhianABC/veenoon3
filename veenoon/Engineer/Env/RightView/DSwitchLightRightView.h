//
//  DSwitchLightRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDimmerSwitchLight;

@interface DSwitchLightRightView : UIView
{
    
}

@property(nonatomic, strong) EDimmerSwitchLight *_currentObj;

- (void) saveCurrentSetting;

-(void) refreshView:(EDimmerSwitchLight*) dimmer;

@end
