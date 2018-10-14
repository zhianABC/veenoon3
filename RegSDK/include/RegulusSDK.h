/*!
 @header RegulusSDK.h
 @brief  RegulusSDK主要API 头文件信息
 @discussion
    API为RgsAreaObj、RgsDriverObj、RgsConnectionObj提供查、增、删、减、改的方法。
 以及登录、登出、修改密码、新建工程、执行工程、编辑场景等方法。
    API包含工程配置接口、用户日常使用接口这两部分。但不作严格区分，
 以方便二次开发者根据实际方便调用。
    本API提供接口供开发人员使用，二次开发人员应根据APP实际应用，去区分用户的使用权限。
 建议至少区分两个种权限。工程人员、用户。
 用户一般不需要关心RgsDriverObj,RgsConnectionObj这类和工程配置的类和方法。
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>
#include "RgsConstants.h"
#import "RgsDeviceNoteObj.h"
#import "RgsSceneObj.h"
#import "RgsAreaObj.h"
#import "RgsSceneDeviceOperation.h"
#import "RgsCommandInfo.h"
#import "RgsCommandParamInfo.h"
#import "RgsSchedulerObj.h"
#import "RgsDriverObj.h"
#import "RgsDriverInfo.h"
#import "RgsProxyObj.h"
#import "RgsEventObj.h"
#import "RgsConnectionObj.h"
#import "RgsPropertyObj.h"
#import "RgsProxyStateInfo.h"
#import "RgsSystemInfo.h"
#import "RgsUpdatePacketInfo.h"
#import "RgsAutomationObj.h"


@protocol RegulusSDKDelegate <NSObject>
@optional -(void) onConnectChanged:(BOOL)connect;
@optional -(void) onRecvDeviceNotify:(RgsDeviceNoteObj *) notify;
@optional -(void) onIrcodeRecord:(NSString *)serial key:(NSString *)key status:(RgsIrRecordStatus)status;
@optional -(void) onExportProject:(RgsNotifyStatus) status;
@optional -(void) onImportProject:(RgsNotifyStatus) status;
@optional -(void) onDepressUpdatePacket:(RgsNotifyStatus) status persent:(CGFloat)persent error:(NSError *)error;
@optional -(void) onDownloadUpdatePacket:(RgsNotifyStatus) status persent:(CGFloat)persent error:(NSError *)error;
@optional -(void) onDownloadFile:(NSString *)file persent:(float)persent;
@optional -(void) onUploadFile:(NSString *)file persent:(float)persent;
@optional -(void) onSystemWillReboot:(NSString *) reason;
@optional -(void) onUploadProject:(RgsNotifyStatus) status persent:(CGFloat)persent error:(NSError *)error;
@optional -(void) onDownloadProject:(RgsNotifyStatus) status persent:(CGFloat)persent error:(NSError *)error;
@optional -(void) onDownloadPlugin:(RgsNotifyStatus) status name:(NSString *)name persent:(CGFloat)persent error:(NSError *)error;
@optional -(void) onRecvDeviceCapbility:(NSInteger)proxy_id cap:(NSDictionary *)cap;
@optional -(void) onRecvCommandInfo:(NSInteger)dev_id commds:(NSArray *)commds;
@optional -(void) onLocalModelDownloadFiles:(NSString *)decription persent:(CGFloat)persent;
@end

@interface RegulusSDK : NSObject
@property (nonatomic,assign) id<RegulusSDKDelegate> delegate;
+(RegulusSDK *) sharedRegulusSDK;

/*!
   @since 1.0.0
   @brief 获取SDK版本号
   @return 版本号
 */
+(NSString *) GetVersion;

/*!
   @since 1.0.0
   @brief 登录网关
   @discussion 登录目标中控。调用本函数后，SDK获取会话句柄。
   @param user_id  网关分配的客户ID
   @param gw_id    网关ID
   @param password 一级密码
   @param level    登录等级,为1时需要验证一级密码 为0时不验证密码
   @param completion 回调block，正常时返回登录结果(result)以及登录等级(level)
 */
-(void) Login:(NSString *)user_id
        gw_id:(NSString *)gw_id
     password:(NSString *)password
        level:(int)level
   completion:(void(^)(BOOL result,NSInteger level,NSError * error)) completion;


/*!
   @since 3.10.3
   @brief 登出网关
   @discussion 登出中控，调用本函数后，SDK销毁会话句柄。
   @param completion 回调block，正常时返回登出结果(result)
 */
-(void) Logout:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.10.3
 @brief 暂停使用，用于进入后台前调用，释放网络资源
 @param completion 回调block，正常时返回登出结果(result)
 */
