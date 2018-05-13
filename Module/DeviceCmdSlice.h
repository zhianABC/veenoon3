//
//  DeviceCmdSlice.h
//  veenoon
//
//  Created by chen jack on 2018/5/13.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BasePlugElement;
@class RgsSceneOperation;

@interface DeviceCmdSlice : NSObject
{
    
}
@property (nonatomic, strong) NSString *_deviceName;
@property (nonatomic, strong) NSString *_cmdNickName;
@property (nonatomic, strong) NSString *_proxyName;
@property (nonatomic, strong) NSString *_value;

@property (nonatomic, assign) NSInteger dev_id;
@property (nonatomic, strong) NSString *cmd;
@property (nonatomic, strong) NSDictionary *param;

@property (nonatomic, strong) BasePlugElement *_plug;
@property (nonatomic, strong) RgsSceneOperation * _opt;

@end
