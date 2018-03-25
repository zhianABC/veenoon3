//
//  VideoCamera.m
//  veenoon
//
//  Created by 安志良 on 2018/3/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VideoCamera.h"
#import "VeenoonConstatns.h"

@implementation VideoCamera
@synthesize _action;
@synthesize _name;
@synthesize _com;
@synthesize _ip;
@synthesize _tStatus;
@synthesize _wStatus;
@synthesize _cunchuStr;
@synthesize _diaoyongStr;
@synthesize _volumnStatus;
@synthesize _zoomInStatus;
@synthesize _zoomOutStatus;

- (void) setVideoCameraData:(NSDictionary*)VideoCamera {
    self._name = [VideoCamera objectForKey:VideoCameraName];
    self._com = [VideoCamera objectForKey:VideoCameraCom];
    self._ip = [VideoCamera objectForKey:VideoCameraIP];
    self._action = [VideoCamera objectForKey:VideoCameraAction];
    self._tStatus = [VideoCamera objectForKey:VideoCameratStatus];
    self._wStatus = [VideoCamera objectForKey:VideoCamerawStatus];
    self._cunchuStr = [VideoCamera objectForKey:VideoCameracunchuStr];
    self._diaoyongStr = [VideoCamera objectForKey:VideoCameratdiaoyongStr];
    self._volumnStatus = [VideoCamera objectForKey:VideoCameratvolumnStatus];
    self._zoomInStatus = [VideoCamera objectForKey:VideoCameratzoomInStatus];
    self._zoomOutStatus = [VideoCamera objectForKey:VideoCameratzoomOutStatus];
}
- (NSDictionary *)VideoCamera {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self._com) {
        [dic setObject:self._com forKey:VideoCameraCom];
    }
    if (self._name) {
        [dic setObject:self._name forKey:VideoCameraName];
    }
    if (self._ip) {
        [dic setObject:self._ip forKey:VideoCameraIP];
    }
    if (self._action) {
        [dic setObject:self._action forKey:VideoCameraAction];
    }
    if (self._tStatus) {
        [dic setObject:self._tStatus forKey:VideoCameratStatus];
    }
    if (self._wStatus) {
        [dic setObject:self._wStatus forKey:VideoCamerawStatus];
    }
    if (self._cunchuStr) {
        [dic setObject:self._cunchuStr forKey:VideoCameracunchuStr];
    }
    if (self._diaoyongStr) {
        [dic setObject:self._diaoyongStr forKey:VideoCameratdiaoyongStr];
    }
    if (self._volumnStatus) {
        [dic setObject:self._volumnStatus forKey:VideoCameratvolumnStatus];
    }
    if (self._zoomInStatus) {
        [dic setObject:self._zoomInStatus forKey:VideoCameratzoomInStatus];
    }
    if (self._zoomOutStatus) {
        [dic setObject:self._zoomOutStatus forKey:VideoCameratzoomOutStatus];
    }
    return dic;
}

@end