-(void) Pause:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.10.3
 @brief 恢复使用，用于进入前台后调用，重新获取网络资源
 @param completion 回调block，正常时返回登出结果(result)
 */
-(void) Resume:(void(^)(BOOL result,NSError * error)) completion;


/*!
 @since 3.10.3
 @brief 判断登陆状况
 @return YES已经登陆 NO未登陆
 */
-(BOOL) IsLoginBeforce;



/*!
   @since 1.0.0
   @brief 设置一级密码
 
   @param user_id  网关分配的客户ID
   @param old_ps   原来密码
   @param new_ps   新密码
   @param completion 回调block，正常时返回登出结果(result)
 */
-(void)SetPassword:(NSString *)user_id
            old_ps:(NSString *)old_ps
            new_ps:(NSString *)new_ps
        completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
   @since 1.0.0
   @brief 获取区域对象
   @param completion 回调block，正常时返回RgsAreaObj对象数组
   @see RgsAreaObj
 */
-(void) GetAreas:(void(^)(NSArray *AreaObjs,NSError * error)) completion;

/*!
   @since 1.0.0
   @brief 控制设备
 
   @param dev_id     待控设备ID
   @param cmd        控制命令
   @param param      控制参数
   @param completion 回调block，正常时返回YES
   @see RgsDeviceObj
 */
-(void) ControlDevice:(unsigned long)dev_id
                  cmd:(NSString *)cmd
                param:(NSDictionary *)param
           completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.10.4
 @brief 控制设备
 
 @param dev_operations  设备操作列表
 @param completion 回调block，正常时返回YES
 @see RgsSceneOperation
 */
-(void) ControlDeviceByOperation:(NSArray *)dev_operations
                      completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
   @since 1.0.0
   @brief 执行情景
 
   @param scene_id     待控情景ID
   @param completion 回调block，正常时返回YES
   @see RgsSceneObj
 */
-(void) ExecScene:(unsigned long)scene_id
       completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.3.1
 @brief 向网关添加用户请求
 @discussion APP在首次登录中控前，应该先向该中控调用本函数申请。获取中控返回的可用客户ID。APP开发者应保存中控返回的客户ID以方便登录使用。
 @param gw_id    网关ID 扫描二维码获取中控设备ID
 @param completion 回调block，result:添加结果,client_id: 登陆使用的ID
 */
-(void)RequestJoinGateWay:(NSString *)gw_id completion:(void (^)(BOOL result,NSString * client_id,NSError * error))completion;

/*!
   @since 3.0.0
   @brief 新建工程
   @param author           创建者
   @param completion       回调block 正常时返回YES
 */
-(void)NewProject:(NSString *)author completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
   @since 3.0.0
   @brief 创建区域
   @param name         区域名称
   @param completion   回调block 正常时返回YES area:新建区域对象
   @see RgsAreaObj
 */
