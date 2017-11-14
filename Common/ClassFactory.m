//
//  ClassFactory.m
//  hkeeping
//
//  Created by jack on 2/24/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "ClassFactory.h"

@implementation ClassFactory

+ (UILabel*) createLabelWith:(CGRect)frame font:(UIFont*)font textColor:(UIColor*)color{
    
    UILabel *tL = [[UILabel alloc] initWithFrame:frame];
    tL.backgroundColor = [UIColor clearColor];
    tL.textColor = color;
    tL.font = font;
   
    return tL;
   
}

+ (UIBarButtonItem *) createBarButtonWithImage:(UIImage *)normal down:(UIImage*)down sel:(SEL)sel target:(id)target{
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setImage:normal forState:UIControlStateNormal];
    [rightBtn setImage:down forState:UIControlStateHighlighted];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return bar;

}
@end
