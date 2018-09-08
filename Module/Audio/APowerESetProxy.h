//
//  EDimmerLightProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface APowerESetProxy : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;
@property (nonatomic, strong) NSString *_relayStatus;
@property (nonatomic, assign) int _breakDuration;
@property (nonatomic, assign) int _linkDuration;


@property (nonatomic, assign) int _level;

- (void) controlRelayStatus:(NSString*)relayStatus;
- (void) controlRelayDuration:(BOOL)isBreak withDuration:(int)duration exec:(BOOL)exec;

- (BOOL) haveProxyCommandLoaded;

- (void) prepareLoadCommand:(NSArray*)cmds;

- (NSDictionary *)getScenarioSliceLocatedShadow;
- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;

- (BOOL) isSetChanged;

////生成场景片段
- (id) generateEventOperation_status;
- (id) generateEventOperation_breakDur;
- (id) generateEventOperation_linkDur;

/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas;


@end

