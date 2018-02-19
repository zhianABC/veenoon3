//
//  VideoProcessRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/19.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoProcessRightViewDelegate <NSObject>

@optional
- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt;

@end

@interface VideoProcessRightView : UIView
{
    
}
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, weak) id <VideoProcessRightViewDelegate> delegate;

@end
