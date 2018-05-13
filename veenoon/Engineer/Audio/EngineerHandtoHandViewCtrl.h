//
//  EngineerHandtoHandViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/18.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EngineerSliderView.h"

@interface EngineerHandtoHandViewCtrl< EngineerSliderViewDelegate> : BaseViewController {
    NSMutableArray *_handToHandSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSArray *_handToHandSysArray;

@end
