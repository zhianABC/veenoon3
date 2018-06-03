//
//  VCameraSettingSet.h
//  veenoon
//
//  Created by 安志良 on 2018/4/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"


@class RgsConnectionObj;

@interface VCameraSettingSet : BasePlugElement

@property (nonatomic, strong) id _comDriverInfo;
@property (nonatomic, strong) id _comDriver;

//<VCameraProxy>
@property (nonatomic, strong) id _proxyObj;

//<RgsConnectionObj>
@property (nonatomic, strong) NSArray *_localSavedProxys;



- (NSString*) deviceName;

@end
