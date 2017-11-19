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
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:20];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"墙纸";
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/5, 80, 100, 30)];
        titleL2.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL2];
        titleL2.font = [UIFont boldSystemFontOfSize:16];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"桌面";
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/5, 80, 100, 30)];
        titleL3.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL3];
        titleL3.font = [UIFont boldSystemFontOfSize:16];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"用户";
        
        desktopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_1.png"]];
        desktopImageView.userInteractionEnabled = YES;
        desktopImageView.frame = CGRectMake(SCREEN_WIDTH*2/5-38, 120, 106, 80);
        [self addSubview:desktopImageView];
        
        userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_2.png"]];
        userImageView.userInteractionEnabled = YES;
        userImageView.frame = CGRectMake(SCREEN_WIDTH*3/5-38, 120, 106, 80);
        [self addSubview:userImageView];
        
        UIImageView *topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_top_line.png"]];
        topLine.userInteractionEnabled = YES;
        topLine.frame = CGRectMake(0, 215, SCREEN_WIDTH, 1);
        [self addSubview:topLine];
        
        scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5, 230, SCREEN_WIDTH*3/5, 280)];
        scrollView_.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView_];
        
        int imageViewSize = 14;
        int imageViewNumber = 6;
        int rowNumber = 0;
        int startY = 0;
        for (int i = 1; i <= imageViewSize; i++) {
            int columnNumber = 0;
            NSString *string = [NSString stringWithFormat:@"%d",i];
            NSString *imageName = [[@"settings_view_"  stringByAppendingString:string] stringByAppendingString:@".png"];
            
            Boolean needsNewRowNext = NO;
            if (i % imageViewNumber == 0) {
                rowNumber++;
                needsNewRowNext = true;
                columnNumber = 6;
            } else {
                columnNumber = i % imageViewNumber;
            }
            
            int startX = (columnNumber-1) *111;
            
            if (!needsNewRowNext && rowNumber > 0) {
                startY = rowNumber *85;
            }
            UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            backView.userInteractionEnabled = YES;
            backView.frame = CGRectMake(startX, startY, 106, 80);
            
            [scrollView_ addSubview:backView];
        }
        
        UIImageView *botomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings_view_botom_line.png"]];
        botomLine.userInteractionEnabled = YES;
        botomLine.frame = CGRectMake(0, 530, SCREEN_WIDTH, 10);
        [self addSubview:botomLine];
    }
    return self;
}
@end
