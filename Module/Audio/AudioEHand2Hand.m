//
//  AudioEHand2Hand.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEHand2Hand.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"

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
        
        
        
        self._show_icon_name = @"a_yx_3.png";
        self._show_icon_sel_name = @"a_yx_3_sel.png";
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


- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AudioEHand2Hand);
        
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
                                             serial:info.serial
                                         completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
                                             if (result) {
                                                 
                                                 block_self._driver = driver;
                                                 block_self._name = driver.name;
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
                                             }
                                             [KVNProgress showSuccess];
                                         }];
    }
}


@end
