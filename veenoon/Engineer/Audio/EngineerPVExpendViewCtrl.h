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
   
}
@property (nonatomic,strong) NSArray *_pvExpendArray;
@property (nonatomic,assign) BOOL fromScenario;
@end
