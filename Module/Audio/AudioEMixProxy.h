//
//  VProjectProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface AudioEMixProxy : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, assign) NSUInteger _deviceId;

//Property
@property (nonatomic, assign) float _deviceVol;
@property (nonatomic, strong) NSString *_currentCameraPol;
@property (nonatomic, strong) NSMutableArray *_cameraPol;

/*
 //set_mode 语音激励，或者是标准发言
 //set_priority 设置主席/代表
 //set_mic_open_max 设置最大发言人数
 //set_vol 设置输出音量
 //set_mic_delay_close
 //set_cam_pol 摄像追踪(VISCA)
 //set_cam_addr 设置摄像地址
 //set_cam_star_pos 设置预制位
 //set_peq 设置均衡
 //set_press 压限
 //set_noise_gate 噪声们
 //set_high_filter 高通
 //set_low_filter 低通
 //set_fb 反馈抑制(取消)
 */

- (NSDictionary *)getScenarioSliceLocatedShadow;
- (NSMutableArray*)getCameraPol;




- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;

- (void) controlDeviceVol:(float)db force:(BOOL)force;
- (void) controlDeviceCameraPol:(NSString*)cameraPol;

- (BOOL) isSetChanged;

/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;


@end
