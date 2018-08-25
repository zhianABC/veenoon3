//
//  EngineerAireConditionViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BlindPlugin.h"

@interface EngineerElectronicAutoViewCtrl : BaseViewController {
    int _number;
    
    BlindPlugin *_currentObj;
}
@property (nonatomic,strong) NSArray *_electronicSysArray;
@property (nonatomic,assign) int _number;
@property (nonatomic,strong) BlindPlugin *_currentObj;
@end

