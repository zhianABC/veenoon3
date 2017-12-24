//
//  EngineerRemoteVideoViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomPickerView.h"

@interface EngineerRemoteVideoViewCtrl<CustomPickerViewDelegate> : BaseViewController {
    NSMutableArray *_remoteVideoArray;
    NSMutableArray *_cameraArray;
    int _number;
}
@property (nonatomic,strong) NSMutableArray *_remoteVideoArray;
@property (nonatomic,strong) NSMutableArray *_cameraArray;
@property (nonatomic,assign) int _number;
@end
