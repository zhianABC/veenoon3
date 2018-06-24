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
@property (nonatomic, strong) NSMutableArray *_zidonghunyinInputChanels;
@property (nonatomic, strong) NSMutableArray *_zidonghunyinOutputChanels;

- (void) checkRgsProxyCommandLoad;


//zidonghunyin
- (NSDictionary*)getAutoMixCmdSettings;
- (NSString*) getZidonghuiyinZengYi;
- (void) controlZiDongHunYinZengYi:(NSString*) zengyiDB;
- (NSMutableArray*) getZidonghunyinInputChanels;
- (void) controlZidonghunyinInputChanels:(NSMutableArray*)zidonghunyinInputChanels;
- (NSMutableArray*) getZidonghunyinOutputChanels;
- (void) controlZidonghunyinOutputChanels:(NSMutableArray*)zidonghunyinOutputChanels;
- (void) controlZidongHunyinBtn:(NSString*) proxyName withType:(int)type withState:(BOOL)state;

@end
