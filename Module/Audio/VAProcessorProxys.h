//
//  VAProcessorProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface VAProcessorProxys : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

- (void) checkRgsProxyCommandLoad;

- (void) controlDeviceDb:(float)db force:(BOOL)force;
- (void) controlDeviceMute:(BOOL)isMute;

- (id) generateEventOperation_AnalogyGain;
- (id) generateEventOperation_Mute;

@end
