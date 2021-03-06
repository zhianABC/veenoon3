//
//  EDimmerLightProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface EDimmerLightProxys : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;


@property (nonatomic, assign) int _level;

- (void) getCurrentDataState;

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;

- (BOOL) haveProxyCommandLoaded;


- (void) controlDeviceLightLevel:(int)levelValue exec:(BOOL)exec;

- (BOOL) isSetChanged;

////生成场景片段
- (NSArray*) generateEventOperation_ChLevel;

/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas;


@end
