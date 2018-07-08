//
//  PowerSettingView.h
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PowerSettingViewDelegate <NSObject>
@optional
// -1 means all
- (void) didControlRelayDuration:(int)relayIndex withDuration:(int)duration;
- (void) didControlSwitchAllPower:(BOOL) isPowerOn;
@end


@class APowerESet;

@interface PowerSettingView : UIView
{
    
}
@property (nonatomic, strong) APowerESet *_objSet;
@property (nonatomic, weak) id <PowerSettingViewDelegate> _delegate;

- (void) show8Labs;
- (void) show16Labs;
-(void) refreshView:(APowerESet*) powerSet;
- (void) saveCurrentSetting;

@end
