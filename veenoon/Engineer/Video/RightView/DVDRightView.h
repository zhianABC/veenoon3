//
//  DVDRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/19.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDVDPlayerSet.h"
@interface DVDRightView : UIView {
    VDVDPlayerSet *_currentObj;
    int numberOfDevice;
    
    RightSetViewCallbackBlock _callback;
}
@property(nonatomic, strong) VDVDPlayerSet *_currentObj;
@property(nonatomic, assign) int _numOfDevice;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;
@property (nonatomic, assign) int _curentDeviceIndex;

-(void) refreshView:(VDVDPlayerSet*) dvdPlayerSet;
-(void) layoutDevicePannel;
@end
