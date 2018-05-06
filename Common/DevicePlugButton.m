//
//  DevicePlugButton.m
//  veenoon
//
//  Created by chen jack on 2018/5/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DevicePlugButton.h"

@implementation DevicePlugButton

@synthesize _mydata;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) addMyObserver{
    
    if(_mydata && [_mydata objectForKey:@"name"])
    {
        id key = [NSString stringWithFormat:@"%d-%@",
                  [[_mydata objectForKey:@"id"] intValue],
                  [_mydata objectForKey:@"name"]];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(revNotifyChangedMyBg:)
                                                 name:key
                                               object:nil];
    }
}

- (void) revNotifyChangedMyBg:(id)sender{
    
    if(_mydata && [_mydata objectForKey:@"icon_sel"])
    {
        UIImage *image = [UIImage imageNamed:[_mydata objectForKey:@"icon_sel"]];
        
        if(image)
        [self setBackgroundImage:image
                           forState:UIControlStateNormal];
    }
}

- (void) removeMyObserver{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
