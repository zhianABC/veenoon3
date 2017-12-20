//
//  EngineerWIrelessMeetingPlayViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/18.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerWIrelessMeetingPlayViewCtrl<CustomPickerViewDelegate> : BaseViewController {
    NSMutableDictionary *_usbPlayerDic;
    
}
@property (nonatomic,strong) NSMutableDictionary *_usbPlayerDic;
@end
