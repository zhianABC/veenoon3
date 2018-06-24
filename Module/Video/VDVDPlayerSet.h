//
//  VDVDPlayerSet.h
//  veenoon
//
//  Created by 安志良 on 2018/4/16.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"

@interface VDVDPlayerSet : BasePlugElement

@property (nonatomic, strong) id _IRDriverInfo;
@property (nonatomic, strong) id _IRDriver;

//<VDVDPlayerProxy>
@property (nonatomic, strong) id _proxyObj;

//<RgsConnectionObj>
@property (nonatomic, strong) NSArray *_localSavedProxys;



- (NSString*) deviceName;

@end
