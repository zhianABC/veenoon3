//
//  EngineerPortSettingView.h
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterCustomerPickerView.h"

@protocol  EngineerDNSSettingViewDelegate <NSObject>
- (void) dnsViewPortAction;
- (void) dnsViewdnsAction;
- (void) dnsViewHandleTapGesture;
@end

@interface EngineerDNSSettingView <UITableViewDelegate,UITableViewDataSource> : UIView {
    UILabel *_serialLabel;
    UILabel *_devicNameLabel;
    UILabel *_devicIPLabel;
    UILabel *_macAddressLabel;
    
    CenterCustomerPickerView *_portLvPicker;
    CenterCustomerPickerView *_digitPicker;
    CenterCustomerPickerView *_checkPicker;
    CenterCustomerPickerView *_stopPicker;
    
    UITableView *_tableView;
    
    int _selectedRow;
    int _previousSelectedRow;
    
    NSMutableArray *_portList;
}
@property (nonatomic, strong) UILabel *_serialLabel;
@property (nonatomic, strong) UILabel *_devicNameLabel;
@property (nonatomic, strong) UILabel *_devicIPLabel;
@property (nonatomic, strong) UILabel *_macAddressLabel;

@property (nonatomic, strong) CenterCustomerPickerView *_portLvPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_checkPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_digitPicker;
@property (nonatomic, strong) CenterCustomerPickerView *_stopPicker;
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, assign) int _selectedRow;
@property (nonatomic, assign) int _previousSelectedRow;
@property(nonatomic, weak) id<EngineerDNSSettingViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *_portList;
@end

