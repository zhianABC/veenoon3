/*!
 @header RgsPropertyObj.h
 @brief  驱动参数对象 头文件信息
 这个文件包含驱动参数对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */


#import <Foundation/Foundation.h>
#include "RgsConstants.h"

/*!
 @class RgsPropertyObj
 @since 3.0.0
 @brief 驱动参数对象
 */


@interface RgsPropertyObj : NSObject
/*!
 参数类型
 @see RgsConstants.h
 */
@property RgsParamType type;

/*!
 名称
 */
@property NSString * name;

/*!
 值
 */
@property NSString * value;

/*!
 最大整数
 */
@property NSString * max;

/*!
 最小整数
 */
@property NSString * min;

/*!
 列表可选内容
 */
@property NSArray * availabel_items;
@end
