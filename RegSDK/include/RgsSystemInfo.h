/*!
 @header RgsSystemInfo.h
 @brief 系统 头文件信息
 
 @author zongtai.ye
 @copyright © 2018年 zongtai.ye.
 @version 18.6.20
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsSystemInfo
 @since 3.6.1
 @brief 系统信息
 */

@interface RgsSystemInfo : NSObject

/*! 系统时间 */
@property NSDate * sys_time;

/*! 软件版本 */
@property NSString * software_version;

/*! 硬件型号 */
@property NSString * hardware;

/*! 自动IP */
@property BOOL auto_ip;

/*! 系统IP地址 */
@property NSString * ip;

/*! 网络掩码 */
@property NSString * mask;

/*! 网关 */
@property NSString * gateway;
@end
