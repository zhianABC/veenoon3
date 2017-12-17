//
//  JSlideView.h
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSlideViewDelegate <NSObject>

- (void) didSliderValueChanged:(int)value object:(id)object;
- (void) didSliderEndChanged:(id)object;

@end

@interface JSlideView : UIView
{
    UIImageView *slider;
    UIImageView *sliderThumb;
    UIImageView *roadSlider;
    UIImageView *indicator;
    
    UILabel *valueLabel;
}
@property (nonatomic, weak) id  <JSlideViewDelegate> delegate;
@property (nonatomic, assign) int topEdge;
@property (nonatomic, assign) int bottomEdge;

@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame;

- (void) setRoadImage:(UIImage *)image;
- (void) resetScale;
- (void) setScaleValue:(int)value;

- (int) getScaleValue;

@end
