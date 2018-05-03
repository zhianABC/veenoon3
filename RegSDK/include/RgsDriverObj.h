/*!
 @header RgsDriverObj.h
 @brief  设备驱动对象 头文件信息
 这个文件包含设备驱动对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>
#import "RgsDriverInfo.h"

/*!
 @class RgsDriverObj
 @since 3.0.0
 @brief 设备驱动对象
 */

@interface RgsDriverObj : NSObject

/*!
 id
 */
@property NSInteger m_id;

/*!
 名称
 */
@property NSString * name;

/*!
 驱动信息
 @see RgsDriverInfo
 */
@property RgsDriverInfo * info;

/*!
 代理列表
 @see RgsProxyObj
 */
//@property NSArray * proxys;

/*!
 配置内容
 @see RgsPropertyObj
 */
//@property NSArray * properties;

/*!
 事件列表
 @see RgsEventObj
 */
//@property NSArray * events;

/*!
 设备驱动指令
 @see RgsCommandInfo
 */
//@property NSArray * commands;

/*!
 设备驱动连接
 @see RgsConnectionObj
 */
//@property NSArray * connections;

@end
