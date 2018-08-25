//
//  BlindPluginProxy.h
//  veenoon
//
//  Created by 安志良 on 2018/8/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RgsProxyObj;

@interface BlindPluginProxy : NSObject {
    
}

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;


- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;
/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;

@end
