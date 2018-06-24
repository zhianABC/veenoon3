//
//  BasePlugElement.h
//  veenoon
//
//  Created by chen jack on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsPropertyObj;
@class RgsConnectionObj;
@class ComDriver;

@interface BasePlugElement : NSObject
{
    id _driverInfo;
    id _driver;
    
    RgsPropertyObj *_driver_ip_property;
    NSArray *_connections;
}

@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) NSString *_brand;
@property (nonatomic, strong) NSString *_type;
@property (nonatomic, strong) NSString *_driverUUID;
@property (nonatomic, strong) NSString *_deviceno;
@property (nonatomic, strong) NSString *_deviceid;
@property (nonatomic, strong) NSString *_ipaddress;

@property (nonatomic, strong) NSString *_plugicon;
@property (nonatomic, strong) NSString *_plugicon_s;

@property (nonatomic, strong) NSString *_show_icon_name;
@property (nonatomic, strong) NSString *_show_icon_sel_name;
//connection
@property (nonatomic, assign) int _comIdx;
@property (nonatomic, strong) NSArray *_comArray;

@property (nonatomic,assign) int _index;

@property (nonatomic, assign) BOOL _isViewed;


@property (nonatomic, strong) id _driverInfo;
@property (nonatomic, strong) id _driver;
@property (nonatomic, strong) RgsPropertyObj *_driver_ip_property;
@property (nonatomic, strong) NSArray *_properties;

@property (nonatomic, strong) NSArray *_connections;
//@property (nonatomic, strong) RgsConnectionObj *_com;
@property (nonatomic, strong) ComDriver *_comDriver;


- (int) getID;

- (void) createDriver;
- (void) removeDriver;

- (void) syncDriverIPProperty;
- (void) uploadDriverIPProperty;

- (void) syncDriverComs;
- (void) createConnection:(RgsConnectionObj*)source withConnect:(RgsConnectionObj*)target;

- (NSString*) showName;
- (NSString*) deviceName;

- (NSDictionary *)objectToJson;
- (void) jsonToObject:(NSDictionary*)json;

@end
