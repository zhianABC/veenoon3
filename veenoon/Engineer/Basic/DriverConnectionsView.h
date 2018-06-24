//
//  DriverConnectionsView.h
//  veenoon
//
//  Created by chen jack on 2018/5/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RgsDriverObj;
@class BasePlugElement;

@interface DriverConnectionsView : UIView
{
    
}
@property (nonatomic, strong) RgsDriverObj *_driver;
@property (nonatomic, strong) BasePlugElement *_plug;
@property (nonatomic, assign) int _connectIdx;

- (void) showFromPoint:(CGPoint)pt;

@end

