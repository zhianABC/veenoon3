//
//  SlideButton.h
//  veenoon
//
//  Created by chen jack on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WirelessSliderButton;

@protocol WirelessSliderButtonDelegate <NSObject>

@optional
- (void) didSlideButtonValueChanged:(float)value slbtn:(WirelessSliderButton*)slbtn;
- (void) didTappedMSelf:(WirelessSliderButton*)slbtn;

@end

@interface WirelessSliderButton : UIView
{
    
}
@property (nonatomic, weak) id <WirelessSliderButtonDelegate> delegate;
@property (nonatomic, readonly) UILabel *_titleLabel;
@property (nonatomic, readonly) UILabel *_valueLabel;

- (void) setCircleValue:(float) value;
- (void) changeButtonBackgroundImage:(UIImage *)image;

- (void) changToIcon:(UIImage*)iconImg;

- (void) enableValueSet:(BOOL)enabled;

@end

