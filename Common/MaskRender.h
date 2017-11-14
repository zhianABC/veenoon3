//
//  MaskRender.h
//  SpeedTestHD
//
//  Created by jack on 12/18/12.
//  Copyright (c) 2012 Ookla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaskRender : NSObject
{
    
    UIImage *outputImage;
    
   
}
@property (nonatomic, readonly) UIImage* outputImage;
@property (nonatomic, strong) UIImage *orgImage;
@property (nonatomic, strong) UIImage *maskImage;
@property (nonatomic, strong) UIColor *backgroundColor;

// Call when size of mask image equal to size of orignal image
- (UIImage *) generateImageWithMask;

//Call when just use part of mask image to using by mask
- (void) prepareMask:(UIImage *)mask;
- (UIImage *) generateImageWithMaskWithMaskOrg:(CGPoint)pt;

- (UIImage *) generateImageWithBackgroundColorMask;

+ (UIImage *) mergeImageWithColor:(CGSize)targetSize color:(UIColor*)color image:(UIImage*)image;
+ (UIImage *) mergeImageWithColorWithOffset:(CGSize)targetSize color:(UIColor*)color image:(UIImage*)image offset:(CGPoint)offset;


- (UIImage *) generateImageWithMaskWithCenter:(CGPoint)pt pt2:(CGPoint)mask2Pt2;
+ (UIImage *) mergeImageWithMaskWithCenter:(CGPoint)pt withImag1:(UIImage*)image1 image2:(UIImage*)image2 pt2:(CGPoint)pt2;
@end
