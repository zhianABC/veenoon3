//
//  EngineerWirelessMeetingViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/18.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"

@interface EngineerWirelessMeetingViewCtrl<CustomPickerViewDelegate, EngineerSliderViewDelegate> : BaseViewController {
    NSMutableArray *_wirelessMeetingArray;
    
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_wirelessMeetingArray;
@property (nonatomic,assign) int _number;
@end

