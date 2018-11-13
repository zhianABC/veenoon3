//
//  AudioEWirlessMikeProxy.h
//  veenoon
//
//  Created by chen jack on 2018/11/13.
//  Copyright © 2018 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsProxyObj;

@interface AudioEWirlessMikeProxy : NSObject
{
    
}
@property (nonatomic, strong) RgsProxyObj *_rgsProxyObj;

@property (nonatomic, strong) NSString *_freqVal;//频率
@property (nonatomic, strong) NSArray *_freqops;

@property (nonatomic, strong) NSArray *_groups;//组-通道
@property (nonatomic, strong) NSDictionary *_groupVal;

@property (nonatomic, strong) NSArray *_dbs;//增益
@property (nonatomic, strong) NSString *_dbVal;

@property (nonatomic, strong) NSArray *_sq;
@property (nonatomic, strong) NSString *_sqVal;

- (BOOL) haveProxyCommandLoaded;
- (void) checkRgsProxyCommandLoad:(NSArray*)cmds;
- (void) recoverWithDictionary:(NSArray*)datas;

@end

