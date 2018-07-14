//
//  VAProcessorProxys.h
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@protocol VAProcessorProxysDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end

@interface VAProcessorProxys : NSObject
{
    
}
@property (nonatomic, weak) id <VAProcessorProxysDelegate> delegate;

@property (nonatomic, strong) NSString *_icon_name;
@property (nonatomic, strong) NSDictionary *_voiceInDevice;


@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

//Property
@property (nonatomic, strong) NSString *_mode;
@property (nonatomic, assign) BOOL _is48V;
@property (nonatomic, strong) NSString *_micDb;

//fankuiyizhi
@property (nonatomic, assign) BOOL _isFanKuiYiZhiStarted;

//yanshiqi
@property (nonatomic, strong) NSString *_yanshiqiSlide;
//yaxianqi
@property (nonatomic, strong) NSString *_yaxianFazhi;
@property (nonatomic, strong) NSString *_yaxianXielv;
@property (nonatomic, strong) NSString *_yaxianStartTime;
@property (nonatomic, strong) NSString *_yaxianRecoveryTime;
@property (nonatomic, assign) BOOL _isyaxianStart;
//zaoshengmen
@property (nonatomic, strong) NSString *_zaoshengFazhi;
@property (nonatomic, strong) NSString *_zaoshengStartTime;
@property (nonatomic, strong) NSString *_zaoshengHuifuTime;
@property (nonatomic, assign) BOOL _isZaoshengStarted;

//lvbojunheng
@property (nonatomic, strong) NSString *_lvbojunhengGaotongType;
@property (nonatomic, strong) NSArray *_lvboGaotongArray;
@property (nonatomic, strong) NSString *_lvbojunhengGaotongXielv;
@property (nonatomic, strong) NSArray *_lvboGaotongXielvArray;
@property (nonatomic, strong) NSString *_lvbojunhengDitongType;
@property (nonatomic, strong) NSArray *_lvboDitongArray;
@property (nonatomic, strong) NSArray *_lvboDitongXielvArray;
@property (nonatomic, strong) NSArray *_lvboBoDuanArray;
@property (nonatomic, assign) BOOL _islvboGaotongStart;
@property (nonatomic, assign) BOOL _islvboDitongStart;
@property (nonatomic, strong) NSString *_lvboGaotongPinLv;
@property (nonatomic, strong) NSString *_lvboBoduanPinlv;
@property (nonatomic, strong) NSString *_lvboBoduanZengyi;
@property (nonatomic, strong) NSString *_lvboBoduanQ;
@property (nonatomic, strong) NSString *_lvboDitongFreq;
@property (nonatomic, strong) NSString *_lvboDitongSL;

@property (nonatomic, strong) NSMutableArray *waves16_feq_gain_q;

//xinhaofasheng
@property (nonatomic, strong) NSString* _xinhaofashengPinlv;
@property (nonatomic, strong) NSArray * _xinhaofashengPinlvArray;
@property (nonatomic, strong) NSString* _xinhaozhengxuanbo;
@property (nonatomic, strong) NSArray *_xinhaozhengxuanArray;
@property (nonatomic, assign) BOOL _isXinhaofashengMute;
@property (nonatomic, strong) NSString* _xinhaofashengZengyi;

//dianping
@property (nonatomic, strong) NSString* _dianpingPinlv;
@property (nonatomic, strong) NSString* _dianpingfanxiang;
@property (nonatomic, assign) BOOL _isdianpingMute;
@property (nonatomic, strong) NSString* _dianpingZengyi;

//矩阵
@property (nonatomic, strong) NSMutableDictionary *_setMixSrc;
@property (nonatomic, strong) NSMutableDictionary *_setMixValue;

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

//批量获取后，赋值
- (void) prepareLoadCommand:(NSArray*)cmds;
- (BOOL) haveProxyCommandLoaded;

- (BOOL) isProxyMute;
- (BOOL) isProxyDigitalMute;
- (float) getDigitalGain;
- (float) getAnalogyGain;
- (BOOL) getInverted;

- (NSArray*)getModeOptions;
- (NSArray*)getMicDbOptions;
- (NSDictionary*)getSigOuccorOptions;
- (NSDictionary*)getNoiseGateOptions;
- (NSDictionary*)getPressLimitOptions;
- (NSDictionary*)getSetDelayOptions;
- (NSArray*)getHighFilters;
- (NSArray*)getHighSL;
- (NSDictionary*)getHighRateRange;

- (NSArray*)getWaveTypes;
- (NSDictionary*)getWaveOptions;

- (void) controlDeviceDb:(float)db force:(BOOL)force;
- (void) controlDeviceMute:(BOOL)isMute;

- (void) controlDeviceDigitalGain:(float)digVal;
- (void) controlDigtalMute:(BOOL)isMute;

//fankuiyizhi
- (void) controlFanKuiYiZhi:(BOOL)isFanKuiYiZhiStarted;
- (BOOL) isFanKuiYiZhiStarted;

//yanshiqi
- (NSString*) getYanshiqiSlide;
- (void) controlYanshiqiSlide:(NSString*) yanshiqiSlide;

