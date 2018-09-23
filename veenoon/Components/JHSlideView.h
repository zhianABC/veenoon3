//
//  JHSlideView.h
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHSlideViewDelegate <NSObject>

@optional
- (void) didSlideValueChanged:(int)value index:(int)index;
- (void) didSlideEndValueChanged:(int)value index:(int)index;

@end

@interface JHSlideView : UIView
{
    UIImageView *_sliderBg;
    UIImageView *_sliderFr;
    UIImageView *_thumb;
    
    UILabel *valueLabel;
    UILabel *maxL;

    int curValue;
}
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, readonly) UILabel *maxL;
@property (nonatomic, assign) BOOL _isShowValue;

@property (nonatomic, weak) id <JHSlideViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *ctrl;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame;

- (void) setScaleValue:(int)value;
- (void) initScaleValue:(int)value;

- (int) getScaleValue;

@end
