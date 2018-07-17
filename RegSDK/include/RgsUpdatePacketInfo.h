/*!
 @header RgsUpdatePacketInfo.h
 @brief 更新包 头文件信息
 
 @author zongtai.ye
 @copyright © 2018年 zongtai.ye.
 @version 18.7.13
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsUpdatePacketInfo
 @since 3.10.1
 @brief 更新包信息
 */

@interface RgsUpdatePacketInfo : NSObject

/*! 版本号 */
@property NSString * version;

/*! 更新包大小 */
@property NSString * size;

/*! 更新描述 */
@property NSString * descripe;

/*! 更新包md5 */
@property NSString * md5;


/*!
 @since 3.10.1
 @brief 设置更新包下载地址
 */
-(void)set_url:(NSString *)url usr:(NSString *)usr password:(NSString *)password;


/*!
 @since 3.10.1
 @brief 获取更新包C指针
 */
-(void *)get_c_content;
@end
