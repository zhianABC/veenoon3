//
//  MaskRender.m
//  SpeedTestHD
//
//  Created by jack on 12/18/12.
//  Copyright (c) 2012 Ookla. All rights reserved.
//

#import "MaskRender.h"

@implementation MaskRender
@synthesize outputImage;
@synthesize orgImage;
@synthesize maskImage;
@synthesize backgroundColor;

+ (UIImage *) mergeImageWithColorWithOffset:(CGSize)targetSize color:(UIColor*)color image:(UIImage*)image offset:(CGPoint)offset{
    
    float x = offset.x;
    float y = offset.y;
    UIGraphicsBeginImageContext(targetSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, targetSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, targetSize.width, targetSize.height));
    
    CGContextDrawImage(context, CGRectMake(x, y, image.size.width, image.size.height),image.CGImage);
    
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (UIImage *) mergeImageWithColor:(CGSize)targetSize color:(UIColor*)color image:(UIImage*)image{
    
    float x = (targetSize.width - image.size.width)/2.0;
    float y = (targetSize.height - image.size.height)/2.0;
    UIGraphicsBeginImageContext(targetSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, targetSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, targetSize.width, targetSize.height));
    
    CGContextDrawImage(context, CGRectMake(x, y, image.size.width, image.size.height),image.CGImage);

    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
 
    return newImage;
}

- (UIImage *) generateImageWithBackgroundColorMask{
    
    CGSize newSize = CGSizeMake(maskImage.size.width*2, maskImage.size.height*2);
    //CGSize maskSize = newSize;//maskImage.size;
    
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
     
    CGImageRef alphaMask = maskImage.CGImage;
    
    CGContextClipToMask(context, CGRectMake(0,
                                            0,
                                            newSize.width, newSize.height), alphaMask);
    
    CGContextFillRect(context, CGRectMake(0, 0, newSize.width, newSize.height));
    
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
    
}
- (UIImage *) generateImageWithMask{
    
    if(maskImage == nil)return nil;
    if(orgImage == nil)return nil;
    
    
    CGSize newSize = CGSizeMake(orgImage.size.width, orgImage.size.height);
    CGSize maskSize = newSize;//maskImage.size;
    
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // CGContextRestoreGState(context);
    //

    //        CGContextDrawImage(context, CGRectMake(0, 0, mask.size.width, mask.size.height),mask.CGImage);
    
    CGImageRef alphaMask = maskImage.CGImage;
    
    CGContextClipToMask(context, CGRectMake((newSize.width-maskSize.width)/2,
                                            (newSize.height-maskSize.height)/2,
                                            maskSize.width, maskSize.height), alphaMask);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),orgImage.CGImage);
    
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (void) prepareMask:(UIImage *)mask{
    
    
    CGSize newSize = CGSizeMake(orgImage.size.width, orgImage.size.height);
    CGSize maskSize = mask.size;
    
    CGSize newMaskSize = CGSizeMake(maskSize.width,newSize.height + maskSize.height);
    
    UIGraphicsBeginImageContext(newMaskSize);
    
    [mask drawInRect:CGRectMake(0,newSize.height/2.0,maskSize.width,maskSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    self.maskImage = newImage;
    
    UIGraphicsEndImageContext();
    
}

- (UIImage *) generateImageWithMaskWithMaskOrg:(CGPoint)pt{
    
    if(maskImage == nil)return nil;
    if(orgImage == nil)return nil;
    
    
    CGSize newSize = CGSizeMake(orgImage.size.width, orgImage.size.height);
   
    float y =  pt.y - newSize.height/2.0;
    
    CGImageRef alphaMask;
    
    CGRect rect = CGRectMake(0,
                      newSize.height/2.0+y+5,
                      newSize.width, newSize.height);
   
    alphaMask = CGImageCreateWithImageInRect(maskImage.CGImage, rect);
    
    
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // CGContextRestoreGState(context);
    //
    
    //        CGContextDrawImage(context, CGRectMake(0, 0, mask.size.width, mask.size.height),mask.CGImage);
    
    //CGImageRef alphaMask = maskImage.CGImage;
    
    
    CGContextClipToMask(context, CGRectMake(0, 0, newSize.width, newSize.height), alphaMask);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),orgImage.CGImage);
    
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
    
}


- (UIImage *) generateImageWithMaskWithCenter:(CGPoint)pt pt2:(CGPoint)mask2Pt2{
    
    if(maskImage == nil)return nil;
    if(orgImage == nil)return nil;
    
    
    CGSize newSize = CGSizeMake(orgImage.size.width, orgImage.size.height);
    CGSize maskSize = maskImage.size;
    
    //Mask with point1
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGImageRef alphaMask = maskImage.CGImage;
    CGContextClipToMask(context, CGRectMake((pt.x-maskSize.width/2.0),
                                            (orgImage.size.height-pt.y-maskSize.height/2.0),
                                            maskSize.width, maskSize.height), alphaMask);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),orgImage.CGImage);
    
    UIImage* img1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //Mask with point 2
    UIGraphicsBeginImageContext(newSize);
    
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextClipToMask(context, CGRectMake((mask2Pt2.x-maskSize.width/2.0),
                                            (orgImage.size.height-mask2Pt2.y-maskSize.height/2.0),
                                            maskSize.width, maskSize.height), alphaMask);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),orgImage.CGImage);
    
    UIImage* img2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //Merge two
    UIGraphicsBeginImageContext(newSize);
    
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),img1.CGImage);
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),img2.CGImage);
    
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return outputImage;
    
}



+ (UIImage *) mergeImageWithMaskWithCenter:(CGPoint)pt withImag1:(UIImage*)image1 image2:(UIImage*)image2 pt2:(CGPoint)pt2{
    
    if(image1 == nil)return nil;
    if(image2 == nil)return nil;
    
    
    CGSize newSize = CGSizeMake(image1.size.width, image1.size.height);
    CGSize maskSize = image2.size;
    
    UIGraphicsBeginImageContext(newSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, newSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGImageRef alphaMask = image2.CGImage;
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height),image1.CGImage);
    
    CGContextDrawImage(context, CGRectMake((pt.x-maskSize.width/2.0),
                                           (image1.size.height-pt.y-maskSize.height/2.0),
                                           maskSize.width, maskSize.height), alphaMask);
    
    CGContextDrawImage(context, CGRectMake((pt2.x-maskSize.width/2.0),
                                           (image1.size.height-pt2.y-maskSize.height/2.0),
                                           maskSize.width, maskSize.height), alphaMask);
    
    UIImage *outImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImg;
    
}

@end
