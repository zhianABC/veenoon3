//
//  BlindPlugin.h
//  veenoon
//
//  Created by 安志良 on 2018/8/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"
#import "BlindPluginProxy.h"

@class RgsConnectionObj;

@interface BlindPlugin : BasePlugElement

//<BlindPluginProxy>
@property (nonatomic, strong) BlindPluginProxy *_proxyObj;
@property (nonatomic, strong) NSArray *_localSavedCommands;

@end
