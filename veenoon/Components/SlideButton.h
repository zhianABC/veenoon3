//
//  SlideButton.h
//  veenoon
//
//  Created by chen jack on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideButton;

@protocol SlideButtonDelegate <NSObject>

@optional
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn;
- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn;
- (void) didTappedMSelf:(SlideButton*)slbtn;
- (void) didLongPressSlideButton:(SlideButton*)slbtn;
@end

@interface SlideButton : UIView
{
    
}
@property (nonatomic, weak) id <SlideButtonDelegate> delegate;
@property (nonatomic, readonly) UILabel *_titleLabel;
@property (nonatomic, readonly) UILabel *_valueLabel;

@property (nonatomic, strong) UIImage *_grayBackgroundImage;
@property (nonatomic, strong) UIImage *_lightBackgroundImage;

@property (nonatomic, strong) id data;

@property (nonatomic, assign) BOOL longPressEnabled;

- (id) initWithOffsetFrame:(CGRect)frame offset:(float)offset;

- (void) setCircleValue:(float) value;
- (void) changeButtonBackgroundImage:(UIImage *)image;

- (void) changToIcon:(UIImage*)iconImg;

- (void) enableValueSet:(BOOL)enabled;
- (BOOL) stateEnabled;

-(void) setTitle:(NSString*)title;
-(void) setvalueTitle:(NSString*)title;

- (void) muteSlider:(BOOL)mute;

@end