//yaxianqi
- (NSString*) getYaxianFazhi;
- (void) controlYaxianFazhi:(NSString*) yaxianFazhi;
- (NSString*) getYaxianXielv;
- (void) controlYaxianXielv:(NSString*) yaxianXielv;
- (NSString*) getYaxianStartTime;
- (void) controlYaxianStartTime:(NSString*) yaxianStartTime;
- (NSString*) getYaxianRecoveryTime;
- (void) controlYaxianRecoveryTime:(NSString*) yaxianRecoveryTime;
- (BOOL) isYaXianStarted;
- (void) controlYaXianStarted:(BOOL)isyaxianstarted;

//zaosheng
- (BOOL) isZaoshengStarted;
- (void) controlZaoshengStarted:(BOOL)isZaoshengStarted;
- (NSString*) getZaoshengFazhi;
- (void) controlZaoshengFazhi:(NSString*) zaoshengFazhi;
- (NSString*) getZaoshengStartTime;
- (void) controlZaoshengStartTime:(NSString*) zaoshengStartTime;
- (NSString*) getZaoshengRecoveryTime;
- (void) controlZaoshengRecoveryTime:(NSString*) zaoshengHuifuTime;

//lvbojunheng
- (NSString*) getGaoTongType;
- (void) controlGaoTongType:(NSString*) gaotongType;
- (NSArray*) getLvBoGaoTongArray;

- (NSString*) getGaoTongXieLv;
- (void) controlGaoTongXieLv:(NSString*) gaotongxielv;
- (NSArray*) getLvBoGaoTongXielvArray;

- (NSString*) getDiTongType;
- (void) controlDiTongType:(NSString*) ditongtype;
- (NSArray*)getLowFilters;

- (NSString*) getDiTongXieLv;
- (void) controlDiTongXieLv:(NSString*) ditongxielv;
- (NSArray*) getLvBoDiTongXielvArray;

- (void) controlBandLineType:(NSString*) lineType band:(int)band;
- (NSArray*) getLvBoBoDuanArray;

- (BOOL) isLvboGaotongStart;
- (void) controlLVboGaotongStart:(BOOL) lvboGaotongStart;

- (NSString*) getLvboGaotongPinlv;
- (void) controlHighFilterFreq:(NSString*) freq;


- (void) controlBandEnabled:(BOOL) enable band:(int)band;
- (void) controlBrandFreq:(NSString*) freq brand:(int)brand;
- (void) controlBrandGain:(NSString*) gain  brand:(int)brand;
- (void) controlBrandFreqAndGain:(NSString*) freq gain:(NSString*)gain brand:(int)brand;
- (void) controlBrandQ:(NSString*)qIndex qVal:(NSString*)qVal brand:(int)brand;


-(BOOL) islvboDitongStart;
-(void) controllvboDitongStart:(BOOL) lvboDitongStart;

-(NSString*) getLowFilterFreq;
-(void) controlLowFilterFreq:(NSString*)lvboDitongPinlv;

- (NSDictionary*)getLowRateRange;

//矩阵路由
- (NSDictionary*)getMatrixCmdSettings;
- (void) controlMatrixSrc:(VAProcessorProxys *)proxy selected:(BOOL)selected;
- (void) controlMatrixSrcValue:(VAProcessorProxys *)proxy th:(float)th;

//信号发生器
-(NSString*) getXinhaofashengPinlv;
-(void) controlXinHaofashengPinlv:(NSString*)xinhaofashengPinlv;
-(NSArray*) getXinhaofashengPinlvArray;
-(NSString*) getXinhaoZhengxuanbo;
-(void) controlXinhaoZhengxuanbo:(NSString*)zhengxuanbo;
-(NSArray*) getXinhaofashengZhengxuanArray;
-(BOOL) isXinhaofashengMute;
-(void) controlXinhaofashengMute:(BOOL)xinhaofashengMute;
-(NSString*) getXinhaofashengZengyi;
-(void) controlXinhaofashengZengyi:(NSString*)xinhaofashengZengyi;

-(NSString*) getDianpingPinlv;
-(void) controlDianpingPinlv:(NSString*)dianpingPinlv;
-(NSString*) getDianpingfanxiang;
-(void) controlDianpingfanxian:(NSString*)dianpingfanxiang;
-(BOOL) isDianpingMute;
-(void) controlDianpingMute:(BOOL)dianpingMute;
-(NSString*) getDianpingZengyi;
-(void) controlDianpingZengyi:(NSString*)dianpingZengyi;


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

//高通
- (id) generateEventOperation_hp;

//低通
- (id) generateEventOperation_lp;

//PEQ 0-15
- (NSArray*) generateEventOperation_peq;

//压限器
- (id) generateEventOperation_limitPress;

//矩阵SRC
- (NSArray* ) generateEventOperation_mixSrc;

//矩阵SRC VALUE
- (NSArray* ) generateEventOperation_mixValue;


/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;
- (NSDictionary *)getScenarioSliceLocatedShadow;

@end
