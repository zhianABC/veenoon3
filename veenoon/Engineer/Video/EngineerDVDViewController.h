//
//  EngineerDVDViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerDVDViewController<CustomPickerViewDelegate> : BaseViewController {
    NSMutableArray *_dvdSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_dvdSysArray;
@property (nonatomic,assign) int _number;
@end
