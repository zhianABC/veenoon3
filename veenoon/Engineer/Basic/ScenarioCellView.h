//
//  ScenarioCellView.h
//  veenoon
//
//  Created by chen jack on 2018/9/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Scenario;

@protocol ScenarioCellViewDelegate <NSObject>

@optional
- (void) didButtonCellTapped:(Scenario*)s;

@end

@interface ScenarioCellView : UIView
{
    
}
@property (nonatomic, weak) UIViewController *ctrl;
@property (nonatomic, weak) id <ScenarioCellViewDelegate> delegate;

- (void) fillData:(Scenario*)data;
- (void) refreshDraggedData:(NSDictionary*)data;


@end
