/*!
 @header RgsDeviceNoteObj.h
 @brief  设备状态通知对象
 这个文件包设备状态通知对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsDeviceNoteObj
 @since 3.0.0
 @brief 设备通知对象
 */

@interface RgsDeviceNoteObj : NSObject

//设备id
@property NSInteger device_id;

//通知标题
@property NSDictionary * param;

//通知参数
@property NSString * notify;

@end
