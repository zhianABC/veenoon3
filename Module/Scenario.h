//
//  Scenario.h
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Scenario : NSObject

@property (nonatomic, strong) NSMutableArray *_A8PowerPlugs;
@property (nonatomic, strong) NSMutableArray *_A16PowerPlugs;
@property (nonatomic, strong) NSMutableArray *_APlayerPlugs;
@property (nonatomic, strong) NSMutableArray *_AWirelessMikePlugs;
@property (nonatomic, strong) NSMutableArray *_AHand2HandPlugs;

@property (nonatomic, strong) NSMutableArray *_VDVDPlayers;
@property (nonatomic, strong) NSMutableArray *_VCameraSettings;
@property (nonatomic, strong) NSMutableArray *_VRemoteSettings;
@property (nonatomic, strong) NSMutableArray *_VVideoProcess;
@property (nonatomic, strong) NSMutableArray *_VPinJie;
@property (nonatomic, strong) NSMutableArray *_VTV;
@property (nonatomic, strong) NSMutableArray *_VLuBoJi;
@property (nonatomic, strong) NSMutableArray *_VTouyingji;
@end
