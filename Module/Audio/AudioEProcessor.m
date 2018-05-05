//
//  AudioEProcessor.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessor.h"
#import "RegulusSDK.h"

@interface AudioEProcessor ()
{
    
}
//以后实现
@property (nonatomic, strong) NSMutableArray *_inchannels;
@property (nonatomic, strong) NSMutableArray *_outchannels;

@property (nonatomic, strong) RgsPropertyObj *_driver_ip_Property;

@end

@implementation AudioEProcessor

//中控上对应的数据
@synthesize _driver;
@synthesize _driverInfo;
@synthesize _driver_ip_Property;
@synthesize _inAudioProxys;
@synthesize _outAudioProxys;

//配置数据，保存从中控数据结构转换来的数据
//以后实现
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

- (void) syncDriverIPProperty{
    
    if(_driver_ip_Property)
    {
        self._ipaddress = _driver_ip_Property.value;
        return;
    }
    
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(AudioEProcessor);
        
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverProperties:rd.m_id completion:^(BOOL result, NSArray *properties, NSError *error) {
            if (result) {
                if ([properties count]) {
                    
                    for(RgsPropertyObj *pro in properties)
                    {
                        if([pro.name isEqualToString:@"IP"])
                        {
                            block_self._driver_ip_Property = pro;
                            block_self._ipaddress = pro.value;
                        }
                    }
                }
            }
            else
            {
                
            }
        }];
    }
}

- (void) uploadDriverIPProperty
{
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(AudioEProcessor);
        
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        
        //保存到内存
        _driver_ip_Property.value = self._ipaddress;
        
        [[RegulusSDK sharedRegulusSDK] SetDriverProperty:rd.m_id
                                          property_name:_driver_ip_Property.name
                                         property_value:self._ipaddress
                                             completion:^(BOOL result, NSError *error) {
            if (result) {
                
                [block_self saveProject];
            }
            else{
                
            }
        }];
    }
}

- (void) saveProject{
    
    [[RegulusSDK sharedRegulusSDK] ReloadProject:^(BOOL result, NSError *error) {
        if(result)
        {
            NSLog(@"reload project.");
        }
        else{
            NSLog(@"%@",[error description]);
        }
    }];
}

@end
