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
//zidonghunyin
@property (nonatomic, strong) NSString *_zidonghunyinZengYi;
@property (nonatomic, strong) NSString *_zidonghunyinPinlv;
@property (nonatomic, strong) NSString *_zidonghunyinZhengxuan;
@property (nonatomic, assign) BOOL _isZidonghunyinMute;
@property (nonatomic, strong) NSMutableArray *_zidonghunyinOutputChanels;

- (void) checkRgsProxyCommandLoad;


//zidonghunyin
- (NSDictionary*)getSignalCmdSettings;
- (NSString*) getZidonghuiyinZengYi;
- (void) controlZiDongHunYinZengYi:(NSString*) zengyiDB;
- (NSMutableArray*) getZidonghunyinOutputChanels;
- (void) controlZidonghunyinOutputChanels:(NSMutableArray*)zidonghunyinOutputChanels;
- (NSString*) getZidonghuiyinPinlv;
- (void) controlZiDongHunYinPinlv:(NSString*) pinlv;
- (NSString*) getZidonghuiyinZhengXuan;
- (void) controlZiDongHunYinZhengxuan:(NSString*) zhengxuan;
- (BOOL) isZidonghunyinMute;
- (void) controlZidonghunyinMute:(BOOL)isMute;
@end

