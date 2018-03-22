//
//  UserMonitorSettingsViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBaseViewControllor.h"
@interface UserMonitorSettingsViewCtrl : UserBaseViewControllor {
    NSMutableArray *_monitorRoomList;
    int _number;
}
@property (nonatomic, strong) NSMutableArray *_monitorRoomList;
@property (nonatomic, assign) int _number;
@end
