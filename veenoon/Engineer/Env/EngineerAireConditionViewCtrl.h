//
//  EngineerAireConditionViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EngineerAireConditionViewCtrl : BaseViewController {
    
    int _number;
}
@property (nonatomic,strong) NSArray *_airSysArray;
@property (nonatomic,assign) int _number;
@end
