//
//  AutoRunSetView.h
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RgsSchedulerObj;
@class UserSensorObj;

@interface ChuanGanAutoSetView : UIView
{
    
}
@property (nonatomic, strong) NSArray *_scenarios;
@property (nonatomic, strong) UserSensorObj *_sensor;
@property (nonatomic, weak) UIViewController *ctrl;

@property (nonatomic, strong) RgsSchedulerObj *_schedule;


- (id) initWithPicker:(CGRect)frame withScnearios:(NSArray*) scenarios;

- (void) show;

@end

