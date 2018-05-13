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
#import "DActionView.h"

@class BasePlugElement;

@protocol PlugDeviceCtrlDelegate <NSObject>

@optional
- (void) didAddToScenarioSlice:(BasePlugElement*)plug cmds:(NSArray*)cmds;

@end

@interface BaseViewController : UIViewController
{
    WebClient       *_http;
    
    UIImageView     *_backgroundImageView;

    UIView *_topBar;
    UIImageView *titleIcon;
    UILabel *titleLabel;
    UILabel *centerTitleLabel;
    
    DActionView *_dActionView;
}
@property (nonatomic, weak) id <PlugDeviceCtrlDelegate> delegate;

- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font; //根据字符串、字体计算长度
- (void) setTitleAndImage:(NSString*)imageName withTitle:(NSString*)title;
- (void) setCenterTitle:(NSString*)centerTitle;
@end
