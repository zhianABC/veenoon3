//
//  APowerESet.h
//  veenoon
//
//  Created by chen jack on 2018/3/30.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"

//电源管理器
@interface APowerESet : BasePlugElement
{
    
}
@property (nonatomic, strong) NSMutableArray *_lines;
@property (nonatomic, strong) id _proxyObj;
@property (nonatomic, strong) NSArray *_localSavedCommands;
//<APowerSetProxy>
@property (nonatomic, strong) NSMutableArray *_proxys;
@property (nonatomic, assign) BOOL _isSetAllOnOff;
@property (nonatomic, strong) NSString* _linkVal;

- (NSString*) deviceName;

- (void) initLabs:(int)num;

- (void) setLabValue:(BOOL)offon withIndex:(int)index;
- (void) setLabDelaySecs:(int)secs withIndex:(int)index;
- (NSDictionary *)getLabValueWithIndex:(int)index;

- (int) checkIsSameSeconds;
- (void) prepareAllCmds;

- (void) controlPower:(BOOL)isPowerOn;
- (void) checkRgsDriverCommandLoad;

- (id) generateEventOperation_power;

- (BOOL) checkIsPowerOff;

@end
