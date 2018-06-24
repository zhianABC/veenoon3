//
//  VDVDPlayerProxy.h
//  veenoon
//
//  Created by chen jack on 2018/6/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface VDVDPlayerProxy : NSObject
{
    
}

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

- (NSDictionary *)getScenarioSliceLocatedShadow;

- (void) checkRgsProxyCommandLoad;

/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;


@end