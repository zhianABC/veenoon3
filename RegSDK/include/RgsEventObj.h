/*!
 @header RgsEventObj.h
 @brief  事件对象 头文件信息
 这个文件包含事件对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>


/*!
 @class RgsEventObj
 @since 3.0.0
 @brief 事件对象
 */
@interface RgsEventObj : NSObject

/*!
 所属设备ID
 */
@property NSInteger parent_id;

/*!
 所属设备名称
 */
//@property NSString * parent_name;

/*!
 所属设备所在
 */
//@property NSString * parent_location;

/*!
id
*/
@property NSInteger m_id;

/*!
 名称
 */
@property NSString * name;

/*!
 描述
 */
@property NSString * describe;
@end
