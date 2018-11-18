//
//  PAMicView.h
//  veenoon
//
//  Created by chen jack on 2018/11/18.
//  Copyright © 2018 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioEMinMaxProxy;

@interface PAMicView : UIView
{
    
}

- (void) fillMicObj:( AudioEMinMaxProxy* )micObj;
- (id) testChangeVolValueWhenSelected:(float)vol;
- (id) testChangeMuteWhenSelected:(BOOL)mute;

@end
