//
//  AudioEProcessorAutoMixProxy.h
//  veenoon
//
//  Created by 安志良 on 2018/6/23.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@protocol AudioEProcessorSignalProxyDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end

@interface AudioEProcessorSignalProxy : NSObject {
    
}
@property (nonatomic, weak) id <AudioEProcessorSignalProxyDelegate> delegate;

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
//xinhaofasheng
@property (nonatomic, strong) NSString *_xinhaofashengZengYi;
@property (nonatomic, strong) NSString *_xinhaofashengPinlv;
@property (nonatomic, strong) NSString *_xinhaofashengZhengxuan;
@property (nonatomic, assign) BOOL _isXinhaofashengMute;
@property (nonatomic, strong) NSMutableDictionary *_xinhaofashengOutputChanels;

- (void) checkRgsProxyCommandLoad;


//zidonghunyin
- (NSString*) getXinhaofashengZengYi;
- (void) controlXinhaofashengZengYi:(NSString*) zengyiDB;
- (NSString*) getXinhaofashengPinlv;
- (void) controlXinhaofashengPinlv:(NSString*) pinlv;
- (NSString*) getXinhaofashengZhengXuan;
- (void) controlXinhaofashengZhengxuan:(NSString*) zhengxuan;
- (BOOL) isXinhaofashengMute;
- (void) controlXinhaofashengMute:(BOOL)isMute;
- (NSArray*) getSignalType;
- (NSDictionary*) getSignalGainSettings;
- (NSDictionary*) getSignalRateSettings;


- (void) controlSignalWithOutState:(NSString*) proxyName withState:(BOOL)state;

- (NSArray*) generateEventOperation_sigOut;
- (id) generateEventOperation_sigMute;
- (id) generateEventOperation_sigType;
- (id) generateEventOperation_sigSineRate;
- (id) generateEventOperation_sigGain;

/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas;


@end

