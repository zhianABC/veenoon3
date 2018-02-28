//
//  MixVoiceSettingsView.h
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MixVoiceSettingsViewDelegate <NSObject>

@optional
- (void) didSelectButtonAction:(NSString*)value;
@end
@interface MixVoiceSettingsView : UIView
@property (nonatomic, weak) id  <MixVoiceSettingsViewDelegate> delegate_;
@end
