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

- (void) initLabs:(int)num{
    
    self._lines = [NSMutableArray array];
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"OFF" forKey:@"status"];
        [dic setObject:@"1" forKey:@"value"];
        [_lines addObject:dic];
    }
    
}

@end
