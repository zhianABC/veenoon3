//
//  EngineerLightViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EngineerSliderView.h"

@interface EngineerLightViewController< EngineerSliderViewDelegate> : BaseViewController {
    NSArray *_lightSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSArray *_lightSysArray;
@property (nonatomic,assign) int _number;
@end
