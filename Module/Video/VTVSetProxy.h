//
//  VTVSetProxy.h
//  veenoon
//
//  Created by chen jack on 2018/7/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;


@interface VTVSetProxy : NSObject
{
    
}

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

- (NSDictionary *)getScenarioSliceLocatedShadow;

- (void) checkRgsProxyCommandLoad;

- (void) controlDeviceMenu:(NSString*)menuName;

/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;

@end
