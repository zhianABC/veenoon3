/*!
 @header RgsAreaObj.h
 @brief 区域 头文件信息
 这个文件包含区域的主要方法和属性声明。
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>

/*!
 @class RgsAreaObj
 @since 3.0.0
 @brief 区域对象
*/

@interface RgsAreaObj : NSObject

/*! 区域ID */
@property NSInteger m_id;

/*! 区域名称 */
@property NSString * name;

///*! 是否限制访问 */
//@property BOOL limit;
//
///*! 限制访问密码 */
//@property NSString * limit_pw;

@end
