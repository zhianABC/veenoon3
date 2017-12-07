//
//  EngineerPortSettingView.h
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPickerView.h"
@interface EngineerDNSSettingView <UITableViewDelegate,UITableViewDataSource> : UIView {
    UILabel *_serialLabel;
    UILabel *_devicNameLabel;
    UILabel *_devicIPLabel;
    UILabel *_macAddressLabel;
    
    CustomPickerView *_portLvPicker;
    CustomPickerView *_digitPicker;
    CustomPickerView *_checkPicker;
    CustomPickerView *_stopPicker;
    
    UITableView *_tableView;
    
    int _selectedRow;
    int _previousSelectedRow;
    
    NSMutableArray *_portList;
}
@property (nonatomic, strong) UILabel *_serialLabel;
@property (nonatomic, strong) UILabel *_devicNameLabel;
@property (nonatomic, strong) UILabel *_devicIPLabel;
@property (nonatomic, strong) UILabel *_macAddressLabel;

@property (nonatomic, strong) CustomPickerView *_portLvPicker;
@property (nonatomic, strong) CustomPickerView *_checkPicker;
@property (nonatomic, strong) CustomPickerView *_digitPicker;
@property (nonatomic, strong) CustomPickerView *_stopPicker;
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, assign) int _selectedRow;
@property (nonatomic, assign) int _previousSelectedRow;

@property (nonatomic, strong) NSMutableArray *_portList;
@end

