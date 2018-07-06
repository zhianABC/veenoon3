//
//  AirConditionProxy.h
//  veenoon
//
//  Created by chen jack on 2018/6/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@protocol AirConditionProxyDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end


@interface AirConditionProxy : NSObject
{
    
}

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, weak) id <AirConditionProxyDelegate> delegate;

- (NSDictionary *)getScenarioSliceLocatedShadow;

- (void) checkRgsProxyCommandLoad;

- (NSArray *)acModeSets;
- (NSArray *)acWindSets;

- (void) controlDeviceMenu:(NSString*)menuName;
- (void) controlACTemprature:(int)temp;
- (void) controlACMode:(NSString*)mode;
- (void) controlACWindMode:(NSString*)windmode;
/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;


@end
