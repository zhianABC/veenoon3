//
//  AutoRunCell.h
//  veenoon
//
//  Created by chen jack on 2018/8/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RgsSchedulerObj;
@class RgsAutomationObj;

@protocol AutoRunCellDelegate <NSObject>

@optional
- (void) tappedAutoRunCell:(RgsSchedulerObj*)sch;
- (void) deleteAutoRunCell:(id)sch view:(UIView*)cell;

@end

@interface AutoRunCell : UIView
{
    
}
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, weak) id <AutoRunCellDelegate> delegate;

- (void) showRgsSchedule:(RgsSchedulerObj *)sch;
- (void) showRgsAutoRun:(RgsAutomationObj *)sch;

- (void) setEditMode:(BOOL)isEdit;

@end
