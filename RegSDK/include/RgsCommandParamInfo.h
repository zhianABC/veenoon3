/*!
 @header RgsCommandParamInfo.h
 @brief  操作参数对象 头文件信息
 这个文件包含操作参数对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>
#include "RgsConstants.h"

/*!
 @class RgsCommandParamInfo
 @since 3.0.0
 @brief 操作参数对象
 */

@interface RgsCommandParamInfo : NSObject

/*!
 参数类型
 @see RgsConstants.h
 */
@property RgsParamType type;

/*!
 参数称号
 */
@property NSString * title;

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

@end
