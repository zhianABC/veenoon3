//
//  AudioEWirlessMike.h
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"

//无线麦
@interface AudioEWirlessMike : BasePlugElement
{
    
}
@property (nonatomic, strong) id _proxyObj;
@property (nonatomic, strong) NSArray *_localSavedCommands;
//<AudioEWirlessMikeProxy>
@property (nonatomic, strong) NSMutableArray *_proxys;

- (NSString*) deviceName;

@end
