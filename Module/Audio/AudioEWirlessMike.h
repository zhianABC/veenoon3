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
@property (nonatomic, strong) NSString *_freqVal;//频率
@property (nonatomic, strong) NSArray *_freqops;

@property (nonatomic, strong) NSArray *_groups;//组-通道
@property (nonatomic, strong) NSDictionary *_groupVal;

@property (nonatomic, strong) NSArray *_dbs;//增益
@property (nonatomic, strong) NSString *_dbVal;

@property (nonatomic, strong) NSArray *_sq;
@property (nonatomic, strong) NSString *_sqVal;
//初始化channels
- (void) initChannels:(int)num;

//初始化data，从中控拿到的
- (void) fillDataFromCtrlCenter;


- (int) channelsCount;
- (NSMutableDictionary *)channelAtIndex:(int)index;
- (NSArray*)channles;



@end
