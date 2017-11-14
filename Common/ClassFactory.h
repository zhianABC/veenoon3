//
//  ClassFactory.h
//  hkeeping
//
//  Created by jack on 2/24/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ClassFactory : NSObject

+ (UILabel*) createLabelWith:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)color;
+ (UIBarButtonItem *) createBarButtonWithImage:(UIImage *)normal down:(UIImage*)down sel:(SEL)sel target:(id)target;

@end
