//
//  ConfigureSetting.m
//  bmwTrainingApp
//
//  Created by jack on 2/22/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "ConfigureSetting.h"

@implementation ConfigureSetting

+(void) setViewControllerTitleWithTextColor:(NSString*)title color:(UIColor*)color targetCtrl:(UIViewController*)targetCtrl{
    
    NSString *newTitle;
    if ([title length]>12) {
        NSRange first = NSMakeRange(0, 11);
        NSMutableString *mStr = [NSMutableString string];
        [mStr appendString:[title substringWithRange:first]];
        [mStr appendString:@"…"];
        newTitle = mStr;
    }
    else {
        newTitle = title;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont boldSystemFontOfSize:18];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16]];
    label.frame = CGRectMake((DEFAULT_SCREEN_WIDTH-size.width)*0.5, 0, size.width, 44);
    label.textAlignment = NSTextAlignmentCenter;
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:color];
    //    [label setShadowColor:COLOR_TEXT_A];
    //    [label setShadowOffset:CGSizeMake(0, 1)];
    label.text = newTitle;
    
    targetCtrl.navigationItem.titleView = label;
    // [label release];
}

@end
