/*!
 @header RgsConnectionObj.h
 @brief  驱动连接对象 头文件信息
 这个文件包含驱动连接对象、连接类型对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsConnectionClass
 @since 3.0.0
 @brief 连接类型
 */
@interface RgsConnectionClass:NSObject

/*!
 本连接类型是否只能连接一个
 */
@property BOOL only_one;

/*!
 连接类型名称
 */
@property NSString * name;
@end

/*!
 @class RgsConnectionObj
 @since 3.0.0
 @brief 连接对象
 */
@interface RgsConnectionObj : NSObject

/*!
 所属driver 位置
 */
@property NSString * driver_location;

/*!
 所属driver 名称
 */
@property NSString * driver_name;

/*!
 所属driver id
 */
@property NSInteger driver_id;

/*!
 id
 */
@property NSInteger m_id;

/*!
 名称
 */
@property NSString * name;

/*!
 公母口
 @discussion YES:母 NO:公
 */
@property BOOL consumer;

/*!
 可连接类型RgsConnectionClass列表
 @see RgsConnectionClass
 */
@property NSArray * can_connect;

/*!
 已绑定的连接信息
 */
@property NSArray * bound_connect_str;

/*!
 @brief 建立连接
 @discussion 和对端连接对象建立连接。
 @param peer 对端连接对象 @see RgsConnectionObj
 @param completion 回调block，result：YES：成功 NO：失败
 */
-(void)Connect:(RgsConnectionObj *)peer completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @brief 断开连接
 @discussion 和对端连接对象断开连接。
 @param peer 断开的对端连接对象 @see RgsConnectionObj
 @param completion 回调block，result：YES：成功 NO：失败
 */
-(void)Disconnect:(RgsConnectionObj *)peer completion:(void(^)(BOOL result,NSError * error)) completion;

/*!
 @brief 查询可连接对象
 @discussion 查询连接对象可连接的对端列表
 @param completion 回调block,result：YES：成功 NO：失败 connections:可连接的RgsConnectionObj列表
 @see RgsConnectionObj
 */
-(void)GetCanConnect:(void(^)(BOOL result,NSArray * connections,NSError * error)) completion;

/*!
 @brief 查询已连接对象
 @discussion 查询连接对象已绑定的对端对象列表
 @param completion 回调block,result：YES：成功 NO：失败 connections:已连接的RgsConnectionObj列表
 @see RgsConnectionObj
 */
-(void)GetBoundings:(void(^)(BOOL result,NSArray * connections,NSError * error)) completion;

@end
