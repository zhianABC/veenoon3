//
//  CircleProgressView.h
//  test
//
//  Created by jack on 06/11/13.
//  Copyright (c) 2013 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView
{
    float _progress;
    UILabel *textL;
}
@property (nonatomic, readonly) UILabel *textL;
@property (nonatomic, assign) BOOL _isShowingPoint;

- (void) setProgress:(float)progress;
- (void) updateOffest:(float)offset;

- (void) setProgressBolder:(float)bolder;

- (void) smallRefreshMode;

- (void) stepProgress:(float)step;
- (void) syncCurrentStepedValue;

- (float) pgvalue;

@end
