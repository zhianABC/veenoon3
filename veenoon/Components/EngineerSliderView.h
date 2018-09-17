//
//  JSlideView.h
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EngineerSliderViewDelegate <NSObject>

@optional
- (void) didSliderValueChanged:(float)value object:(id)object;
- (void) didSliderEndChanged:(float)value object:(id)object;
- (void) didSliderMuteChanged:(BOOL)mute object:(id)object;

@end


/*
 |  -- top200 -- - |  --268--   |0| --- 452 ---  | 120 |bottom
 */

@interface EngineerSliderView : UIView
{
    UIImageView *slider;
    UIImageView *indicator;
    UIImageView *sliderThumb;
    
    UILabel *valueLabel;
}
@property (nonatomic, weak) id  <EngineerSliderViewDelegate> delegate;
@property (nonatomic, assign) int topEdge;
@property (nonatomic, assign) int bottomEdge;

@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int stepValue;

@property (nonatomic, assign) BOOL isUnLineStyle;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame;

- (void) setMuteVal:(BOOL)mute;

- (void) setRoadImage:(UIImage *)image;
- (void) setIndicatorImage:(UIImage *)image;
- (void) resetScale;
- (void) setScaleValue:(int)value;

- (float) getScaleValue;

@end

