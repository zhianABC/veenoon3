//
//  CameraRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/19.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VCameraSettingSet;

@interface CameraRightView : UIView {
    VCameraSettingSet *_currentObj;
    RightSetViewCallbackBlock _callback;
}
@property (nonatomic, strong) VCameraSettingSet *_currentObj;
@property(nonatomic, assign) int _numOfDevice;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;
@property (nonatomic, assign) int _curentDeviceIndex;

-(void) refreshView:(VCameraSettingSet*) vCameraSettingSet;
-(void) layoutDevicePannel;

- (void) saveCurrentSetting;

@end
