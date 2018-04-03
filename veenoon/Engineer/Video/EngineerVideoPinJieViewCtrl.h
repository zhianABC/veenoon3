//
//  EngineerVideoPinJieViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EngineerVideoPinJieViewCtrl : BaseViewController {
    NSMutableArray *_pinjieSysArray;
    int _rowNumber;
    int _colNumber;
}
@property (nonatomic,strong) NSMutableArray *_pinjieSysArray;
@property (nonatomic,assign) int _rowNumber;
@property (nonatomic,assign) int _colNumber;
@end
