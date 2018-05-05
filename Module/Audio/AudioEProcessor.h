//
//  AudioEProcessor.h
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"


@interface AudioEProcessor : BasePlugElement
{
    
}
@property (nonatomic, strong) id _driverInfo;
@property (nonatomic, strong) id _driver;

//<VAProcessorProxys>
@property (nonatomic, strong) NSArray *_inAudioProxys;

//<VAProcessorProxys>
@property (nonatomic, strong) NSArray *_outAudioProxys;

- (void) syncDriverIPProperty;
- (void) uploadDriverIPProperty;

- (void) createDriver;
- (void) removeDriver;

- (NSString*) deviceName;

@end
