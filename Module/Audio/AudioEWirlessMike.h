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

- (int) channelsCount;
- (void) initChannels:(int)num;

- (NSMutableDictionary *)channelAtIndex:(int)index;
- (NSArray*)channles;



@end
