//
//  UserVideoConfigViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/11/28.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserVideoConfigView.h"
#import "UserBaseViewControllor.h"

@class Scenario;

@interface UserVideoConfigViewCtrl : UserBaseViewControllor<UserVideoConfigViewDelegate> {
    
}

@property (nonatomic, strong) Scenario *_scenario;

@end
