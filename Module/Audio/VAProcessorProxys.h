//
//  VAProcessorProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface VAProcessorProxys : NSObject
{
    
}
@property (nonatomic, strong) NSString *_icon_name;
@property (nonatomic, strong) NSDictionary *_voiceInDevice;


@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

//Property
@property (nonatomic, strong) NSString *_mode;
@property (nonatomic, assign) BOOL _is48V;
@property (nonatomic, strong) NSString *_micDb;

//fankuiyizhi
@property (nonatomic, assign) BOOL _isFanKuiYiZhiStarted;
//zidonghunyin
@property (nonatomic, assign) BOOL _isZiDongHunYinStarted;
@property (nonatomic, strong) NSString *_zidonghunyinZengYi;
//huishengxiaochu
@property (nonatomic, assign) BOOL _isHuiShengXiaoChu;
//yanshiqi
@property (nonatomic, strong) NSString *_yanshiqiSlide;
@property (nonatomic, strong) NSString *_yanshiqiYingChi;
@property (nonatomic, strong) NSString *_yanshiqiMi;
@property (nonatomic, strong) NSString *_yanshiqiHaoMiao;

/*
 SET_MUTE
 SET_UNMUTE
 SET_DIGIT_MUTE options [True, False]
 SET_DIGIT_GRAIN
 SET_ANALOGY_GRAIN
 SET_INVERTED
 SET_MODE  options [LINE, MIC]
 SET_MIC_DB
 SET_48V
 SET_NOISE_GATE
 SET_FB_CTRL
 SET_PRESS_LIMIT
 SET_DELAY
 SET_HIGH_FILTER
 SET_LOW_FILTER
 SET_PEQ
 */

- (void) checkRgsProxyCommandLoad;

- (BOOL) isProxyMute;
- (BOOL) isProxyDigitalMute;
- (float) getDigitalGain;
- (float) getAnalogyGain;
- (BOOL) getInverted;

- (NSArray*)getModeOptions;
- (NSArray*)getMicDbOptions;

- (void) controlDeviceDb:(float)db force:(BOOL)force;
- (void) controlDeviceMute:(BOOL)isMute;

- (void) controlDeviceDigitalGain:(float)digVal;
- (void) controlDigtalMute:(BOOL)isMute;

//fankuiyizhi
- (void) controlFanKuiYiZhi:(BOOL)isFanKuiYiZhiStarted;
- (BOOL) isFanKuiYiZhiStarted;

//zidonghuiyin
- (void) controlZiDongHunYin:(BOOL)isZiDongHunYinStarted;
- (BOOL) isZiDongHunYinStarted;
- (NSString*) getZidonghuiyinZengYi;
- (void) controlZiDongHunYinZengYi:(NSString*) zengyiDB;

//huishengxiaochu
- (void) controlHuiShengXiaoChu:(BOOL)isHuiShengXiaoChu;
- (BOOL) isHuiShengXiaoChuStarted;

//yanshiqi
- (NSString*) getYanshiqiSlide;
- (void) controlYanshiqiSlide:(NSString*) yanshiqiSlide;
- (NSString*) getYanshiqiYingChi;
- (void) controlYanshiqiYingChi:(NSString*) yanshiqiYingChi;
- (NSString*) getYanshiqiMi;
- (void) controlYanshiqiMi:(NSString*) yanshiqiMi;
- (NSString*) getYanshiqiHaoMiao;
- (void) controlYanshiqiHaoMiao:(NSString*) yanshiqiHaoMiao;


- (void) controlDeviceMode:(NSString*)mode;

- (void) controlDeviceMicDb:(NSString*)db;
- (void) control48V:(BOOL)is48v;

- (void) controlInverted:(BOOL)invert;


- (BOOL) isSetChanged;
////生成场景片段
- (id) generateEventOperation_AnalogyGain;
- (id) generateEventOperation_Mute;

- (id) generateEventOperation_DigitalGain;
- (id) generateEventOperation_DigitalMute;

- (id) generateEventOperation_Mode;

- (id) generateEventOperation_MicDb;
- (id) generateEventOperation_48v;

- (id) generateEventOperation_Inverted;


/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;
- (NSDictionary *)getScenarioSliceLocatedShadow;

@end
