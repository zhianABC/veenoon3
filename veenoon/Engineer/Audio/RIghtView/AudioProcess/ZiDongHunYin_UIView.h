//
//  ZiDongHunYin_UIView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseView.h"
#import "AudioEProcessor.h"

@interface ZiDongHunYin_UIView : APBaseView
- (id)initWithFrameProxy:(CGRect)frame withProxy:(AudioEProcessor*) proxy;

@end
