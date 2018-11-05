//
//  SensorProxy.h
//  veenoon
//
//  Created by chen jack on 2018/11/5.
//  Copyright © 2018 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RgsConnectionObj;

@interface SensorProxy : NSObject
{
    
}
@property (nonatomic, strong) RgsConnectionObj *connection;
@property (nonatomic, assign) int _proxyId;
@property (nonatomic, assign) int _sensorType;

- (void) refreshData;

@end

NS_ASSUME_NONNULL_END
