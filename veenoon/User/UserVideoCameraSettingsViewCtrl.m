//
//  UserVideoDVDDiskViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/30.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoCameraSettingsViewCtrl.h"
#import "UIButton+Color.h"

@interface UserVideoCameraSettingsViewCtrl () {
}
@end

@implementation UserVideoCameraSettingsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lastVideoUpBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    lastVideoUpBtn.frame = CGRectMake(230, SCREEN_HEIGHT-500, 80, 80);
    lastVideoUpBtn.layer.cornerRadius = 5;
    lastVideoUpBtn.layer.borderWidth = 2;
    lastVideoUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lastVideoUpBtn.clipsToBounds = YES;
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"user_video_play_left.png"] forState:UIControlStateNormal];
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"user_video_play_left.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:lastVideoUpBtn];
    
    [lastVideoUpBtn addTarget:self
                       action:@selector(lastVideoUpBtnAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okPlayerBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    okPlayerBtn.frame = CGRectMake(315, SCREEN_HEIGHT-500, 80, 80);
    okPlayerBtn.layer.cornerRadius = 5;
    okPlayerBtn.layer.borderWidth = 2;
    okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    okPlayerBtn.clipsToBounds = YES;
    [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:okPlayerBtn];
    
    [lastVideoUpBtn addTarget:self action:@selector(okPlayerAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnUpBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    volumnUpBtn.frame = CGRectMake(315, SCREEN_HEIGHT-585, 80, 80);
    volumnUpBtn.layer.cornerRadius = 5;
    volumnUpBtn.layer.borderWidth = 2;
    volumnUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnUpBtn.clipsToBounds = YES;
    [volumnUpBtn setImage:[UIImage imageNamed:@"user_video_play_up.png"] forState:UIControlStateNormal];
    [volumnUpBtn setImage:[UIImage imageNamed:@"user_video_play_up.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnUpBtn];
    
    [volumnUpBtn addTarget:self
                    action:@selector(volumnUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextPlayBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    nextPlayBtn.frame = CGRectMake(400, SCREEN_HEIGHT-500, 80, 80);
    nextPlayBtn.layer.cornerRadius = 5;
    nextPlayBtn.layer.borderWidth = 2;
    nextPlayBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    nextPlayBtn.clipsToBounds = YES;
    [nextPlayBtn setImage:[UIImage imageNamed:@"user_video_play_next.png"] forState:UIControlStateNormal];
    [nextPlayBtn setImage:[UIImage imageNamed:@"user_video_play_next.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:nextPlayBtn];
    
    [nextPlayBtn addTarget:self
                    action:@selector(nextPlayBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnDownBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    volumnDownBtn.frame = CGRectMake(315, SCREEN_HEIGHT-415, 80, 80);
    volumnDownBtn.layer.cornerRadius = 5;
    volumnDownBtn.layer.borderWidth = 2;
    volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnDownBtn.clipsToBounds = YES;
    [volumnDownBtn setImage:[UIImage imageNamed:@"user_video_play_down.png"] forState:UIControlStateNormal];
    [volumnDownBtn setImage:[UIImage imageNamed:@"user_video_play_down.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnDownBtn];
    
    [volumnDownBtn addTarget:self
                      action:@selector(volumnDownAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *invokeBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    invokeBtn.frame = CGRectMake(715, SCREEN_HEIGHT-585, 80, 80);
    invokeBtn.layer.cornerRadius = 5;
    invokeBtn.layer.borderWidth = 2;
    invokeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    invokeBtn.clipsToBounds = YES;
    [invokeBtn setTitle:@"调用" forState:UIControlStateNormal];
    [invokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    invokeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:invokeBtn];
    
    [invokeBtn addTarget:self
                    action:@selector(invokeAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *minusBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    minusBtn.frame = CGRectMake(630, SCREEN_HEIGHT-500, 80, 80);
    minusBtn.layer.cornerRadius = 5;
    minusBtn.layer.borderWidth = 2;
    minusBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    minusBtn.clipsToBounds = YES;
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    minusBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:minusBtn];
    
    [minusBtn addTarget:self
                  action:@selector(minusAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *twovelBtn = [UIButton buttonWithColor:nil selColor:RGB(242, 148, 20)];
    twovelBtn.frame = CGRectMake(715, SCREEN_HEIGHT-500, 80, 80);
    twovelBtn.layer.cornerRadius = 5;
    twovelBtn.layer.borderWidth = 2;
    twovelBtn.layer.borderColor = RGB(242, 148, 20).CGColor;;
    twovelBtn.clipsToBounds = YES;
    [twovelBtn setTitle:@"12" forState:UIControlStateNormal];
    [twovelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twovelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    twovelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:twovelBtn];
    
    [twovelBtn addTarget:self
                 action:@selector(twovelAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    addBtn.frame = CGRectMake(800, SCREEN_HEIGHT-500, 80, 80);
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.borderWidth = 2;
    addBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    addBtn.clipsToBounds = YES;
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self
                 action:@selector(addAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tButton = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    tButton.frame = CGRectMake(630, SCREEN_HEIGHT-415, 80, 80);
    tButton.layer.cornerRadius = 5;
    tButton.layer.borderWidth = 2;
    tButton.layer.borderColor = [UIColor clearColor].CGColor;;
    tButton.clipsToBounds = YES;
    [tButton setTitle:@"T" forState:UIControlStateNormal];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    tButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:tButton];
    
    [tButton addTarget:self
               action:@selector(tAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wButton = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    wButton.frame = CGRectMake(800, SCREEN_HEIGHT-415, 80, 80);
    wButton.layer.cornerRadius = 5;
    wButton.layer.borderWidth = 2;
    wButton.layer.borderColor = [UIColor clearColor].CGColor;;
    wButton.clipsToBounds = YES;
    [wButton setTitle:@"W" forState:UIControlStateNormal];
    [wButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    wButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:wButton];
    
    [wButton addTarget:self
                action:@selector(wAction:)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void) wAction:(id)sender{
    
}

- (void) tAction:(id)sender{
    
}

- (void) addAction:(id)sender{
    
}

- (void) twovelAction:(id)sender{
    
}

- (void) minusAction:(id)sender{
    
}

- (void) invokeAction:(id)sender{
    
}

- (void) nextPlayBtnAction:(id)sender{
    
}
- (void) volumnDownAction:(id)sender{
    
}
- (void) volumnUpAction:(id)sender{
    
}
- (void) okPlayerAction:(id)sender{
    
}

- (void) lastVideoUpBtnAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


