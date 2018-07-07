//
//  JunHengQi_UIView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioEMix.h"
@interface JunHengQi_UIView : UIView {
    AudioEMix *_currentObj;
}
@property (nonatomic, strong) AudioEMix *_currentObj;

-(id) initWithFrame:(CGRect)frame withAudiMix:(AudioEMix*) audioMix;

@end
