//
//  EngineerVideoPinJieViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VPinJieSet.h"

@protocol EngineerVideoPinJieViewDelegate <NSObject>

@optional
- (void) didEndEditCell:(int)row withColumn:(int)column;

@end

@interface EngineerVideoPinJieViewCtrl : BaseViewController {
    NSMutableArray *_pinjieSysArray;
    int _rowNumber;
    int _colNumber;
    
    VPinJieSet *_currentObj;
}
@property (nonatomic,strong) NSArray *_pinjieSysArray;
@property (nonatomic,assign) int _rowNumber;
@property (nonatomic,assign) int _colNumber;
@property (nonatomic,strong) VPinJieSet *_currentObj;
@end
