//
//  Scenario.h
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsSceneOperation;

@interface Scenario : NSObject

@property (nonatomic, strong) NSMutableArray *_areas;

@property (nonatomic, strong) NSMutableArray *_A8PowerPlugs;
@property (nonatomic, strong) NSMutableArray *_A16PowerPlugs;
@property (nonatomic, strong) NSMutableArray *_APlayerPlugs;
@property (nonatomic, strong) NSMutableArray *_AWirelessMikePlugs;
@property (nonatomic, strong) NSMutableArray *_AHand2HandPlugs;
@property (nonatomic, strong) NSMutableArray *_AProcessorPlugs;

@property (nonatomic, strong) NSMutableArray *_VDVDPlayers;
@property (nonatomic, strong) NSMutableArray *_VCameraSettings;
@property (nonatomic, strong) NSMutableArray *_VRemoteSettings;
@property (nonatomic, strong) NSMutableArray *_VVideoProcess;
@property (nonatomic, strong) NSMutableArray *_VPinJie;
@property (nonatomic, strong) NSMutableArray *_VTV;
@property (nonatomic, strong) NSMutableArray *_VLuBoJi;
@property (nonatomic, strong) NSMutableArray *_VTouyingji;

//场景的Event下的Operations，对应中控上的操作序列，最后生成场景的时候，提交到中控。
//<RgsSceneOperation> -- 参见Regulus SDK里的对象说明
@property (nonatomic, strong) NSMutableArray *_eventOperations;
@property (nonatomic, strong) NSMutableDictionary *_eventOperations_map;

- (void) addEventOperation:(RgsSceneOperation*)rgsSceneOp;

@end
