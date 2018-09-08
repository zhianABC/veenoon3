//
//  UserElectronicAutoViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/2.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBaseViewControllor.h"
#import "BlindPlugin.h"

@class Scenario;

@interface UserElectronicAutoViewCtrl : UserBaseViewControllor {
    
}
@property (nonatomic, strong) BlindPlugin *_currentBlind;
@property (nonatomic, strong) NSMutableArray *_blindArray;
@property (nonatomic, strong) Scenario *_scenario;

@end
