//
//  EngineerCameraViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EngineerCameraViewController : BaseViewController {
    NSArray *_cameraSysArray;
    
    int _number;
}
@property (nonatomic,strong) NSArray *_cameraSysArray;
@property (nonatomic,assign) int _number;
@end
