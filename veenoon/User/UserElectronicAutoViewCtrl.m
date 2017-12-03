//
//  UserElectronicAutoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/2.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserElectronicAutoViewCtrl.h"
#import "UIButton+Color.h"

@interface UserElectronicAutoViewCtrl () {
    UIButton *_diandongchuanglianBtn;
    UIButton *_touyingjishengjiangBtn;
    UIButton *_touyingmuBtn;
    UIButton *_diandongmenBtn;
    UIButton *_tianchuangBtn;
}
@end

@implementation UserElectronicAutoViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int leftRight = 70;
    int number = 5;
    int height = 200;
    int rowGap = 150;
    int width = (SCREEN_WIDTH - leftRight*2) / number;
    
    _diandongchuanglianBtn = [UIButton buttonWithColor:nil selColor:nil];
    _diandongchuanglianBtn.frame = CGRectMake(leftRight+rowGap, height, width, width);
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_n.png"] forState:UIControlStateNormal];
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_s.png"] forState:UIControlStateHighlighted];
    [_diandongchuanglianBtn setTitle:@"电动窗帘" forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _diandongchuanglianBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_diandongchuanglianBtn setTitleEdgeInsets:UIEdgeInsetsMake(_diandongchuanglianBtn.imageView.frame.size.height+10,-80,-20,40)];
    [_diandongchuanglianBtn setImageEdgeInsets:UIEdgeInsetsMake(-15,0.0,_diandongchuanglianBtn.titleLabel.bounds.size.height, -20)];
    [_diandongchuanglianBtn addTarget:self action:@selector(chuanglianAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_diandongchuanglianBtn];
    
    _touyingjishengjiangBtn = [UIButton buttonWithColor:nil selColor:nil];
    _touyingjishengjiangBtn.frame = CGRectMake(leftRight+rowGap*2, height, width, width);
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_n.png"] forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_s.png"] forState:UIControlStateHighlighted];
    [_touyingjishengjiangBtn setTitle:@"投影机升降" forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _touyingjishengjiangBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_touyingjishengjiangBtn setTitleEdgeInsets:UIEdgeInsetsMake(_touyingjishengjiangBtn.imageView.frame.size.height-8,-120,-62,25)];
    [_touyingjishengjiangBtn setImageEdgeInsets:UIEdgeInsetsMake(5,0.0,_touyingjishengjiangBtn.titleLabel.bounds.size.height, -20)];
    [_touyingjishengjiangBtn addTarget:self action:@selector(touyingjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_touyingjishengjiangBtn];
    
    _touyingmuBtn = [UIButton buttonWithColor:nil selColor:nil];
    _touyingmuBtn.frame = CGRectMake(leftRight+rowGap*3+10, height, width, width);
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_n.png"] forState:UIControlStateNormal];
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_s.png"] forState:UIControlStateHighlighted];
    [_touyingmuBtn setTitle:@"投影幕升降" forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _touyingmuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_touyingmuBtn setTitleEdgeInsets:UIEdgeInsetsMake(_touyingmuBtn.imageView.frame.size.height-17,-120,-63,25)];
    [_touyingmuBtn setImageEdgeInsets:UIEdgeInsetsMake(-5,0,_touyingmuBtn.titleLabel.bounds.size.height-10, -20)];
    [_touyingmuBtn addTarget:self action:@selector(touyingmuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_touyingmuBtn];
    
    _diandongmenBtn = [UIButton buttonWithColor:nil selColor:nil];
    _diandongmenBtn.frame = CGRectMake(leftRight+rowGap*4, height, width, width);
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmen_.png"] forState:UIControlStateNormal];
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmes_.png"] forState:UIControlStateHighlighted];
    [_diandongmenBtn setTitle:@"电动门" forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _diandongmenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_diandongmenBtn setTitleEdgeInsets:UIEdgeInsetsMake(_diandongmenBtn.imageView.frame.size.height+20,-105,-10,10)];
    [_diandongmenBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_diandongmenBtn.titleLabel.bounds.size.height, 0)];
    [_diandongmenBtn addTarget:self action:@selector(diandongmenAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_diandongmenBtn];
    
    _tianchuangBtn = [UIButton buttonWithColor:nil selColor:nil];
    _tianchuangBtn.frame = CGRectMake(leftRight+rowGap*5, height, width, width);
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_n.png"] forState:UIControlStateNormal];
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_s.png"] forState:UIControlStateHighlighted];
    [_tianchuangBtn setTitle:@"天窗" forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _tianchuangBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_tianchuangBtn setTitleEdgeInsets:UIEdgeInsetsMake(_tianchuangBtn.imageView.frame.size.height+10,-100,-25,20)];
    [_tianchuangBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-15,_tianchuangBtn.titleLabel.bounds.size.height-5, 0)];
    [_tianchuangBtn addTarget:self action:@selector(tianchuangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tianchuangBtn];
    
    int playerHeight = 60;
    
    UIButton *upBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    upBtn.frame = CGRectMake(leftRight+rowGap*2+30, SCREEN_HEIGHT-450+playerHeight, 80, 80);
    upBtn.layer.cornerRadius = 5;
    upBtn.layer.borderWidth = 2;
    upBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    upBtn.clipsToBounds = YES;
    [upBtn setImage:[UIImage imageNamed:@"user_electronic_up.png"] forState:UIControlStateNormal];
    [upBtn setImage:[UIImage imageNamed:@"user_electronic_up.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:upBtn];
    
    [upBtn addTarget:self
                       action:@selector(upAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    playBtn.frame = CGRectMake(leftRight+rowGap*3+30, SCREEN_HEIGHT-450+playerHeight, 80, 80);
    playBtn.layer.cornerRadius = 5;
    playBtn.layer.borderWidth = 2;
    playBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    playBtn.clipsToBounds = YES;
    [playBtn setImage:[UIImage imageNamed:@"user_electronic_play.png"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"user_electronic_play.png"] forState:UIControlStateHighlighted];
    playBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:playBtn];
    
    [upBtn addTarget:self action:@selector(playAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *downBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    downBtn.frame = CGRectMake(leftRight+rowGap*4+30, SCREEN_HEIGHT-450+playerHeight, 80, 80);
    downBtn.layer.cornerRadius = 5;
    downBtn.layer.borderWidth = 2;
    downBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    downBtn.clipsToBounds = YES;
    [downBtn setImage:[UIImage imageNamed:@"user_electronic_down.png"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"user_electronic_down.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:downBtn];
    
    [downBtn addTarget:self
                    action:@selector(downAction:)
          forControlEvents:UIControlEventTouchUpInside];
}
- (void) upAction:(id)sender{
}
- (void) playAction:(id)sender{
}
- (void) downAction:(id)sender{
}
- (void) tianchuangAction:(id)sender{
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_n.png"] forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_n.png"] forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_n.png"] forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmen_.png"] forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_s.png"] forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
}
- (void) diandongmenAction:(id)sender{
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_n.png"] forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_n.png"] forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_n.png"] forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmes_.png"] forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_n.png"] forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}
- (void) touyingjiAction:(id)sender{
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_n.png"] forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_s.png"] forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_n.png"] forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmen_.png"] forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_n.png"] forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}
- (void) touyingmuAction:(id)sender{
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_n.png"] forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_n.png"] forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_s.png"] forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmen_.png"] forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_n.png"] forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}
- (void) chuanglianAction:(id)sender{
    [_diandongchuanglianBtn setImage:[UIImage imageNamed:@"user_diandongchuanglian_s.png"] forState:UIControlStateNormal];
    [_diandongchuanglianBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_touyingjishengjiangBtn setImage:[UIImage imageNamed:@"user_projector_n.png"] forState:UIControlStateNormal];
    [_touyingjishengjiangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_touyingmuBtn setImage:[UIImage imageNamed:@"user_touyingmu_n.png"] forState:UIControlStateNormal];
    [_touyingmuBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_diandongmenBtn setImage:[UIImage imageNamed:@"user_diandongmen_.png"] forState:UIControlStateNormal];
    [_diandongmenBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    
    [_tianchuangBtn setImage:[UIImage imageNamed:@"user_camerashengjiang_n.png"] forState:UIControlStateNormal];
    [_tianchuangBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}

- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
