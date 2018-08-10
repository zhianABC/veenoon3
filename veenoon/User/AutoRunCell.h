//
//  AutoRunCell.h
//  veenoon
//
//  Created by chen jack on 2018/8/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RgsSchedulerObj;

@interface AutoRunCell : UIView
{
    
}
@property (nonatomic, readonly) UIButton *button;

- (void) showRgsSchedule:(RgsSchedulerObj *)sch;

@end
