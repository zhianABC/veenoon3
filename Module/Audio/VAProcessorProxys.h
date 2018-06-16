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
//yaxianqi
@property (nonatomic, strong) NSString *_yaxianFazhi;
@property (nonatomic, strong) NSString *_yaxianXielv;
@property (nonatomic, strong) NSString *_yaxianStartTime;
@property (nonatomic, strong) NSString *_yaxianRecoveryTime;
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
@property (nonatomic, strong) NSString *_lvbojunhengDitongXielv;
@property (nonatomic, strong) NSArray *_lvboDitongXielvArray;
@property (nonatomic, strong) NSString *_lvbojunhengBoduanType;
@property (nonatomic, strong) NSArray *_lvboBoDuanArray;
@property (nonatomic, assign) BOOL _islvboGaotongStart;
@property (nonatomic, assign) BOOL _islvboBoduanStart;
@property (nonatomic, assign) BOOL _islvboDitongStart;
@property (nonatomic, strong) NSString *_lvboGaotongPinLv;
@property (nonatomic, strong) NSString *_lvboBoduanPinlv;
@property (nonatomic, strong) NSString *_lvboBoduanZengyi;
@property (nonatomic, strong) NSString *_lvboBoduanQ;
@property (nonatomic, strong) NSString *_lvboDitongPinlv;

//xinhaofasheng
@property (nonatomic, strong) NSString* _xinhaofashengPinlv;
@property (nonatomic, strong) NSString* _zhengxuanbo;
@property (nonatomic, assign) BOOL _isXinhaofashengMute;
@property (nonatomic, strong) NSString* _xinhaofashengZengyi;

//dianping
@property (nonatomic, strong) NSString* _dianpingPinlv;
@property (nonatomic, strong) NSString* _dianpingfanxiang;
@property (nonatomic, assign) BOOL _isdianpingMute;
@property (nonatomic, strong) NSString* _dianpingZengyi;
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
- (NSDictionary*)getPressLimitOptions;


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

//yaxianqi
- (NSString*) getYaxianFazhi;
- (void) controlYaxianFazhi:(NSString*) yaxianFazhi;
- (NSString*) getYaxianXielv;
- (void) controlYaxianXielv:(NSString*) yaxianXielv;
- (NSString*) getYaxianStartTime;
- (void) controlYaxianStartTime:(NSString*) yaxianStartTime;
- (NSString*) getYaxianRecoveryTime;
- (void) controlYaxianRecoveryTime:(NSString*) yaxianRecoveryTime;

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
- (NSArray*) getLvBoDiTongArray;

- (NSString*) getDiTongXieLv;
- (void) controlDiTongXieLv:(NSString*) ditongxielv;
- (NSArray*) getLvBoDiTongXielvArray;

- (NSString*) getBoduanType;
- (void) controlBoduanType:(NSString*) boduanType;
- (NSArray*) getLvBoBoDuanArray;

- (BOOL) isLvboGaotongStart;
- (void) controlLVboGaotongStart:(BOOL) lvboGaotongStart;

- (NSString*) getLvboGaotongPinlv;
- (void) controlLvBoGaotongPinlv:(NSString*) lvbogaotongPinlv;

- (BOOL) islvboBoduanStart;
- (void) controllvboBoduanStart:(BOOL) lvboBoduanStart;

- (NSString*) getlvboBoduanPinlv;
- (void) controllvboBoduanPinlv:(NSString*) lvboBoduanPinlv;

- (NSString*) getlvboBoduanZengyi;
- (void) controllvboBoduanZengyi:(NSString*) lvboBoduanZengyi;

-(NSString*) getlvboBoduanQ;
-(void) controllvboBoduanQ:(NSString*) lvboBoduanQ;

-(BOOL) islvboDitongStart;
-(void) controllvboDitongStart:(BOOL) lvboDitongStart;

-(NSString*) getlvboDitongPinlv;
-(void) controllvboDitongPinlv:(NSString*)lvboDitongPinlv;

//信号发生器
-(NSString*) getXinhaofashengPinlv;
-(void) controlXinHaofashengPinlv:(NSString*)xinhaofashengPinlv;
-(NSString*) getZhengxuanbo;
-(void) controlZhengxuanbo:(NSString*)zhengxuanbo;
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


/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;
- (NSDictionary *)getScenarioSliceLocatedShadow;

@end
