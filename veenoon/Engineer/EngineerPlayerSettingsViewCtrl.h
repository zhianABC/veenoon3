//
//  EngineerPlayerSettingsViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerPlayerSettingsViewCtrl<CustomPickerViewDelegate> : BaseViewController {
    NSMutableArray *_playerSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_playerSysArray;
@property (nonatomic,assign) int _number;
@end
