//
//  RgsAutomationObj.h
//  RegulusSDK
//
//  Created by Regulus on 2018/9/25.
//  Copyright © 2018年 zongtai.ye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RgsConstants.h"

@interface RgsAutomationObj : NSObject
/*!
 自动化ID
 */
@property NSInteger m_id;

/*!
 名称
 */
@property NSString * name;

/*!
 图片名称
 */
@property NSString * image;

/*!
 条件类型
 */
@property RgsCondIfType if_type;

/*!
 代理ID
 */
@property NSInteger proxy_id;
@end
