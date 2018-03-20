//
//  AudioInputSettingViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioInputSettingViewCtrl.h"
#import "UIButton+Color.h"
#import "YaXianQi_UIView.h"
#import "ZengYi_UIView.h"
#import "ZaoShengMen_UIView.h"
#import "YanShiQi_UIView.h"
#import "HuiShengXiaoChu_UIView.h"
#import "LvBoJunHeng_UIView.h"
#import "YinPinProcessCodeUIView.h"
#import "ZiDongHunYin_UIView.h"

@interface AudioInputSettingViewCtrl () <HuiShengXiaoChu_UIViewDelegate> {
    YaXianQi_UIView *yxq;
    ZengYi_UIView *zengyiView;
    ZaoShengMen_UIView *zaoshengView;
    YanShiQi_UIView *yanshiView;
    HuiShengXiaoChu_UIView *huishengView;
    ZiDongHunYin_UIView *zidonghunyinView;
    
    LvBoJunHeng_UIView *lvbo;
    
    UIButton *zengyiBtn;
    UIButton *yaxianBtn;
    UIButton *zaoshengmenBtn;
    UIButton *yanshiqiBtn;
    UIButton *huishengxiaochuBtn;
    UIButton *lvbojunhengBtn;
    UIButton *zidonghunyinBtn;
}
@property (nonatomic, strong) UIButton *_curSelectBtn;

@end

