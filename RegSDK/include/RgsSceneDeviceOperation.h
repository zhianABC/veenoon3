/*!
 @header RgsSceneDeviceOperation.h
 @brief  情景操作对象 头文件信息
 这个文件包含情景操作对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsSceneDeviceOperation
 @since 3.0.0
 @brief 区域设备情景操作对象
 */

@interface RgsSceneDeviceOperation : NSObject
/*!
 设备ID
 */
@property NSInteger dev_id;

/*!
 操作命令
 */
@property NSString * cmd;

/*!
 操作参数
 */
@property NSDictionary * param;

/*!
 操作描述 3.9.1
 */
@property NSString * descripe;


/*!
 设备名称
 */
@property NSString * name;

/*!
 所在位置
 */
@property NSString * location;

@end

/*!
 条件类型枚举
 */
typedef NS_ENUM(NSInteger,RgsCondType)
{
    RGS_COND_TYPE_EQUAL=1,    // ==
    RGS_COND_TYPE_GREATER,  // >
    RGS_COND_TYPE_LESS,     // <
    RGS_COND_TYPE_GE,       // >=
    RGS_COND_TYPE_LE,       // <=
    RGS_COND_TYPE_NE,       // !=
    RGS_COND_TYPE_CONTAIN   //包含
};

/*!
 @class RgsSceneCondOperation
 @since 3.0.0
 @brief 情景条件操作对象
 */
@interface RgsSceneCondOperation: NSObject
/*!
 设备ID
 */
@property NSInteger dev_id;
/*!
 条件类型
 */
@property RgsCondType cond;
/*!
 待比较的参数名字
 */
@property NSString * state_name;
/*!
 比较值，若是数字，转为保留两位小数的字符串
 */
@property NSString * state_value;


/*!
 操作描述
 */
@property NSString * descripe;


/*!
 设备名称
 */
@property NSString * name;

/*!
 所在位置
 */
@property NSString * location;

/*!
 条件下的操作列表
 @see RgsSceneOperation
 */
@property NSArray * operations;



/*!
 @since 3.0.0
 @brief 设置条件满足下的子操作
 @param operations RgsSceneOperation对象列表
 @see RgsSceneOperation
 */
-(BOOL)set_operations:(NSArray * )operations;
@end


/*!
 @class RgsSceneOperation
 @since 3.0.0
 @brief 情景操作对象
 */

@interface RgsSceneOperation:NSObject
/*!
 @since 3.0.0
 @brief 设备操作命令类型构造函数
 @param dev_id   设备ID
 @param cmd      操作命令
 @param param    操作参数
 @see RgsSceneDeviceOperation
 */
-(id)initCmdWithParam:(NSInteger)dev_id cmd:(NSString *)cmd param:(NSDictionary *)param;

/*!
 @since 3.0.0
 @brief 设备操作命令类型构造函数
 @param dev_id   设备ID
 @param cond          条件类型
 @param param_name    待比较的参数名字
 @param param_value   比较值，若是数字，转为保留两位小数的字符串
 @param operations RgsSceneOperation对象列表
 @see RgsSceneCondOperation
 @see RgsSceneOperation
 */
-(id)initCondWithParam:(NSInteger)dev_id
                  cond:(RgsCondType)cond
            param_name:(NSString *)param_name
           param_value:(NSString *)param_value
            operations:(NSArray *)operations;

/*!
 @since 3.0.0
 @brief 获取情节操作子对象
 @return 返回RgsSceneDeviceOperation或RgsSceneCondOperation
 @see RgsSceneDeviceOperation
 @see RgsSceneCondOperation
 */
-(id)getOperation;

/*!
 @since 3.9.1
 @brief 设置描述
 */
-(void)set_descripe:(NSString *)descripe;


-(void)set_location:(NSString *)location;

-(void)set_name:(NSString *)name;
@end






