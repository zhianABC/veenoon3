//
//  AutoRunSetView.h
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RgsSchedulerObj;

@interface ChuanGanAutoSetView : UIView
{
    
}
@property (nonatomic, strong) NSArray *_scenarios;
@property (nonatomic, weak) UIViewController *ctrl;

@property (nonatomic, strong) RgsSchedulerObj *_schedule;

- (id) initWithDateAndTime:(CGRect)frame;
- (id) initWithWeeks:(CGRect)frame;

- (void) show;

@end

