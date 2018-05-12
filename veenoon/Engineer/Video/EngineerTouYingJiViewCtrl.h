//
//  EngineerTouYingJiViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VTouyingjiSet.h"

@interface EngineerTouYingJiViewCtrl : BaseViewController {
    NSArray *_touyingjiArray;
    
    VTouyingjiSet *_currentObj;
}
@property (nonatomic,strong) NSArray *_touyingjiArray;
@property (nonatomic,strong) VTouyingjiSet *_currentObj;
@end
