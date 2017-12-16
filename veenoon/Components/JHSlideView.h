//
//  JHSlideView.h
//  APoster
//
//  Created by chen jack on 13-6-18.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JHSlideView : UIView
{
    UIImageView *_sliderBg;
    UIImageView *_sliderFr;
    UIImageView *_thumb;
    
    UILabel *valueLabel;
    UILabel *maxL;
    
}
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;

- (id) initWithSliderBg:(UIImage*)sliderBg frame:(CGRect)frame;

- (void) setScaleValue:(int)value;

- (int) getScaleValue;

@end
