//
//  EngineerElectonicSysConfigViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class APowerESet;
@interface EngineerElectronicSysConfigViewCtrl : BaseViewController {
    
}
@property (nonatomic,strong) NSArray *_electronicSysArray;
@property (nonatomic,strong) APowerESet *_currentObj;
@property (nonatomic,assign) int _number;

@end
