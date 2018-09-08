//
//  ElectronicAutoRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindPlugin.h"

@protocol ElectronicAutoRightViewDelegate <NSObject>

@optional
- (void) didButtonAction:(int) commond;
@end

@interface ElectronicAutoRightView : UIView {
    
}
@property (nonatomic, strong) BlindPlugin *_currentBlind;
@property (nonatomic, weak) id <ElectronicAutoRightViewDelegate> _delegate;

- (id)initWithFrame:(CGRect)frame withPlugin:(BlindPlugin*) blindPlugin;
@end
