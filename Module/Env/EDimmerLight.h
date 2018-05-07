//
//  EDimmerLight.h
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"

@interface EDimmerLight : BasePlugElement
{
    
}

@property (nonatomic, strong) id _driverInfo;
@property (nonatomic, strong) id _driver;
@property (nonatomic, strong) NSArray *_localSavedCommands;

//<EDimmerLightProxys>
@property (nonatomic, strong) id _proxyObj;


- (void) syncDriverIPProperty;
- (void) uploadDriverIPProperty;

- (void) createDriver;
- (void) removeDriver;

- (NSString*) deviceName;


@end
