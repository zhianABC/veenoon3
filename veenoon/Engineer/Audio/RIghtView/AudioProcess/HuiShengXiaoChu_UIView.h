//
//  HuiShengXiaoChu_UIView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBaseView.h"

@protocol HuiShengXiaoChu_UIViewDelegate <NSObject>

@optional
- (void) didAecButtonAction;
@end

@interface HuiShengXiaoChu_UIView : APBaseView

@property (nonatomic, weak) id  <HuiShengXiaoChu_UIViewDelegate> delegate_;
@end
