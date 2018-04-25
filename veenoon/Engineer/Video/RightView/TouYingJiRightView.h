//
//  TouYingJiRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/20.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTouyingjiSet.h"

@interface TouYingJiRightView : UIView {
    VTouyingjiSet *_currentObj;
    RightSetViewCallbackBlock _callback;
}
@property(nonatomic, strong) VTouyingjiSet *_currentObj;
@property(nonatomic, assign) int _numOfDevice;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;
@property (nonatomic, assign) int _curentDeviceIndex;

-(void) refreshView:(VTouyingjiSet*) dvdPlayerSet;
-(void) layoutDevicePannel;
@end
