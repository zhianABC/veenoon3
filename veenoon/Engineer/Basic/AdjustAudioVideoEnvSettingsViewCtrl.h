//
//  AdjustAudioVideoEnvSettingsViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2018/4/3.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AdjustAudioVideoEnvSettingsViewCtrl : BaseViewController {
    NSMutableDictionary *selectedSysDic;
}
@property (nonatomic, strong) NSMutableDictionary *selectedSysDic;
@end
