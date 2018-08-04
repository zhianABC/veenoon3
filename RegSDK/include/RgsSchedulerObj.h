/*!
 @header RgsSchedulerObj.h
 @brief  日程预约对象 头文件信息
 这个文件包含日程预约对象的主要方法和属性声明
 
 @author zongtai.ye
 @copyright © 2017年 zongtai.ye.
 @version 17.12.21
 */

#import <Foundation/Foundation.h>
#include "RgsConstants.h"
#include "RgsEventObj.h"

/*!
 @class RgsSchedulerObj
 @since 3.11.1
 @brief 重复计划对象
 */

@interface RgsSchedulerObj : NSObject

/*!
 日程id
 */
@property NSInteger m_id;

/*!
 名字
 */
@property NSString * name;

/*!
 执行时间
 */
@property NSDate * exce_time;

/*!
 周重复
 */
@property NSArray * week_items;

/*！
 开始日期
 */
@property NSDate * start_date;

/*！
 失效日期
 */
@property NSDate * end_date;

/*！
 生效事件
 */
@property RgsEventObj * evt_obj;


@end
