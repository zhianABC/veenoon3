//
//  DevicePlugButton.h
//  veenoon
//
//  Created by chen jack on 2018/5/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasePlugElement;

@interface DevicePlugButton : UIButton

@property (nonatomic, strong) NSDictionary *_mydata;
@property (nonatomic, assign) BOOL _isEdited;
@property (nonatomic, strong) BasePlugElement *_plug;

- (void) addMyObserver;
- (void) removeMyObserver;

- (void) setEditChanged;

@end