-(void)CreateArea:(NSString *)name
       completion:(void(^)(BOOL result,RgsAreaObj * area,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 修改区域名字
   @param name         区域名称
   @param completion       回调block 正常时返回YES
   @see RgsAreaObj
 */
-(void)RenameArea:(NSInteger) area_id
             name:(NSString *)name
       completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 删除区域
   @param area_id         区域ID
   @param completion      回调block 正常时返回YES
   @see RgsAreaObj
 */
-(void)DeleteArea:(NSInteger) area_id
       completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
   @since 3.2.1
   @brief 查询区域场景
   @param area_id         区域ID
   @param completion      回调block 正常时返回YES scene为RgsSceneObj列表
   @see RgsSceneObj
 */
-(void)GetAreaScenes:(NSInteger)area_id
          completion:(void(^)(BOOL result,NSArray * scenes,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 添加设备驱动
   @param area_id         所在区域id
   @param serial          驱动序列
   @param completion      回调block 正常时返回YES driver 添加的驱动对象
   @see RgsDriverObj
 */
-(void)CreateDriver:(NSInteger)area_id
             serial:(NSString *)serial
         completion:(void(^)(BOOL result,RgsDriverObj * driver ,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 删除设备驱动
   @param driver_id       驱动id
   @param completion      回调block 正常时返回YES
   @see RgsDriverObj
 */
-(void)DeleteDriver:(NSInteger)driver_id
         completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 修改设备驱动名字
   @param driver_id       驱动 id
   @param name            驱动名字
   @param completion      回调block 正常时返回YES
   @see RgsDriverObj
 */
-(void)RenameDriver:(NSInteger)driver_id
              name:(NSString *)name
        completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 修改设备驱动参数
   @param driver_id       驱动 id
   @param property_name   参数名称
   @param property_value  参数值
   @param completion      回调block 正常时返回YES
   @see RgsDriverObj
   @see RgsPropertyObj
 */
-(void)SetDriverProperty:(NSInteger)driver_id
           property_name:(NSString *)property_name
          property_value:(NSString *)property_value
              completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
   @since 3.0.0
   @brief 查询区域设备驱动
   @param area_id       区域id
   @param completion      回调block 正常时返回YES drivers:RgsDriverObj列表
   @see RgsDriverObj
 */
-(void)GetDrivers:(NSInteger)area_id
       completion:(void(^)(BOOL result,NSArray * drivers,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询区域代理
 @param area_id    区域ID
 @param completion      回调block 正常时返回YES proxys:RgsProxyObj列表
 @see RgsProxyObj
 */
-(void)GetAreaProxys:(NSInteger)area_id completion:(void(^)(BOOL result,NSArray * proxys,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备驱动代理
 @param driver_id    设备ID
 @param completion      回调block 正常时返回YES proxys:RgsProxyObj列表
 @see RgsProxyObj
 */
-(void)GetDriverProxys:(NSInteger)driver_id completion:(void(^)(BOOL result,NSArray * proxys,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备驱动命令
 @param driver_id    设备ID
 @param completion   回调block 正常时返回YES commands:RgsCommandInfo列表
 @see RgsCommandInfo
 */
-(void)GetDriverCommands:(NSInteger)driver_id completion:(void(^)(BOOL result,NSArray * commands,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备驱动参数
 @param driver_id    设备ID
 @param completion   回调block 正常时返回YES properties:RgsPropertyObj列表
 @see RgsPropertyObj
 */
-(void)GetDriverProperties:(NSInteger)driver_id completion:(void(^)(BOOL result,NSArray * properties,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备驱动事件
 @param driver_id    设备ID
 @param completion   回调block 正常时返回YES events:RgsEventObj列表
 @see RgsEventObj
 */
-(void)GetDriverEvents:(NSInteger)driver_id completion:(void(^)(BOOL result,NSArray * events,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备驱动连接
 @param driver_id    设备ID
 @param completion   回调block 正常时返回YES connects:RgsConnectionObj列表
 @see RgsConnectionObj
 */
-(void)GetDriverConnects:(NSInteger)driver_id completion:(void(^)(BOOL result,NSArray * connects,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备代理命令
 @param proxy_id     代理ID
 @param completion   回调block 正常时返回YES commands:RgsCommandInfo列表
 @see RgsCommandInfo
 */
-(void)GetProxyCommands:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSArray * commands,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备代理事件
 @param proxy_id     代理ID
 @param completion   回调block 正常时返回YES events:RgsEventObj列表
 @see RgsEventObj
 */
-(void)GetProxyEvents:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSArray * events,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备代理状态信息对象
 @param proxy_id     代理ID
 @param completion   回调block 正常时返回YES stateInfos:RgsProxyStateInfo列表
 @see RgsProxyStateInfo
 */
-(void)GetProxyStateInfos:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSArray * stateInfos,NSError * error)) completion;

/*!
 @since 3.2.1
 @brief 查询设备代理当前状态
 @param proxy_id     代理ID
 @param completion   回调block 正常时返回YES state:当前状态
 */
-(void)GetProxyCurState:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSDictionary * state,NSError * error)) completion;


/*!
   @since 3.0.0
   @brief 修改代理名字
   @param proxy_id        代理id
   @param name            代理名字
   @param completion      回调block 正常时返回YES
   @see RgsProxyObj
 */
-(void)RenameProxy:(NSInteger)proxy_id
              name:(NSString *)name
        completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
   @since 3.0.0
   @brief 请求设备驱动信息
   @param completion      回调block 正常时返回YES driver_infos为RgsDriverInfo列表
   @see RgsDriverInfo
 */
-(void)RequestDriverInfos:(void(^)(BOOL result,NSArray * driver_infos,NSError * error)) completion;


/*!
   @since 3.0.0
   @brief 设置事件操作
   @param evt_obj         事件对象
   @param operation       RgsSceneOperation 对象列表
   @param completion      回调block 正常时返回YES
   @see RgsEventObj
   @see RgsSceneOperation
 */
-(void)SetEventOperatons:(RgsEventObj *) evt_obj
               operation:(NSArray *)operation
              completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
   @since 3.0.0
   @brief 查询事件操作
   @param evt_obj         事件对象
   @param completion      回调block 正常时返回YES operatins operations为 RgsSceneOperation对象列表
   @see RgsEventObj
   @see RgsSceneOperation
 */
-(void)GetEventOperations:(RgsEventObj *) evt_obj
               completion:(void(^)(BOOL result,NSArray * operatins,NSError * error)) completion;


/*!
 @since 3.0.0
 @brief 获取系统类型驱动
 @param completion 回调block 正常时返回YES drivers为RgsDriverObj对象列表
 @see RgsDriverObj
 */
-(void)GetSystemDrivers:(void(^)(BOOL result,NSArray * drivers,NSError * error)) completion;


/*!
 @since 3.5.1
 @brief 向U盘或SD卡导出工程文件
 @param name 导出的文件名字
 @param completion 回调block 正常时返回YES
 */
-(void)ExportProjectToUdisc:(NSString *)name
                 completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.5.1
 @brief 查询U盘或SD卡工程文件
 @param completion 回调block 正常时返回YES names为工程文件名列表
 */
-(void)GetProjectsFromUdisc:(void(^)(BOOL result,NSArray * names,NSError * error)) completion;

/*!
 @since 3.5.1
 @brief 从U盘或SD卡导入工程文件
 @param name 导入的文件名字
 @param completion 回调block 正常时返回YES
 */
-(void)ImportProjectFromUdisc:(NSString *)name
                 completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.5.1
 @brief 获取当前手机使用的WI-FI的SSID
 @return SSID
 */
+(NSString *)GetWifiSSID;


/*!
 @since 3.5.1
 @param psd WiFi密码
 @param taskCount the expect result count(if expectTaskResultCount <= 0, expectTaskResultCount = INT32_MAX)
 @param itmeIntevel 超时值
 @param callback 结果回调
 */
+(void)RgsWifiConfWithPassword:(NSString *)psd taskCount:(int)taskCount timeIntevel:(int)itmeIntevel callback:(void(^)(NSError *error))callback;


/*!
 @since 3.6.1
 @brief 请求物理类型设备驱动信息
 @param completion      回调block 正常时返回YES driver_infos为RgsDriverInfo列表
 @see RgsDriverInfo
 */
-(void)RequestPhysicalDriverInfos:(void(^)(BOOL result,NSArray * driver_infos,NSError * error)) completion;

/*!
 @since 3.6.1
 @brief 请求代理设备驱动信息
 @param completion      回调block 正常时返回YES driver_infos为RgsDriverInfo列表
 @see RgsDriverInfo
 */
-(void)RequestProxyDriverInfos:(void(^)(BOOL result,NSArray * driver_infos,NSError * error)) completion;

/*!
 @since 3.6.1
 @brief 请求功能设备驱动信息
 @param completion      回调block 正常时返回YES driver_infos为RgsDriverInfo列表
 @see RgsDriverInfo
 */
-(void)RequestFunctionDriverInfos:(void(^)(BOOL result,NSArray * driver_infos,NSError * error)) completion;


/*!
 @since 3.6.1
 @brief 创建红外控制器设备驱动
 @param model 红外控制器类型
 @param name 创建的驱动名称
 @param completion 回调block 正常时返回YES driver_info为创建后的RgsDriverInfo
 */
-(void)MakeIrDriverWithIrModel:(RgsIrModel)model name:(NSString *)name completion:(void(^)(BOOL result,RgsDriverInfo * driver_info,NSError * error))completion;


/*!
 @since 3.6.1
 @brief 获取红外控制器设备驱动红外码KEY值列表
 @param serial 红外驱动序列号
 @param completion 回调block 正常时返回YES code_key为红外码的KEY和是否录制了的值
 */
-(void)GetIrDriverIrcodeKey:(NSString *)serial completion:(void(^)(BOOL result,NSDictionary * code_key,NSError * error))completion;

/*!
 @since 3.6.1
 @brief 录制红外控制器红外码
 @param serial 红外驱动序列号
 @param key 红外码的键名
 @param completion 回调block 正常时返回YES 返回为NO
 */
-(void)RecordIrcode:(NSString *)serial cmd:(NSString *)key completion:(void(^)(BOOL result,NSError * error))completion;

/*!
 @since 3.6.1
 @brief 删除红外设备驱动信息
 @param serial 红外驱动序列号
 @param completion 回调block 正常时返回YES 返回为NO
 */
-(void)DeleteIrDriver:(NSString *)serial completion:(void(^)(BOOL result,NSError * error))completion;

/*!
 @since 3.6.1
 @brief 设置系统时间
 @param date 设置的系统时间
 @param completion 回调block 正常时返回YES 返回为NO
 */
-(void)SetDate:(NSDate *)date completion:(void(^)(BOOL result,NSError * error))completion;

/*!
 @since 3.6.1
 @brief 设置系统IP自动获取,重启系统后生效
 @param completion 回调block 正常时返回YES 返回为NO
 */
-(void)SetIPAuto:(void(^)(BOOL result,NSError * error))completion;


/*!
 @since 3.6.1
 @brief 设置系统IP，重启系统后生效
 @param ip IP地址
 @param mask 网络掩码
 @param gateway 网关
 @param completion 回调block 正常时返回YES 返回为NO
 */
-(void)SetIPManual:(NSString *)ip
              mask:(NSString *)mask
           gateway:(NSString *)gateway
        completion:(void(^)(BOOL result,NSError * error))completion;

/*!
 @since 3.6.1
 @brief 获取系统信息
 @param completion      回调block 正常时返回YES sys_info系统信息对象
 @see RgsSystemInfo
 */
-(void)GetSystemInfo:(void(^)(BOOL result,RgsSystemInfo * sys_info,NSError * error))completion;

/*!
 @since 3.6.1
 @brief 重启系统
 @param completion 回调block 正常时返回YES 返回为NO
 */
-(void)RebootSystem:(void(^)(BOOL result,NSError * error))completion;


/*!
 @since 3.6.1
 @brief 获取多个代理命令
 @param proxy_ids       为NSNUmber数组。NSNUmber内容为要查询的Proxy id
 @param completion      回调block 正常时返回YES commd_dict的KEY为proxy id的字符。value为该proxy的命令列表
 @see RgsCommandInfo
 */
-(void)GetProxyCommandDict:(NSArray *)proxy_ids completion:(void(^)(BOOL result,NSDictionary * commd_dict,NSError * error)) completion;

/*!
 @since 3.7.1
 @brief 查询U盘或SD卡升级包
 @param completion 回调block 正常时返回YES names为升级包名
 */
-(void)GetUpdatePacketFromUdisc:(void(^)(BOOL result,NSArray * names,NSError * error)) completion;

/*!
 @since 3.7.1
 @brief 使用更新包进行更新系统
 @param completion 回调block 正常时返回YES name为升级包名
 */
-(void)UpdateFromUdisc:(NSString *)name
                   completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
 @since 3.8.1
 @brief 获取系统所有配置了操作的事件
 @param completion 回调block 正常时返回YES events为RgsEventObj对象列表
 @see RgsEventObj
 */
-(void)GetFilledEvents:(void(^)(BOOL result,NSArray * events,NSError * error)) completion;


/*!
 @since 3.8.1
 @brief 清空该事件的配置内容
 @param evt_obj 为需要清空的事件对象
 @param completion 回调block 正常时返回YES
 @see RgsEventObj
 */
-(void)ClearEventOperatons:(RgsEventObj *)evt_obj completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
 @since 3.9.2
 @brief 查询命令操作的描述
 @param operation 为待查询的操作，现阶段只支持RgsSceneDeviceOperation的查询。
 @param completion 回调block 正常时返回YES descripe为该操作的描述
 @see RgsSceneOperation
 */
-(void)QueryRgsSceneOperationDescripe:(RgsSceneOperation *)operation
                           completion:(void(^)(BOOL result,NSString * descripe,NSError * error)) completion;


/*!
 @since 3.10.1
 @brief 通过网络检查当前系统版本，并获取更新包信息
 @param completion 回调block 正常时返回YES info为nil时，则不需要更新。info为非nil，则需要更新。
 @see RgsUpdatePacketInfo
 */
-(void)RequestSystemVersionCheck:(void(^)(BOOL result,RgsUpdatePacketInfo * info,NSError * error)) completion;

/*!
 @since 3.10.1
 @brief 下载并安装更新包
 @param info 更新包信息对象
 @param completion 回调block 正常时返回YES。下载进度通过onDownloadUpdatePacket返回。
 @see RgsUpdatePacketInfo
 */
-(void)DownloadAndInstallUpdatePacket:(RgsUpdatePacketInfo *)info completion:(void(^)(BOOL result,NSError * error)) completion;


/*!
 @since 3.11.1
 @brief 创建日程
 @param name 名字
 @param exce_time 执行时间
 @param start_date 开始日期
 @param end_date 结束日期 为nil表示不设置结束时间
 @param week_items 周重复 为nil时表示不设置重复
 @param completion 成功反回YES 以及 RgsSchedulerObj对象
 @see RgsSchedulerObj
 */
-(void)CreateScheduler:(NSString *)name
             exce_time:(NSDate *)exce_time
            start_date:(NSDate *)start_date
              end_date:(NSDate *)end_date
            week_items:(NSArray *)week_items
            completion:(void (^)(BOOL result, RgsSchedulerObj * scheduler, NSError * error))completion;

/*!
 @since 3.11.1
 @brief 修改日程
 @param scheduler_id 修改日程的ID
 @param name 名字
 @param exce_time 执行时间
 @param start_date 开始日期
 @param end_date 结束日期 为nil表示不设置结束时间
 @param week_items 周重复 为nil时表示不设置重复
 @param completion 成功反回YES 以及 RgsSchedulerObj对象
 @see RgsSchedulerObj
 */
-(void)SetScheduler:(NSInteger)scheduler_id
               name:(NSString *)name
          exce_time:(NSDate *)exce_time
         start_date:(NSDate *)start_date
           end_date:(NSDate *)end_date
         week_items:(NSArray *)week_items
         completion:(void (^)(BOOL result,RgsSchedulerObj * scheduler,NSError * error))completion;

/*!
 @since 3.11.1
 @brief 删除日程
 @param scheduler_id 需要删除的日程ID
 @param completion 成功反回YES
 */
-(void)DelSchedulerByID:(NSInteger) scheduler_id
         completion:(void (^)(BOOL result, NSError * error))completion;

/*!
 @since 3.11.1
 @brief 获取日程
 @param completion 成功反回RgsSchedulerObj的对象列表
 */
-(void)GetSchedulers:(void (^)(BOOL result, NSArray * schedulers, NSError * error))completion;


/*!
 @since 3.11.1
 @brief 获取区域所有连接
 @param completion 成功返回RgsConnectionObj的对象列表
 @see RgsConnectionObj
 */
-(void)GetAreaConnections:(NSInteger)area_id completion:(void(^)(BOOL result,NSArray * connt_objs,NSError * error)) completion;

/*!
 @since 3.11.1
 @brief 获取区域所有事件
 @param completion 成功返回RgsEventObj的对象列表
 @see RgsEventObj
 */
-(void)GetAreaEvents:(NSInteger)area_id completion:(void(^)(BOOL result,NSArray * evt_objs,NSError * error)) completion;

/*!
 @since 3.11.1
 @brief 根据Proxy类型获取所有的该类型的Proxy
 @param completion 成功返回RgsEventObj的对象列表
 @see RgsProxyObj
 */
-(void)GetProxysByType:(NSString *)type completion:(void(^)(BOOL result,NSArray * proxys,NSError * error)) completion;

/*!
 @since 3.11.1
 @brief 获取设备下的所有Proxy的当前状态
 @param completion 成功返回state_dict的字典。Key为Proxy的ID，value为该Proxy的state，类型为NSDictionary *
 */
-(void)GetDriverProxyCurState:(NSInteger) driver_id completion:(void(^)(BOOL result,NSDictionary * state_dict,NSError * error)) completion;


/*!
 @since 3.11.1
 @brief 获取指定的Proxy的当前状态
 @param proxy_ids  为NSNUmber数组。NSNUmber内容为要查询的Proxy id
 @param completion 成功返回state_list的列表。列表按请求参数proxy_ids的顺序返回每个对应Proxy的state，类型为NSDictionary *
 */
-(void)GetProxysCurState:(NSArray *)proxy_ids completion:(void(^)(BOOL result,NSArray * state_list,NSError * error)) completion;


/*!
 @since 3.12.1
 @brief 获取指定的Proxy的当前状态
 @param largeOrSmall 设置大图为YES，小图为NO
 @param area_id 区域ID
 @param image 图片信息
 @param completion 成功范围RgsAreaObj对象结构
 */
-(void)SetAreaImage:(BOOL)largeOrSmall area_id:(NSInteger)area_id image:(NSString *)image completion:(void(^)(BOOL result,RgsAreaObj * area_obj,NSError * error)) completion;

/*!
 @since 3.12.2
 @brief 获取指定的Proxy的当前状态
 @param save_path 相对用户目录下的保存路径
 @param completion 成功返回YES 失败返回NO
 */
-(void)RequestDownTopology:(NSString *)save_path completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.1
 @brief 获取数据结构ID的客户数据字段
 @param id 数据结构ID
 @param completion 成功返回YES 失败返回NO data为获取的客户数据
 */
-(void)GetUserData:(NSInteger)id completion:(void(^)(BOOL result,NSDictionary * data,NSError * error)) completion;

/*!
 @since 3.14.1
 @brief 添加数据结构ID的客户数据字段。新添加的数据字段和原来数据字段为叠加关系
 @param id 数据结构ID
 @param completion 成功返回YES 失败返回NO
 */
-(void)SetUserData:(NSInteger)id data:(NSDictionary *)data completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.1
 @brief 根据ID获取数据结构
 @param id 数据结构ID
 @param completion 成功返回YES 失败返回NO RgsObject 为数据结构指针
 @see RgsAreaObj RgsDriverObj RgsProxyObj
 */
-(void)GetRgsObjectByID:(NSInteger) id completion:(void(^)(BOOL result,id RgsObject,NSError * error)) completion;

/*!
 @since 3.14.1
 @brief 上传当前工程
 使用Put请求，请求参数存放在Header。
 上传结果由 onUploadProject返回
 @param url 上传地址
 @param param 上传参数
 @param timeout 超时设置，单位秒
 @param completion YES：请求成功发送 NO：请求发送失败
 */
-(void)ExportProjectToUrl:(NSString *)url param:(NSDictionary *)param timeout:(NSInteger)timeout completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.1
 @brief 下载并导入工程
 使用post请求，请求参数存放在Body。
 下载结果由 onDownloadProject返回
 @param url 下载地址
 @param param 下载参数
 @param timeout 超时设置，单位秒
 @param completion YES：请求成功发送 NO：请求发送失败
 */
-(void)ImportProjectFromUrl:(NSString *)url param:(NSDictionary *)param timeout:(NSInteger)timeout completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.1
 @brief 下载更新插件
 使用post请求，请求参数存放在Body。
 下载结果由 onDownloadPlugin返回
 @param url 下载地址
 @param param 下载参数
 @param timeout 超时设置，单位秒
 @param plugin_name 插件保存的名字
 @param completion YES：请求成功发送 NO：请求发送失败
 */
-(void)UpdateRgsDriverFromUrl:(NSString *)url param:(NSDictionary *)param timeout:(NSInteger)timeout plugin_name:(NSString *)plugin_name completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.3
 @brief 请求代理状态参数，结果在onRecvDeviceNotify返回
 @param proxy_id 代理ID
 @param completion 成功返回YES 失败返回NO RgsObject 为数据结构指针
 */
-(void)QueryProxyStateInCallBack:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.3
 @brief 请求命令参数，结果在onRecvCommandInfo返回
 @param id 代理ID
 @param completion 成功返回YES 失败返回NO RgsObject 为数据结构指针
 */
-(void)QueryCommandInfoByIDInCallBack:(NSInteger)id completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.3
 @brief 请求代理性能参数，结果在onRecvDeviceCapbility返回
 @param proxy_id 代理ID
 @param completion 成功返回YES 失败返回NO RgsObject 为数据结构指针
 */
-(void)QueryProxyCapbilityInCallBack:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.14.4
 @brief 请求代理关联代理
 @param proxy_id 代理ID
 @param completion 成功返回YES 失败返回NO RgsProxyObj 为数据结构指针
 @see RgsProxyObj
 */
-(void)GetProxyRelevanceProxyObj:(NSInteger)proxy_id completion:(void(^)(BOOL result,NSArray<RgsProxyObj *>* proxies,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 使用本地离线模式
 @param completion 成功返回YES 失败返回NO
 */
-(void)UseLocalModel:(void(^)(BOOL result,NSError * error)) completion;

/*！
 @since 3.15.1
 @brief 请求下载本地离线模式需要的资源文件
 @param completion 成功返回YES 失败返回NO
 */
-(void)RequestDownLocalResourceFiles:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 新建工程
 @param author 工程创建者
 @param hardware 设备类型，由GetLocalProjectHardware获取
 @param completion 成功返回YES 失败返回NO
 */
-(void)NewLocalProject:(NSString *)author hardware:(NSString *)hardware completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 保存本地工程
 @param name 工程名字
 @param completion 成功返回YES 失败返回NO
 */
-(void)SaveLocalProject:(NSString *)name completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 加载本地工程
 @param name 工程名字
 @param completion 成功返回YES 失败返回NO
 */
-(void)LoadLocalProject:(NSString *)name completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 删除本地工程
 @param name 工程名字
 @param completion 成功返回YES 失败返回NO
 */
-(void)DelLocalProject:(NSString *)name completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 获取当前工程名字
 @param completion 成功返回YES 失败返回NO name 工程名字
 */
-(void)GetLocalProjectName:(void(^)(BOOL result,NSString * name,NSError * error)) completion;

/*!
 @since 3.15.1
 @brief 获取本地工程列表
 @param completion 成功返回YES 失败返回NO names工程列表
 */
-(void)GetProjectsFromLocal:(void (^)(BOOL result, NSArray * names, NSError * error))completion;

/*!
 @since 3.15.1
 @brief 导入本地工程到中控系统
 @param name 工程名字
 @param completion 成功返回YES 失败返回NO
 */
-(void)ImportProjectFromLocal:(NSString *)name completion:(void (^)(BOOL result,NSError * error))completion;

/*!
 @since 3.15.1
 @brief 导出中控系统工程到本地
 @param name 保存的工程名字
 @param completion 成功返回YES 失败返回NO
 */
-(void)ExportProjectToLocal:(NSString *)name completion:(void (^)(BOOL result,NSError * error))completion;

/*!
 @since 3.15.1
 @brief 获取支持的本地工程的中控系统类型
 @param completion 成功返回YES 失败返回NO hardware中控类型
 */
-(void)GetLocalProjectHardware:(void(^)(BOOL result,NSArray <NSString *>* hardware,NSError * error)) completion;


/*!
 @since 3.15.1
 @brief 更新本地工程资源到当前工程
 @param completion 成功返回YES 失败返回NO
 */
-(void)UpdateResourceToCurProject:(void(^)(BOOL result,NSError * error)) completion;


/*!
 @since 3.15.1
 @brief 获取当前登录的模式
 */
-(RgsLoginStatus)GetLoginModel;


/*!
 @since 3.16.1
 @brief 创建自动化
 @param name 名称
 @param img 图标
 @param iftype 条件组合类型 或、与
 @param ifthis 自动化条件
 @param thenthat 动作
 @param completion      回调block 正常时返回YES 返回RgsAutomationPbj
 @see RgsAutomationPbj
 */
-(void)CreateAutomation:(NSString *)name
                    img:(NSString *)img
                   iftype:(RgsCondIfType)iftype
                 ifthis:(NSArray<RgsSceneOperation *> *)ifthis
               thenthat:(NSArray<RgsSceneOperation *> *)thenthat
             completion:(void(^)(BOOL result,RgsAutomationObj * auto_obj ,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 修改自动化
 @param auto_id 自动化ID
 @param name 名称
 @param img 图标
 @param iftype 条件组合类型 或、与
 @param ifthis 自动化条件
 @param thenthat 动作
 @param completion      回调block 正常时返回YES 返回RgsAutomationPbj
 @see RgsAutomationPbj
 */
-(void)SetAutomation:(NSInteger)auto_id
                name:(NSString *)name
                 img:(NSString *)img
              iftype:(RgsCondIfType)iftype
              ifthis:(NSArray<RgsSceneOperation *> *)ifthis
            thenthat:(NSArray<RgsSceneOperation *> *)thenthat
             completion:(void(^)(BOOL result,RgsAutomationObj * auto_obj ,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 获取所有自动化结构
 @param completion      回调block 正常时返回YES 返回RgsAutomationPbj列表
 @see RgsAutomationPbj
 */
-(void)GetAutomation:(void(^)(BOOL result,NSArray <RgsAutomationObj *> * auto_objs,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 删除自动化结构
 @param auto_id 自动化ID
 @param completion      回调block 正常时返回YES
 @see RgsAutomationPbj
 */
-(void)DelAutomation:(NSInteger)auto_id completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 获取自动化触发条件
 @param auto_id 自动化ID
 @param completion      回调block 正常时返回YES 返回RgsSceneOperation列表
 @see RgsSceneOperation
 */
-(void)GetAutomationIf:(NSInteger)auto_id completion:(void(^)(BOOL result,NSArray <RgsSceneOperation *>* if_this,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 获取自动化动作
 @param auto_id 自动化ID
 @param completion      回调block 正常时返回YES 返回RgsSceneOperation列表
 @see RgsSceneOperation
 */
-(void)GetAutomationThen:(NSInteger)auto_id completion:(void(^)(BOOL result,NSArray <RgsSceneOperation *>* then_that,NSError * error)) completion;





/*!
 @since 3.16.1
 @brief 根据类型查询区域代理
 @param area_id    区域ID
 @param type 代理类型
 @param completion      回调block 正常时返回YES proxys:RgsProxyObj列表
 @see RgsProxyObj
 */
-(void)GetAreaProxysByType:(NSInteger)area_id type:(NSString *)type completion:(void(^)(BOOL result,NSArray * proxys,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 新建用户场景
 @param name 名称
 @param img 图标
 @param operations 场景动作
 @param completion      回调block 正常时返回YES
 @see RgsSceneObj
 */
-(void)CreateUserScene:(NSString *)name img:(NSString * )img
            operations:(NSArray<RgsSceneOperation *> *)operations
            completion:(void(^)(BOOL result,RgsSceneObj * scene_obj ,NSError * error)) completion;

/*!
 @since 3.16.1
 @brief 修改用户场景
 @param scene_id 场景ID
 @param name 名称
 @param img 图标
 @param operations 场景动作
 @param completion      回调block 正常时返回YES
 @see RgsSceneObj
 */
-(void)SetUserScene:(NSInteger)scene_id name:(NSString *)name
            img:(NSString *)img
     operations:(NSArray<RgsSceneOperation *> *)operations
     completion:(void(^)(BOOL result,RgsSceneObj * scene_obj ,NSError * error)) completion;

@end





