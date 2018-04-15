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
    NSMutableArray *_electronicSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_electronicSysArray;
@property (nonatomic,assign) int _number;


@end
