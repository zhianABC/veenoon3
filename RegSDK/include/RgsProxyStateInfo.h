/*!
 @header RgsProxyStateInfo.h
 @brief  代理状态信息描述 头文件信息
 这个文件包含代理状态信息的描述
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */
#import <Foundation/Foundation.h>
#include "RgsConstants.h"

/*!
 @class RgsProxyStateInfo
 @since 3.0.0
 @brief 设备状态信息对象
 */
@interface RgsProxyStateInfo : NSObject
/*!
 参数类型
 @see RgsConstants.h
 */
@property RgsParamType type;

/*!
 参数名称
 */
@property NSString * name;

/*!
 参数可选项
 */
@property NSArray * available;

/*!
 参数最大范围
 */
@property NSString * max;

/*!
 参数最小范围
 */
@property NSString * min;

/*!
 依赖命令
 */
@property NSString * depend_cmd;

@end
