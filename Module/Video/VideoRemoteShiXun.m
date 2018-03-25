//
//  VideoRemoteShiXun.m
//  veenoon
//
//  Created by 安志良 on 2018/3/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VideoRemoteShiXun.h"
#import "VeenoonConstatns.h"

@implementation VideoRemoteShiXun
@synthesize _name;
@synthesize _com;
@synthesize _ip;
@synthesize _irArray;

- (void) setVideoRemoteData:(NSDictionary*)videoRemote {
    self._name = [videoRemote objectForKey:VideoRemoteName];
    self._com = [videoRemote objectForKey:VideoRemoteCom];
    self._ip = [videoRemote objectForKey:VideoRemoteIP];
    self._irArray = [videoRemote objectForKey:VideoRemoteIRArray];
}
- (NSDictionary *)videoRemote {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self._com) {
        [dic setObject:self._com forKey:VideoRemoteCom];
    }
    if (self._name) {
        [dic setObject:self._name forKey:VideoRemoteName];
    }
    if (self._ip) {
        [dic setObject:self._ip forKey:VideoRemoteIP];
    }
    if (self._irArray) {
        [dic setObject:self._irArray forKey:VideoRemoteIRArray];
    }
    return dic;
}

@end
