//
//  USenceBlockView.h
//  veenoon
//
//  Created by chen jack on 2018/10/21.
//  Copyright © 2018 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Scenario;
@class USenceBlockView;

@protocol USenceBlockViewDelegate <NSObject>

@optional
- (void) didSelectRoomScenario:(Scenario*)s cell:(USenceBlockView*)cellView;

@end

@interface USenceBlockView : UIView
{
    
}
@property (nonatomic, strong) Scenario *_senario;
@property (nonatomic, weak) id <USenceBlockViewDelegate> delegate;


- (void) refreshData;
- (void) selectedCell:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
