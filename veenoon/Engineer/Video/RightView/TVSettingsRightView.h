//
//  TVSettingsRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/3/17.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTVSet.h"

@interface TVSettingsRightView : UIView {
    VTVSet *_currentObj;
    RightSetViewCallbackBlock _callback;
}
@property(nonatomic, strong) VTVSet *_currentObj;
@property(nonatomic, assign) int _numOfDevice;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;
@property (nonatomic, assign) int _curentDeviceIndex;

-(void) refreshView:(VTVSet*) dvdPlayerSet;
-(void) layoutDevicePannel;
@end
