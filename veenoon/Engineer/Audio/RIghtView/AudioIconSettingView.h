//
//  AudioIconSettingView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioIconSettingViewDelegate <NSObject>

@optional
- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt;

@end

@interface AudioIconSettingView : UIView
{
    
}
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, weak) id <AudioIconSettingViewDelegate> delegate;

@end
