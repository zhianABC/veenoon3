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
 错误枚举
 */
typedef NS_ENUM(NSInteger,RgsErrorCode){
    RGS_ADD_TO_GATEWAY_FAILED = 4000001,    //向网关注册客户端信息失败
    RGS_LOGIN_PASSWORD_FAILED,              //登录密码错误
    RGS_LOGIN_MOVED_FAILED,                 //注册信息被移除
    RGS_LOGIN_TIMEOUT_FAILED,               //登录超时
    RGS_NO_HANDLER,                         //未获取句柄
    RGS_REQ_TIME_OUT,                       //请求超时
    RGS_SET_PASSWORD_FAILED,                //设置密码失败
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


@interface RgsConstants:NSObject
@end

#endif /* RgsConstants_h */
