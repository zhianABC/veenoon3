//
//  BaseViewController.h
//  hkeeping
//
//  Created by jack on 2/18/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigureSetting.h"
#import "WebClient.h"


@interface BaseViewController : UIViewController
{
    WebClient       *_http;
    
    UIImageView     *_backgroundImageView;

}

- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font; //根据字符串、字体计算长度

@end
