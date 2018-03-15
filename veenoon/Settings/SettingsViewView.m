//
//  SettingsViewView.m
//  veenoon
//
//  Created by 安志良 on 2017/11/18.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SettingsViewView.h"

@interface SettingsViewView () {
    UIImageView *desktopImageView;
    UIImageView *userImageView;
    
    UIScrollView *scrollView_;
}

@end

@implementation SettingsViewView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        
        
        int x = (frame.size.width - 400*2 - 20)/2;
        int y = (frame.size.height - 300)/2+30;
        
        desktopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_1.png"]];
        desktopImageView.userInteractionEnabled = YES;
        desktopImageView.frame = CGRectMake(x, y, 400, 300);
        [self addSubview:desktopImageView];
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y-40, 400, 30)];
        titleL2.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL2];
        titleL2.font = [UIFont systemFontOfSize:16];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"桌面壁纸";
        titleL2.textAlignment = NSTextAlignmentCenter;
        
        userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_2.png"]];
        userImageView.userInteractionEnabled = YES;
        userImageView.frame = CGRectMake(x+400+20, y, 400, 300);
        [self addSubview:userImageView];
        
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(x+400+20, y-40, 400, 30)];
        titleL3.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL3];
        titleL3.font = [UIFont systemFontOfSize:16];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"用户壁纸";
        titleL3.textAlignment = NSTextAlignmentCenter;
        
        
       
    }
    return self;
}
@end
