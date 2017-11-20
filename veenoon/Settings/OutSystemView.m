//
//  OutSystemViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "OutSystemView.h"

@interface OutSystemView () {
    UIButton *outSystemBtn;
    UIButton *viewSettingBtn;
    
}

@end

@implementation OutSystemView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.1];
    
        UIImageView *icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"out_system_bk_botom.png"]];
        icon2.frame = CGRectMake(0, SCREEN_HEIGHT-190, SCREEN_WIDTH, 190);
        icon2.userInteractionEnabled = YES;
        [self addSubview:icon2];
    
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT -190, 100, 30)];
        tL.text = @"下次登录后";
        tL.textAlignment = NSTextAlignmentCenter;
        tL.textColor = [UIColor whiteColor];
        tL.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:tL];
    
        UILabel *tL2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, SCREEN_HEIGHT -160, 160, 30)];
        tL2.text = @"方可使用本系统操控";
        tL2.textAlignment = NSTextAlignmentCenter;
        tL2.textColor = [UIColor whiteColor];
        tL2.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:tL2];
    
        UIButton *outSystemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        outSystemBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT -115,100, 50);
        [self addSubview:outSystemBtn];
        [outSystemBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [outSystemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [outSystemBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        outSystemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [outSystemBtn addTarget:self
                  action:@selector(outSystemAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT -55,100, 50);
        [self addSubview:cancleBtn];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancleBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [cancleBtn addTarget:self
                     action:@selector(cancelAction:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) outSystemAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    
    [self removeFromSuperview];
}
@end
