//
//  AudioProcessRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AudioProcessRightViewDelegate <NSObject>

@optional
- (void) didSelectButtonAction:(NSString*)value;
@end

@class AudioEProcessor;

@interface AudioProcessRightView : UIView
@property (nonatomic, weak) id  <AudioProcessRightViewDelegate> delegate_;
@property (nonatomic, strong) AudioEProcessor *_processor;

- (void) recoverSetting;

- (void) saveCurrentSetting;

@end
