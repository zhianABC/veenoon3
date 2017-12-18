//
//  EngineerWirlessYaoBaoViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"

@interface EngineerWirlessYaoBaoViewCtrl<CustomPickerViewDelegate, EngineerSliderViewDelegate> : BaseViewController {
    NSMutableArray *_wirelessYaoBaoSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_wirelessYaoBaoSysArray;
@property (nonatomic,assign) int _number;
@end
