//
//  ZaoShengMen_UIView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseView.h"

@interface ZaoShengMen_UIView : APBaseView
- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys;
- (void) updateProxyCommandValIsLoaded;

@end
