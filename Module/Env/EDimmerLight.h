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

@property (nonatomic, strong) NSArray *_localSavedCommands;
@property (nonatomic, strong) NSMutableArray *_proxys;

- (NSString*) deviceName;
- (void) prepareAllCmds;

@end
