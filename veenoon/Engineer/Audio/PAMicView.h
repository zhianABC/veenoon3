//
//  PAMicView.h
//  veenoon
//
//  Created by chen jack on 2018/11/18.
//  Copyright © 2018 jack. All rights reserved.
//

#import <Foundation/Foundation.h>


@class AudioEMinMaxProxy;

@protocol PAMicViewDelegate <NSObject>

@optional
- (void) didTappedButtonWithVol:(int)vol;

@end

@interface PAMicView : UIView
{
    
}
@property (nonatomic, weak) id <PAMicViewDelegate> delegate;

- (void) fillMicObj:( AudioEMinMaxProxy* )micObj;
- (id) testChangeVolValueWhenSelected:(float)vol;
- (id) testChangeMuteWhenSelected:(BOOL)mute;

@end
