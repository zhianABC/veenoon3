//
//  VideoDVDPlayer.h
//  veenoon
//
//  Created by 安志良 on 2018/3/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoDVDPlayer : NSObject
@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) NSString *_ip;
@property (nonatomic, strong) NSString *_com;
@property (nonatomic, strong) NSString *_action;
@property (nonatomic, strong) NSString *_powerStatus;
@property (nonatomic, strong) NSString *_tanchuStatus;
@property (nonatomic, strong) NSString *_addressStatus;

- (void) setDVDPlayerData:(NSDictionary*)dvdPlayerData;
- (NSDictionary *)dvdPlayerData;

@end
