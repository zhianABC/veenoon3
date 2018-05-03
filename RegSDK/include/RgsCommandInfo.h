/*!
 @header RgsCommandInfo.h
 @brief  命令信息 头文件信息
 这个文件包含命令信息对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */
#import <Foundation/Foundation.h>

/*!
 @class RgsCommandInfo
 @since 3.0.0
 @brief 控制命令信息
 */

@interface RgsCommandInfo : NSObject

/*! 命令称号 */
@property NSString * title;

/*! 命令名称 */
@property NSString * name;

/*! 命令参数信息列表
 @see RgsCommandParamInfo
 */
@property NSArray * params;

@end
