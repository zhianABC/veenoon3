//
//  SlideButton.h
//  veenoon
//
//  Created by chen jack on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideButtonDelegate <NSObject>

@optional
- (void) didSlideButtonValueChanged:(float)value;
    
@end

@interface SlideButton : UIView
{
    
}
@property (nonatomic, weak) id <SlideButtonDelegate> delegate;

- (void) setCircleValue:(float) value;
- (void) changeButtonBackgroundImage:(UIImage *)image;

- (void) changToIcon:(UIImage*)iconImg;

@end
