//
//  ComDriver.h
//  veenoon
//
//  Created by chen jack on 2018/5/10.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "BasePlugElement.h"

@interface ComDriver : BasePlugElement
{
    
}

//<RgsConnectionObj>

@property (nonatomic, strong) NSArray *_comConnections;

@property (nonatomic, strong) NSArray *_localSavedProxys;


@end
