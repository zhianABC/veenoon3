//
//  VideoProcessRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/19.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVideoProcessSet.h"
@protocol VideoProcessRightViewDelegate <NSObject>

@optional
- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt;

@end

@interface VideoProcessRightView : UIView {
    VVideoProcessSet *_currentObj;
    RightSetViewCallbackBlock _callback;
}
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, weak) id <VideoProcessRightViewDelegate> delegate;
@property (nonatomic, strong) VVideoProcessSet *_currentObj;
@property(nonatomic, assign) int _numOfDevice;
@property (nonatomic, copy) RightSetViewCallbackBlock _callback;
@property (nonatomic, assign) int _curentDeviceIndex;

-(void) refreshView:(VVideoProcessSet*) vVideoProcessSet;

@end
