/*!
 @header RgsDriverInfo.h
 @brief  设备驱动信息 头文件信息
 这个文件包含设备驱动信息的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsDriverInfo
 @since 3.0.0
 @brief 设备驱动信息
 */

@interface RgsDriverInfo : NSObject
/*!
 名字
 */
@property NSString * name;

/*!
 品牌
 */
@property NSString * brand;
/*!
 类别
 */
@property NSString * classify;
/*!
 序列号
 */
@property NSString * serial;

/*!
 驱动文件
 */
@property NSString * file;

/*!
 版本
 */
@property NSString * version;

/*!
 作者
 */
@property NSString * author;

/*!
 创建时间
 */
@property NSDate * create_date;

/*!
 修改时间
 */
@property NSDate * modify_date;

@end
