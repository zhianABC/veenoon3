//
//  EngineerScenarioListViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/12.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EngineerScenarioListViewCtrl : BaseViewController {
    NSMutableDictionary *_meetingRoomDic;
}
@property (nonatomic,strong) NSMutableDictionary *_meetingRoomDic;
@end
