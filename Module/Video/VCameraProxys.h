//
//  VCameraProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface VCameraProxys : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

//Property
@property (nonatomic, strong) NSString *_zoom;
@property (nonatomic, strong) NSString *_move;

@property (nonatomic, assign) int _save;//保存预置位
@property (nonatomic, assign) int _load;//调用预置位

/*
 SET_ZOOM
 MOVE [UP, DOWN, LEFT, RIGHT, STOP]
 */

- (void) checkRgsProxyCommandLoad;

- (NSArray*)getDirectOptions;

- (void) controlDeviceDirection:(NSString*)direct;
- (void) stopControlDeviceDirection;

- (void) controlDeviceSavePostion;
- (void) controlDeviceLoadPostion;
- (void) controlDeviceZoom:(NSString*)zoom;

@end
