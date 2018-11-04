//
//  AutoRunCell.h
//  veenoon
//
//  Created by chen jack on 2018/8/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RgsSchedulerObj;

@protocol AutoRunCellDelegate <NSObject>

@optional
- (void) tappedAutoRunCell:(RgsSchedulerObj*)sch;
- (void) deleteAutoRunCell:(RgsSchedulerObj*)sch view:(UIView*)cell;

@end

@interface AutoRunCell : UIView
{
    
}
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, weak) id <AutoRunCellDelegate> delegate;

- (void) showRgsSchedule:(RgsSchedulerObj *)sch;

- (void) setEditMode:(BOOL)isEdit;

@end
