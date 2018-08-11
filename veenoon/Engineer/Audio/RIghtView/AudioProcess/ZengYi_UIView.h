//
//  ZengYi_UIView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseView.h"
#import "VAProcessorProxys.h"

@interface ZengYi_UIView : APBaseView {
    
}
- (id)initWithFrame:(CGRect)frame withProxy:(NSArray*)proxys;
- (void) updateProxyCommandValIsLoaded;

@end
