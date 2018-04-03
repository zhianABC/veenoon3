//
//  EngineerPVExpendViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EngineerSliderView.h"

@interface EngineerPVExpendViewCtrl<EngineerSliderViewDelegate> : BaseViewController {
    NSMutableArray *_pvExpendArray;
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_pvExpendArray;
@property (nonatomic,assign) int _number;
@end
