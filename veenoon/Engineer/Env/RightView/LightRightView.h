//
//  LightRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDimmerLight;

@interface LightRightView : UIView
{
    
}

@property(nonatomic, strong) EDimmerLight *_currentObj;

- (void) saveCurrentSetting;

-(void) refreshView:(EDimmerLight*) dimmer;

@end
