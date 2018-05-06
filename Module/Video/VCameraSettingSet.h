//
//  VCameraSettingSet.h
//  veenoon
//
//  Created by 安志良 on 2018/4/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"


@interface VCameraSettingSet : BasePlugElement

@property (nonatomic, strong) id _driverInfo;
@property (nonatomic, strong) id _driver;

@property (nonatomic, strong) id _comDriverInfo;
@property (nonatomic, strong) id _comDriver;

//<VCameraProxy>
@property (nonatomic, strong) id _proxyObj;

//<RgsConnectionObj>
@property (nonatomic, strong) NSArray *_comConnections;
@property (nonatomic, strong) NSArray *_cameraConnections;

- (void) syncDriverIPProperty;
- (void) uploadDriverIPProperty;

- (void) syncDriverComs;


- (void) createDriver;
- (void) removeDriver;

- (void) createConnection;

- (NSString*) deviceName;

@end
