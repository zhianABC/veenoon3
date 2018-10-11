/*!
 @header RgsProxyObj.h
 @brief  代理对象 头文件信息
 这个文件包含代理对象的主要方法和属性声明
 配置的工程时，工程人员获取的驱动对象下的代理，当这个工程运行时，代理对象会有一个设备对象对应。
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsProxyObj
 @since 3.0.0
 @brief 代理对象
 */

@interface RgsProxyObj : NSObject

/*!
 ID
 */
@property NSInteger m_id;

/*!
 代理类型
 */
@property NSString * type;

/*!
 设备显示名称
 */
@property NSString * name;

/*!
 所属设备驱动ID
 */
@property NSInteger driver_id;

/*!
所属分类
 */
@property NSString * classify;


/*!
 所属区域id
 */
@property NSInteger area_id;

/*!
 所属区域名称
 */
@property NSString * location;


@end
