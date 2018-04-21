//
//  AudioEWirlessMike.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEWirlessMike.h"

@interface AudioEWirlessMike ()
{
    
}
@property (nonatomic, strong) NSMutableArray *_channels;

@end


@implementation AudioEWirlessMike
@synthesize _channels;


- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        self._channels = [NSMutableArray array];
    }
    
    return self;
}

- (void) initChannels:(int)num{
    
    if([_channels count])
        [_channels removeAllObjects];
    
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:[NSString stringWithFormat:@"%02d", i] forKey:@"name"];
        [dic setObject:@"OFF" forKey:@"status"];
        [dic setObject:@0 forKey:@"db"];
        [dic setObject:@4 forKey:@"signal"];
        [dic setObject:@80 forKey:@"battery"];
        [dic setObject:@"huatong" forKey:@"type"];
        
        [_channels addObject:dic];
    }
    
}

- (int) channelsCount{
    
    return [_channels count];
}

- (NSMutableDictionary *)channelAtIndex:(int)index{
    
    if(index < [_channels count])
        return [_channels objectAtIndex:index];
    
    return nil;
}


@end
