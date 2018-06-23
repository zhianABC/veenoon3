//
//  AudioEProcessor.h
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"
#import "AudioEProcessorSignalProxy.h"
#import "AudioEProcessorAutoMixProxy.h"

@class RgsProxyObj;

@protocol AudioEProcessorDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end

@interface AudioEProcessor : BasePlugElement
{
    
}

@property (nonatomic, weak) id <AudioEProcessorDelegate> delegate;

//<VAProcessorProxys>
@property (nonatomic, strong) NSMutableArray *_inAudioProxys;
//huishengxiaochu
@property (nonatomic, assign) BOOL _isHuiShengXiaoChu;

@property (nonatomic, strong) AudioEProcessorAutoMixProxy *_autoMixProxy;
@property (nonatomic, strong) AudioEProcessorSignalProxy *_singalProxy;

//<VAProcessorProxys>
@property (nonatomic, strong) NSMutableArray *_outAudioProxys;

- (void) checkRgsProxyCommandLoad;

- (NSMutableDictionary *)inputChannelAtIndex:(int)index;
- (NSMutableDictionary *)outChannelAtIndex:(int)index;

//huishengxiaochu
- (void) controlHuiShengXiaoChu:(BOOL)isHuiShengXiaoChu;
- (BOOL) isHuiShengXiaoChuStarted;
- (void) prepareAllAudioInCmds;
- (void) prepareAllAudioOutCmds;
@end
