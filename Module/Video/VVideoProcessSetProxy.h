//
//  VVideoProcessSetProxy.h
//  veenoon
//
//  Created by 安志良 on 2018/6/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RgsProxyObj;

@protocol VVideoProcessSetProxyDelegate <NSObject>

@optional
- (void) didLoadedProxyCommand;

@end

@interface VVideoProcessSetProxy : NSObject {
    
}

@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;
@property (nonatomic, weak) id <VVideoProcessSetProxyDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *_deviceMatcherDic;;

- (void) checkRgsProxyCommandLoad;

- (NSDictionary*)getVideoProcessInputSettings;
- (NSDictionary*)getVideoProcessOutputSettings;

/////场景还原
- (void) recoverWithDictionary:(NSDictionary*)data;

- (void) controlDeviceAdd:(NSString*)inputName withOutDevice:(NSString*)outputName;

//生成场景片段
- (NSArray* ) generateEventOperation_p2p;


@end
