//
//  CameraView.h
//  veenoon
//
//  Created by chen jack on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCameraSettingSet;

@interface CameraView : UIView
{
    
}
@property (nonatomic, strong) VCameraSettingSet *_vCamera;

- (void) loadCurrentDeviceDriver;

@end
