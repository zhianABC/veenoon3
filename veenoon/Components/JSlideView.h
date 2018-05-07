//
//  JSlideView.h
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSlideViewDelegate <NSObject>

@optional
- (void) didSliderValueChanged:(float)value object:(id)object;
- (void) didSliderEndChanged:(id)object;

@end

@interface JSlideView : UIView
{
    UIImageView *slider;
    UIImageView *sliderThumb;
    UIImageView *indicator;
    
    UILabel *valueLabel;
}
@property (nonatomic, weak) id  <JSlideViewDelegate> delegate;
@property (nonatomic, assign) int topEdge;
@property (nonatomic, assign) int bottomEdge;

@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) float stepValue;

@property (nonatomic, strong) id data;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame;

- (void) setRoadImage:(UIImage *)image;
- (void) resetScale;
- (void) setScaleValue:(float)value;

- (float) getScaleValue;

@end
