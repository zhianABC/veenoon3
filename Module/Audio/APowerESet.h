//
//  APowerESet.h
//  veenoon
//
//  Created by chen jack on 2018/3/30.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>


//电源管理器
@interface APowerESet : NSObject
{
    
}
@property (nonatomic, strong) NSMutableArray *_lines;

@property (nonatomic, strong) NSString *_brand;
@property (nonatomic, strong) NSString *_type;
@property (nonatomic, strong) NSString *_deviceno;
@property (nonatomic, strong) NSString *_ipaddress;
@property (nonatomic, strong) NSString *_com;

- (void) initLabs:(int)num;

- (void) setLabValue:(BOOL)offon withIndex:(int)index;
- (void) setLabDelaySecs:(int)secs withIndex:(int)index;
- (NSDictionary *)getLabValueWithIndex:(int)index;

@end
