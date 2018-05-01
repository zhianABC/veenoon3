//
//  EngineerRemoteVideoViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VRemoteSettingsSet.h"

@interface EngineerRemoteVideoViewCtrl : BaseViewController {
    
    NSMutableArray *_cameraArray;
    VRemoteSettingsSet *_currentObj;
}
@property (nonatomic,strong) NSMutableArray *_cameraArray;
@property (nonatomic,strong) VRemoteSettingsSet *_currentObj;


@end
