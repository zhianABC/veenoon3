//
//  EDimmerSwitchLightProxy.h
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface EDimmerSwitchLightProxy : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;


@property (nonatomic, assign) int _power;

- (void) getCurrentDataState;

- (BOOL) haveProxyCommandLoaded;

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;

- (void) controlDeviceLightPower:(int)powerValue;

- (BOOL) isSetChanged;

////生成场景片段
- (NSArray*) generateEventOperation_ChPower;

/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas;


@end
