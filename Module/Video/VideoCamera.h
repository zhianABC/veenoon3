//
//  VideoCamera.h
//  veenoon
//
//  Created by 安志良 on 2018/3/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCamera : NSObject
@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) NSString *_ip;
@property (nonatomic, strong) NSString *_com;
@property (nonatomic, strong) NSString *_diaoyongStr;
@property (nonatomic, strong) NSString *_cunchuStr;
@property (nonatomic, strong) NSString *_volumnStatus;
@property (nonatomic, strong) NSString *_action;
@property (nonatomic, strong) NSString *_tStatus;
@property (nonatomic, strong) NSString *_wStatus;
@property (nonatomic, strong) NSString *_zoomInStatus;
@property (nonatomic, strong) NSString *_zoomOutStatus;
- (void) setVideoCameraData:(NSDictionary*)VideoCamera;
- (NSDictionary *)VideoCamera;

@end
