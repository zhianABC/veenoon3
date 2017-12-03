//
//  EnginnerHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EnginnerHomeViewController.h"
#import "UIButton+Color.h"

@interface EnginnerHomeViewController () {
}

@end

@implementation EnginnerHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int leftRight = 200;
    int width = SCREEN_WIDTH - leftRight*2;
    int height = width * 2 / 3;
    UIView *_inputPannel = [[UIView alloc] initWithFrame:CGRectMake(leftRight, 100, width, height)];
    [self.view addSubview:_inputPannel];
    _inputPannel.backgroundColor = RGB(0, 89, 118);
    _inputPannel.userInteractionEnabled=YES;
    
    UIImage *roomImage = [UIImage imageNamed:@"engineer_login_icon.png"];
    UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
    [_inputPannel addSubview:roomeImageView];
    roomeImageView.frame = CGRectMake(width/2-69, 30, 138, 109);
    roomeImageView.userInteractionEnabled=YES;
    
    UIView *_inputPannel2 = [[UIView alloc] initWithFrame:CGRectMake(leftRight, 100+height, width, 150)];
    [self.view addSubview:_inputPannel2];
    _inputPannel2.backgroundColor = [UIColor whiteColor];
    _inputPannel2.userInteractionEnabled=YES;
    
    UIButton *login = [UIButton buttonWithColor:nil selColor:[UIColor blackColor]];
    login.frame = CGRectMake(_inputPannel2.frame.size.width/2 - 100,_inputPannel2.frame.size.height/2-25,200, 50);
    login.layer.cornerRadius = 5;
    login.layer.borderWidth = 2;
    login.layer.borderColor = [UIColor blackColor].CGColor;
    login.clipsToBounds = YES;
    [_inputPannel2 addSubview:login];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [login addTarget:self
              action:@selector(loginAction:)
    forControlEvents:UIControlEventTouchUpInside];
}

-(void) loginAction:(id) sender {
    
}
@end
