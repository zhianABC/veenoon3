//
//  UserAirConditionViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapMarkerLayer.h"
#import "UserBaseViewControllor.h"

@class Scenario;

@interface UserAirConditionViewCtrl<MapMarkerLayerDelegate> : UserBaseViewControllor {
    
}
@property (nonatomic, strong) Scenario *_scenario;


@end
