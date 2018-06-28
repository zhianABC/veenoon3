//
//  AirConditionProxy.h
//  veenoon
//
//  Created by chen jack on 2018/6/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;


@interface AirConditionProxy : NSObject
{
    
}

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

- (NSDictionary *)getScenarioSliceLocatedShadow;

- (void) checkRgsProxyCommandLoad;

- (void) controlDeviceMenu:(NSString*)menuName;

/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;


@end
