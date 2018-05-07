//
//  VProjectProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface VProjectProxys : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;

//Property
@property (nonatomic, strong) NSString *_power;
@property (nonatomic, strong) NSString *_input;

/*
 SET_POWER [ON, OFF]
 SET_INPUT [HDMI, COMP, USB, LAN]
 */

- (NSDictionary *)getScenarioSliceLocatedShadow;

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;

- (NSArray*)getDirectOptions;

- (void) controlDevicePower:(NSString*)power;
- (void) controlDeviceInput:(NSString*)input;

- (BOOL) isSetChanged;
////生成场景片段
- (id) generateEventOperation_Power;
- (id) generateEventOperation_Input;

/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;


@end
