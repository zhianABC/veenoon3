//
//  CMNavigationController.m
//  CMTabBarController
//
//  Created by mac on 13-8-13.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "CMNavigationController.h"
#import "UIImage+Color.h"

@implementation UINavigationItem (CustomTitle)

- (void) setTitle:(NSString *)title {
    NSString *newTitle;
    if ([title length]>16) {
        NSRange first = NSMakeRange(0, 16);
        NSMutableString *mStr = [NSMutableString string];
        [mStr appendString:[title substringWithRange:first]];
        [mStr appendString:@"…"];
        newTitle = mStr;
    } else {
        newTitle = title;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont boldSystemFontOfSize:16];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16]];
    label.frame = CGRectMake((320.0-size.width)*0.5, 0, size.width, 44);
    label.textAlignment = NSTextAlignmentCenter;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    //    [label setShadowColor:COLOR_TEXT_A];
    //    [label setShadowOffset:CGSizeMake(0, 1)];
    label.text = newTitle;
    self.titleView = label;
    
}

@end



@implementation CMNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        
    }
    return self;
}

- (void)dealloc{
 
}

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //ios5->ios6 使用透明的navigationBar ios7以上使用默认的毛玻璃效果
    UIImage *themeImg = [UIImage imageWithColor:[UIColor blackColor] andSize:CGSizeMake(1, 1)];
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationBar setBackgroundImage:themeImg forBarMetrics:UIBarMetricsDefault];
        
        if ([self.navigationBar respondsToSelector:@selector(setShadowImage:)]) {
            [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)]];
        }
    }
}

- (UIImage *)capture {
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [UIScreen mainScreen].bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        [topWindow drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    }
    else
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [topWindow.layer renderInContext:ctx];
    }
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
