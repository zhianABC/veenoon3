//
//  UserAudioPlayerSettingsViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/11/24.
//  Copyright © 2017年 jack. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UserBaseViewControllor.h"

typedef enum {
    CDPlayer,//选择省份状态
    SDPlayer,//选择城市状态
    USBPlaer//选择区、县状态
} PlayerState;

@interface UserAudioPlayerSettingsViewCtrl : UserBaseViewControllor {
    
}

@property (nonatomic, assign) PlayerState playerState;
@end
