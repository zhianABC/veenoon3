//
//  BlindPlugin.h
//  veenoon
//
//  Created by 安志良 on 2018/8/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"
#import "AirQualityPlugProxy.h"

@class RgsConnectionObj;

@interface AirQualityPlug : BasePlugElement

//<BlindPluginProxy>
@property (nonatomic, strong) AirQualityPlugProxy *_proxyObj;
@property (nonatomic, strong) NSArray *_localSavedCommands;
- (void) syncDriverComs;

@end

