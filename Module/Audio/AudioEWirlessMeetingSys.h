//
//  AudioEWirlessMeetingSys.h
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"

//无线会议
@interface AudioEWirlessMeetingSys : BasePlugElement
{
    
}
- (void) initChannels:(int)num;

- (NSMutableDictionary *)channelAtIndex:(int)index;

@end
