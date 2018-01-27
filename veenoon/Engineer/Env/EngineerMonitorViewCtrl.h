//
//  EngineerAireConditionViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerMonitorViewCtrl<CustomPickerViewDelegate> : BaseViewController {
    NSMutableArray *_monitorRoomList;
    
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_monitorRoomList;
@property (nonatomic,assign) int _number;
@end








