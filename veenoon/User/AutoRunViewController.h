//
//  AutoRunViewController.h
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetingRoom;

@interface AutoRunViewController : UIViewController
{
    
}
@property (nonatomic, strong) MeetingRoom *_room;
@property (nonatomic, strong) NSArray *_scenarios;
@end
