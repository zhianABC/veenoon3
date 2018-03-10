//
//  EngineerPortSettingView.h
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterCustomerPickerView.h"
@protocol  EngineerPortSettingViewDelegate <NSObject>
- (void) portViewPortAction;
- (void) portViewdnsAction;
- (void) portViewHandleTapGesture;
@end

@interface EngineerPortSettingView <UITableViewDelegate,UITableViewDataSource, CenterCustomerPickerViewDelegate> : UIView {
    CenterCustomerPickerView *_digitPicker;
    CenterCustomerPickerView *_portPicker;
    CenterCustomerPickerView *_portTypePicker;
    CenterCustomerPickerView *_portLvPicker;
    CenterCustomerPickerView *_checkPicker;
    CenterCustomerPickerView *_stopPicker;
    
    UITableView *_tableView;
    
    int _selectedRow;
    int _previousSelectedRow;
    
    NSMutableArray *_portList;
}
@property (nonatomic, strong) CenterCustomerPickerView *_portPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_portTypePicker;
@property (nonatomic, strong) CenterCustomerPickerView *_portLvPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_checkPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_digitPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_stopPicker;
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, assign) int _selectedRow;
@property (nonatomic, assign) int _previousSelectedRow;
@property(nonatomic, weak) id<EngineerPortSettingViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *_portList;
@end
