//
//  EngineerVedioDevicePluginViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/7.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EngineerVedioDevicePluginViewCtrl : BaseViewController {
    NSMutableDictionary *_meetingRoomDic;
    NSMutableDictionary *_selectedSysDic;
}
@property (nonatomic,strong) NSMutableDictionary *_meetingRoomDic;
@property (nonatomic,strong) NSMutableDictionary *_selectedSysDic;
@end

