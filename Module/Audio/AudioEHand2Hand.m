//
//  AudioEHand2Hand.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEHand2Hand.h"

@interface AudioEHand2Hand ()
{
    
}
@property (nonatomic, strong) NSMutableArray *_channels;

@end

@implementation AudioEHand2Hand
@synthesize _channels;
@synthesize _dbVal;


- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        self._channels = [NSMutableArray array];
    }
    
    return self;
}

- (int) channelsCount{
    
    return (int)[_channels count];
}

- (void) initChannels:(int)num{
    
    if([_channels count])
        [_channels removeAllObjects];
    
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:[NSString stringWithFormat:@"Channel %02d", i] forKey:@"name"];
        [dic setObject:@"OFF" forKey:@"status"];
        
        [_channels addObject:dic];
    }
    
}

- (NSMutableDictionary *)channelAtIndex:(int)index{
    
    if(index < [_channels count])
        return [_channels objectAtIndex:index];
    
    return nil;
}

@end
