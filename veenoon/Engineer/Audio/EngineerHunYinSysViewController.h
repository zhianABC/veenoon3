//
//  EngineerHunYinSysViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/18.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AudioEMix.h"

@interface EngineerHunYinSysViewController : BaseViewController {
    NSMutableArray *_hunyinSysArray;
    
    AudioEMix *_currentObj;
}
@property (nonatomic,strong) NSArray *_hunyinSysArray;
@property (nonatomic,strong) AudioEMix *_currentObj;
@property (nonatomic, assign) BOOL fromScenario;
@end
