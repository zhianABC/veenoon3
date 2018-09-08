//
//  BlindPluginProxy.h
//  veenoon
//
//  Created by 安志良 on 2018/8/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RgsProxyObj;

@protocol AirQualityPlugProxyDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end

@interface AirQualityPlugProxy : NSObject {
    
}

@property (nonatomic, weak) id <AirQualityPlugProxyDelegate> delegate;
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;
@property (nonatomic, assign) int _channelNumber;

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;
/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas;

- (NSDictionary *)getChRecords;

- (void) controlStatue:(int)state withCh:(int)ch;

- (int) getChannelNumber;
@end

