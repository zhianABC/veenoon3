//
//  HunyinYinpinchuliViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2018/2/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AudioEMix.h"

@interface HunyinYinpinchuliViewCtrl : BaseViewController {
    AudioEMix *_currentObj;
}
@property (nonatomic, strong) AudioEMix *_currentObj;
@end
