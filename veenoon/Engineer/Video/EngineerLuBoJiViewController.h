//
//  EngineerLuBoJiViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerLuBoJiViewController<CustomPickerViewDelegate> : BaseViewController {
    NSMutableArray *_lubojiArray;
}
@property (nonatomic,strong) NSMutableArray *_lubojiArray;
@end
