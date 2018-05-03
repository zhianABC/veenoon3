//
//  AudioEProcessor.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessor.h"

@interface AudioEProcessor ()
{
    
}
@property (nonatomic, strong) NSMutableArray *_inchannels;
@property (nonatomic, strong) NSMutableArray *_outchannels;

@end

@implementation AudioEProcessor
//@synthesize _driver;
@synthesize _driverInfo;

@synthesize _inchannels;
@synthesize _outchannels;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        
        self._inchannels = [NSMutableArray array];
        self._outchannels = [NSMutableArray array];
    }
    
    return self;
}

- (void) initInputChannels:(int)num{
    
    [self._inchannels removeAllObjects];
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:[NSString stringWithFormat:@"Channel %02d", i] forKey:@"name"];
        [dic setObject:@"OFF" forKey:@"status"];
        
        [_inchannels addObject:dic];
    }
}
- (int) inputChannelsCount{
    
    return (int)[_inchannels count];
}
- (NSMutableDictionary *)inputChannelAtIndex:(int)index{

    if(index < [_inchannels count])
        return [_inchannels objectAtIndex:index];
    
    return nil;
}

- (void) initOutChannels:(int)num{
    
    [self._outchannels removeAllObjects];
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:[NSString stringWithFormat:@"Channel %02d", i] forKey:@"name"];
        [dic setObject:@"OFF" forKey:@"status"];
        
        [_outchannels addObject:dic];
    }
}
- (int) outChannelsCount{
    
    return (int)[_outchannels count];
}
- (NSMutableDictionary *)outChannelAtIndex:(int)index{
    
    if(index < [_outchannels count])
        return [_outchannels objectAtIndex:index];
    
    return nil;
}


@end
