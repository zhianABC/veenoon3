/*!
 @header RgsConstants.h
 @brief  枚举类型 头文件信息
 这个文件包含主要是用的枚举类型信息
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#ifndef RgsConstants_h
#define RgsConstants_h
#import <Foundation/Foundation.h>
#define RegulusErrorDomain @"com.regulus.sdk"


/*!
 当前登录状态
 */
 typedef NS_ENUM(NSInteger,RgsLoginStatus)
{
    RGS_LOGIN_NONE,
    RGS_LOGIN_ONLINE,
    RGS_LOGIN_OFFLINE,
};


/*!
 指令参数类型枚举
 */
typedef NS_ENUM(NSInteger,RgsParamType)
{
    RGS_PARAM_TYPE_NONE = -1,
    RGS_PARAM_TYPE_INT  = 0,    //整形类型
    RGS_PARAM_TYPE_STRING,      //字符类型
    RGS_PARAM_TYPE_LIST,       //单选列表类型
    RGS_PARAM_TYPE_FLOAT,      //浮点类型
    RGS_PARAM_TYPE_MULLIST,    //多选列表类型
    RGS_PARAM_TYPE_DATE,       //日期类型
    RGS_PARAM_TYPE_IP,         //IP类型
    RGS_PARAM_TYPE_TIME,       //时间类型
};

/*!
 重复类型枚举
 */

typedef NS_ENUM(NSInteger,RgsFrequencyType)
{
    RGS_FREQUENCY_NONE = 0,
    RGS_FREQUENCY_DAILY=1,     //日重复
    RGS_FREQUENCY_WEEKLY,      //周重复
    RGS_FREQUENCY_MONTHLY,     //月重复
    RGS_FREQUENCY_YEARLY,      //年重复
};

/*!
 驱动类型
 */
typedef NS_ENUM(NSInteger,RgsDriverType)
{
    RGS_DRIVER_TYPE_NONE=0,
    RGS_DRIVER_TYPE_PHYSICAL=1,
    RGS_DRIVER_TYPE_PROXY,
    RGS_DRIVER_TYPE_FUNCTION,
};

/*!
 红外控制器模版
 */
typedef NS_ENUM(NSInteger,RgsIrModel){
   RGS_IR_M_TV=1,
   RGS_IR_M_DVD,
   RGS_IR_M_VIDEOBOX,
   RGS_IR_M_AC,
};

/*!
 红外录码状态
 */
typedef NS_ENUM(NSInteger,RgsIrRecordStatus){
    RGS_IR_RECORD_WAIT=0,
    RGS_IR_RECORD_DONE,
    RGS_IR_RECORD_TIMEOUT,
};

/*!
 通知状态
 */
typedef NS_ENUM(NSInteger,RgsNotifyStatus){
    RGS_NOTIFY_STATUS_START=0,
    RGS_NOTIFY_STATUS_DONE,
    RGS_NOTIFY_STATUS_FAILED,
    RGS_NOTIFY_STATUS_TIMEOUT,
};


@interface RgsConstants:NSObject
@end

#endif /* RgsConstants_h */
