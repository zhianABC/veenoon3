//
//  VideoRemoteShiXun.h
//  veenoon
//
//  Created by 安志良 on 2018/3/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoRemoteShiXun : NSObject
@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) NSString *_ip;
@property (nonatomic, strong) NSString *_com;
@property (nonatomic, strong) NSArray *_irArray;

- (void) setVideoRemoteData:(NSDictionary*)videoRemote;
- (NSDictionary *)videoRemote;

@end
