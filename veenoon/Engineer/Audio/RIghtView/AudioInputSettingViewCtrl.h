//
//  AudioInputSettingViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class AudioEProcessor;
@interface AudioInputSettingViewCtrl : BaseViewController

@property (nonatomic, strong) AudioEProcessor *_processor;

@end
