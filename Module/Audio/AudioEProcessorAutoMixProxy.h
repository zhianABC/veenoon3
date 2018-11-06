//
//  AudioEProcessorAutoMixProxy.h
//  veenoon
//
//  Created by 安志良 on 2018/6/23.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@protocol AudioEProcessorAutoMixProxyDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end

@interface AudioEProcessorAutoMixProxy : NSObject {
    
}
@property (nonatomic, weak) id <AudioEProcessorAutoMixProxyDelegate> delegate;

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
//zidonghunyin
@property (nonatomic, strong) NSString *_zidonghunyinZengYi;
@property (nonatomic, strong) NSMutableDictionary *_inputMap;
@property (nonatomic, strong) NSMutableDictionary *_outputMap;

- (void) checkRgsProxyCommandLoad;
- (void) getCurrentDataState;

//zidonghunyin
- (NSDictionary*)getAutoMixCmdSettings;
- (NSString*) getZidonghuiyinZengYi;

- (void) controlZidongHunyinBtn:(NSString*) proxyName withType:(int)type withState:(BOOL)state;
- (void) controlZiDongHunYinZengYi:(NSString*) zengyiDB;

- (NSArray*) generateEventOperation_inputs;
- (NSArray*) generateEventOperation_outpus;
- (id) generateEventOperation_gain;

/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas;

@end
