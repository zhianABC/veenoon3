//
//  UserSensorObj.h
//  veenoon
//
//  Created by 安志良 on 2018/9/16.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsDriverObj;

@interface UserSensorObj : NSObject {
    
}
@property (nonatomic, strong) RgsDriverObj *rgsDriverObj;
@property (nonatomic, strong) NSMutableArray *connectionObjArray;

- (void) getMyConnects;

@end
