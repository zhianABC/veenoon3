/*!
 @header RgsDriverInfo.h
 @brief  设备驱动信息 头文件信息
 这个文件包含设备驱动信息的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>
#import "RgsConstants.h"

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

/*！
 类型
 */
@property RgsDriverType type;


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

/*!
 品牌
 */
@property NSString * brand;

/*!
 所属系统
 */
@property NSString * system;

/*!
 产品类型
 */
@property NSString * main_class;

/*!
 子类
 */
@property NSString * sub_class;

/*!
 适用型号
 */
@property NSString * model;
@end
