//
//  VTouyingjiSet.h
//  veenoon
//
//  Created by 安志良 on 2018/4/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"
#import "AudioEMixProxy.h"

@class RgsConnectionObj;

@interface AudioEMix : BasePlugElement


@property (nonatomic, strong) id _comDriverInfo;
@property (nonatomic, strong) id _comDriver;

//<VProjectProxy>
@property (nonatomic, strong) AudioEMixProxy *_proxyObj;

@property (nonatomic, strong) NSArray *_localSavedCommands;


- (NSString*) deviceName;

@end

