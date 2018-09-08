//
//  ElectronicAutoRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlindPlugin.h"

@interface ElectronicAutoRightView : UIView {
    
}
@property (nonatomic, strong) BlindPlugin *_currentBlind;

- (id)initWithFrame:(CGRect)frame withPlugin:(BlindPlugin*) blindPlugin;
@end
