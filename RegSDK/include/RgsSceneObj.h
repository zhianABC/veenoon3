/*!
 @header RgsSceneObj.h
 @brief  情景对象 头文件信息
 这个文件包含情景对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsSceneObj
 @since 3.4.1
 @brief 情景对象
 */

@interface RgsSceneObj : NSObject

/*!
 情景ID
 */
@property NSInteger m_id;

/*!
 情景名称
 */
@property NSString * name;

/*!
 情景执行后使用标记
 */
@property BOOL enable;

@end
