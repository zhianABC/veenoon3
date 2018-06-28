//
//  AirConditionPlug.h
//  veenoon
//
//  Created by chen jack on 2018/6/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "BasePlugElement.h"

@interface AirConditionPlug : BasePlugElement
{
    
}
@property (nonatomic, strong) id _IRDriverInfo;
@property (nonatomic, strong) id _IRDriver;

//<VDVDPlayerProxy>
@property (nonatomic, strong) id _proxyObj;

//<RgsConnectionObj>
@property (nonatomic, strong) NSArray *_localSavedProxys;



- (NSString*) deviceName;

@end
