//
//  RemoteVideoRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/19.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRemoteSettingsSet.h"
@interface RemoteVideoRightView : UIView {
    VRemoteSettingsSet *_currentObj;
    RightSetViewCallbackBlock _callback;
}
@property (nonatomic, strong) VRemoteSettingsSet *_currentObj;
@property(nonatomic, assign) int _numOfDevice;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;
@property (nonatomic, assign) int _curentDeviceIndex;

-(void) refreshView:(VRemoteSettingsSet*) vRemoteSettingsSet;
-(void) layoutDevicePannel;
@end
