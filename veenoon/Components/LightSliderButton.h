//
//  SlideButton.h
//  veenoon
//
//  Created by chen jack on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LightSliderButton;

@protocol LightSliderButtonDelegate <NSObject>

@optional
- (void) didSlideButtonValueChanged:(float)value slbtn:(LightSliderButton*)slbtn;
- (void) didSlideButtonValueEndChanged:(float)value slbtn:(LightSliderButton*)slbtn;

- (void) didTappedMSelf:(LightSliderButton*)slbtn;
- (void) didLongPressSlideButton:(LightSliderButton*)slbtn;

@end

@interface LightSliderButton : UIView
{
    
}
@property (nonatomic, weak) id <LightSliderButtonDelegate> delegate;
@property (nonatomic, readonly) UILabel *_titleLabel;
@property (nonatomic, readonly) UILabel *_valueLabel;
@property (nonatomic, assign) BOOL _isEnabel;

@property (nonatomic, strong) UIImage *_grayBackgroundImage;
@property (nonatomic, strong) UIImage *_lightBackgroundImage;

@property (nonatomic, strong) id data;

@property (nonatomic, assign) BOOL longPressEnabled;


- (void) setCircleValue:(float) value;
- (void) changeButtonBackgroundImage:(UIImage *)image;

- (void) changToIcon:(UIImage*)iconImg;

- (void) setImageStype:(UIViewContentMode)mode;

- (void) enableValueSet:(BOOL)enabled;

-(void) setTitle:(NSString*)title;
-(void) setvalueTitle:(NSString*)title;

- (void) hiddenProgress;
- (void) turnOnOff:(BOOL)isON;
@end