@implementation AudioInputSettingViewCtrl
@synthesize _curSelectBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
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
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int startX = 60;
    int startY = 100;
    int gap = 10;
    int bw = 80;
    int bh = 30;
    
    zengyiBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    zengyiBtn.frame = CGRectMake(startX, startY, bw, bh);
    zengyiBtn.clipsToBounds = YES;
    zengyiBtn.layer.cornerRadius = 5;
    zengyiBtn.layer.borderWidth = 2;
    zengyiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zengyiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zengyiBtn setTitle:@"增益" forState:UIControlStateNormal];
    [zengyiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [zengyiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zengyiBtn];
    [zengyiBtn addTarget:self
                    action:@selector(zengyiAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    zaoshengmenBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    zaoshengmenBtn.frame = CGRectMake(CGRectGetMaxX(zengyiBtn.frame) + gap, startY, bw, bh);
    zaoshengmenBtn.clipsToBounds = YES;
    zaoshengmenBtn.layer.cornerRadius = 5;
    zaoshengmenBtn.layer.borderWidth = 2;
    zaoshengmenBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zaoshengmenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zaoshengmenBtn setTitle:@"噪声门" forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zaoshengmenBtn];
    [zaoshengmenBtn addTarget:self
                  action:@selector(zaoshengmenAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    lvbojunhengBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    lvbojunhengBtn.frame = CGRectMake(CGRectGetMaxX(zaoshengmenBtn.frame) + gap, startY, bw, bh);
    lvbojunhengBtn.clipsToBounds = YES;
    lvbojunhengBtn.layer.cornerRadius = 5;
    lvbojunhengBtn.layer.borderWidth = 2;
    lvbojunhengBtn.layer.borderColor = [UIColor clearColor].CGColor;
    lvbojunhengBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [lvbojunhengBtn setTitle:@"滤波/均衡" forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lvbojunhengBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:lvbojunhengBtn];
    [lvbojunhengBtn addTarget:self
                       action:@selector(lvbojunhengAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    yaxianBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    yaxianBtn.frame = CGRectMake(CGRectGetMaxX(lvbojunhengBtn.frame) + gap, startY, bw, bh);
    yaxianBtn.clipsToBounds = YES;
    yaxianBtn.layer.cornerRadius = 5;
    yaxianBtn.layer.borderWidth = 2;
    yaxianBtn.layer.borderColor = [UIColor clearColor].CGColor;
    yaxianBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [yaxianBtn setTitle:@"压限器" forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yaxianBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:yaxianBtn];
    [yaxianBtn addTarget:self
                       action:@selector(yaxianqiAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    yanshiqiBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    yanshiqiBtn.frame = CGRectMake(CGRectGetMaxX(yaxianBtn.frame) + gap, startY, bw, bh);
    yanshiqiBtn.clipsToBounds = YES;
    yanshiqiBtn.layer.cornerRadius = 5;
    yanshiqiBtn.layer.borderWidth = 2;
    yanshiqiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    yanshiqiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [yanshiqiBtn setTitle:@"延时器" forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yanshiqiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:yanshiqiBtn];
    [yanshiqiBtn addTarget:self
                       action:@selector(yanshiqiAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    huishengxiaochuBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    huishengxiaochuBtn.frame = CGRectMake(CGRectGetMaxX(yanshiqiBtn.frame) + gap, startY, bw, bh);
    huishengxiaochuBtn.clipsToBounds = YES;
    huishengxiaochuBtn.layer.cornerRadius = 5;
    huishengxiaochuBtn.layer.borderWidth = 2;
    huishengxiaochuBtn.layer.borderColor = [UIColor clearColor].CGColor;
    huishengxiaochuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [huishengxiaochuBtn setTitle:@"回声消除" forState:UIControlStateNormal];
    [huishengxiaochuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [huishengxiaochuBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:huishengxiaochuBtn];
    [huishengxiaochuBtn addTarget:self
                       action:@selector(huishengxiaochuAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    zidonghunyinBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    zidonghunyinBtn.frame = CGRectMake(CGRectGetMaxX(huishengxiaochuBtn.frame) + gap, startY, bw, bh);
    zidonghunyinBtn.clipsToBounds = YES;
    zidonghunyinBtn.layer.cornerRadius = 5;
    zidonghunyinBtn.layer.borderWidth = 2;
    zidonghunyinBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zidonghunyinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zidonghunyinBtn setTitle:@"自动混音" forState:UIControlStateNormal];
    [zidonghunyinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zidonghunyinBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zidonghunyinBtn];
    [zidonghunyinBtn addTarget:self
                       action:@selector(zidonghunyinAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect vrc = CGRectMake(60, 140, SCREEN_WIDTH-120, SCREEN_HEIGHT-140-60);
    
    yxq = [[YaXianQi_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:yxq];
    yxq.hidden = YES;
    
    zengyiView = [[ZengYi_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:zengyiView];
    zengyiView.hidden = NO;

    
    zaoshengView = [[ZaoShengMen_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:zaoshengView];
    zaoshengView.hidden = YES;
    
    yanshiView = [[YanShiQi_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:yanshiView];
    yanshiView.hidden = YES;
    lvbo = [[LvBoJunHeng_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:lvbo];
    lvbo.hidden = YES;
    
    huishengView = [[HuiShengXiaoChu_UIView alloc] initWithFrame:vrc];
    huishengView.delegate_ = self;
    [self.view addSubview:huishengView];
    huishengView.hidden = YES;
    
    zidonghunyinView = [[ZiDongHunYin_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:zidonghunyinView];
    zidonghunyinView.hidden = YES;
    
    self._curSelectBtn = zengyiBtn;
    [zengyiBtn changeNormalColor:BLUE_DOWN_COLOR];
}
- (void) zidonghunyinAction:(UIButton*)sender{
   
    if(_curSelectBtn == sender)
    {
        return;
    }

    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=NO;
}
- (void) huishengxiaochuAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = NO;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
}
- (void) yanshiqiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = NO;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
}
- (void) yaxianqiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = NO;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
    
}
- (void) lvbojunhengAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=NO;
    zidonghunyinView.hidden=YES;
}
- (void) zaoshengmenAction:(UIButton*)sender{
   
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = YES;
    yxq.hidden = YES;
    zaoshengView.hidden = NO;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
}
- (void) zengyiAction:(UIButton*)sender{
    
    if(_curSelectBtn == sender)
    {
        return;
    }
    
    [_curSelectBtn changeNormalColor:RGB(0, 89, 118)];
    [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:BLUE_DOWN_COLOR];
    
    self._curSelectBtn = sender;
    
    zengyiView.hidden = NO;
    yxq.hidden = YES;
    zaoshengView.hidden = YES;
    huishengView.hidden = YES;
    yanshiView.hidden = YES;
    lvbo.hidden=YES;
    zidonghunyinView.hidden=YES;
}
- (void) didAecButtonAction {
    YinPinProcessCodeUIView *uiView = [[YinPinProcessCodeUIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self.view addSubview:uiView];
}
- (void) okAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
