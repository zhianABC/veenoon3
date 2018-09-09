//
//  DVDView.h
//  veenoon
//
//  Created by chen jack on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VDVDPlayerSet;

@interface DVDView : UIView
{
    
}
@property (nonatomic, strong) VDVDPlayerSet *_currentObj;

- (void) loadCurrentDeviceDriverProxys;

@end
