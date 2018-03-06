//
//  SIconSelectView.h
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SIconSelectViewDelegate <NSObject>

@optional
- (void) didMoveDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt;
- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt;

@end

@interface SIconSelectView : UIView
{
    
}
@property (nonatomic, strong) NSArray *_icondata;
@property (nonatomic, weak) id <SIconSelectViewDelegate> delegate;

@end
