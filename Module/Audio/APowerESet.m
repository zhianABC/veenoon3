//
//  APowerESet.m
//  veenoon
//
//  Created by chen jack on 2018/3/30.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "APowerESet.h"

@implementation APowerESet
@synthesize _lines;

@synthesize _brand;
@synthesize _type;
@synthesize _deviceno;
@synthesize _ipaddress;
@synthesize _com;

- (void) initLabs:(int)num{
    
    self._lines = [NSMutableArray array];
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"OFF" forKey:@"status"];
        [dic setObject:@"0" forKey:@"seconds"];
        [dic setObject:[NSString stringWithFormat:@"Channel %02d", i+1] forKey:@"name"];
        [_lines addObject:dic];
    }
    
}

- (void) setLabValue:(BOOL)offon withIndex:(int)index{
    
    NSMutableDictionary *value = [_lines objectAtIndex:index];
    
    if(offon)
    {
         [value setObject:@"ON" forKey:@"status"];
    }
    else
    {
        [value setObject:@"OFF" forKey:@"status"];
    }
}

- (void) setLabDelaySecs:(int)secs withIndex:(int)index{
    
    NSMutableDictionary *value = [_lines objectAtIndex:index];
    [value setObject:[NSString stringWithFormat:@"%d",secs]
              forKey:@"seconds"];
}

- (NSDictionary *)getLabValueWithIndex:(int)index{
    
    return [_lines objectAtIndex:index];
}

@end
