//
//  EngineerVideoProcessViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerVideoProcessViewCtrl<CustomPickerViewDelegate> : BaseViewController {
    NSMutableArray *_videoProcessInArray;
    NSMutableArray *_videoProcessOutArray;
    int _inNumber;
    int _outNumber;
}
@property (nonatomic,strong) NSMutableArray *_videoProcessInArray;
@property (nonatomic,strong) NSMutableArray *_videoProcessOutArray;
@property (nonatomic,assign) int _inNumber;
@property (nonatomic,assign) int _outNumber;
@end
