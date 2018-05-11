//
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioEWirlessMike;
@interface WirlessYaoBaoViewSettingsView : UIView
{
    RightSetViewCallbackBlock _callback;
}
@property (nonatomic, assign) int _numOfDevice;
@property (nonatomic, assign) int _curentDeviceIndex;
@property (nonatomic, strong) AudioEWirlessMike *_audioMike;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;

- (void) showData;

@end
