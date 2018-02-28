//
//  AudioInputSettingViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "HunyinYinpinchuliViewCtrl.h"
#import "UIButton+Color.h"
#import "Fenpinqi_UIView.h"
#import "JunHengQi_UIView.h"
#import "ZaoShengYaXian_UIView.h"

@interface HunyinYinpinchuliViewCtrl ()
{
    Fenpinqi_UIView *fenpinqi;
    JunHengQi_UIView *junhengqi;
    ZaoShengYaXian_UIView *zaoshengView;
    
    UIButton *fenpingBtn;
    UIButton *junhengqiBtn;
    UIButton *zaoshengmenBtn;
}
@end

@implementation HunyinYinpinchuliViewCtrl

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
    int bw = 100;
    int bh = 30;
    
    fenpingBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    fenpingBtn.frame = CGRectMake(startX, startY, bw, bh);
    fenpingBtn.clipsToBounds = YES;
    fenpingBtn.layer.cornerRadius = 5;
    fenpingBtn.layer.borderWidth = 2;
    fenpingBtn.layer.borderColor = [UIColor clearColor].CGColor;
    fenpingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fenpingBtn setTitle:@"分频器" forState:UIControlStateNormal];
    [fenpingBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [fenpingBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:fenpingBtn];
    [fenpingBtn addTarget:self
                  action:@selector(fenpinAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    junhengqiBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    junhengqiBtn.frame = CGRectMake(CGRectGetMaxX(fenpingBtn.frame) + gap, startY, bw, bh);
    junhengqiBtn.clipsToBounds = YES;
    junhengqiBtn.layer.cornerRadius = 5;
    junhengqiBtn.layer.borderWidth = 2;
    junhengqiBtn.layer.borderColor = [UIColor clearColor].CGColor;
    junhengqiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [junhengqiBtn setTitle:@"均衡器" forState:UIControlStateNormal];
    [junhengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [junhengqiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:junhengqiBtn];
    [junhengqiBtn addTarget:self
                       action:@selector(junhengAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    zaoshengmenBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
    zaoshengmenBtn.frame = CGRectMake(CGRectGetMaxX(junhengqiBtn.frame) + gap, startY, bw, bh);
    zaoshengmenBtn.clipsToBounds = YES;
    zaoshengmenBtn.layer.cornerRadius = 5;
    zaoshengmenBtn.layer.borderWidth = 2;
    zaoshengmenBtn.layer.borderColor = [UIColor clearColor].CGColor;
    zaoshengmenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [zaoshengmenBtn setTitle:@"噪声／压限" forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:zaoshengmenBtn];
    [zaoshengmenBtn addTarget:self
                  action:@selector(zaoshengyaxianAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect vrc = CGRectMake(60, 140, SCREEN_WIDTH-120, SCREEN_HEIGHT-140-60);
    
    fenpinqi = [[Fenpinqi_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:fenpinqi];
    fenpinqi.hidden = NO;
    
    junhengqi = [[JunHengQi_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:junhengqi];
    junhengqi.hidden = YES;
    
    zaoshengView = [[ZaoShengYaXian_UIView alloc] initWithFrame:vrc];
    [self.view addSubview:zaoshengView];
    zaoshengView.hidden = YES;
    
}
- (void) junhengAction:(id)sender{
    [fenpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [junhengqiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    
    fenpinqi.hidden = YES;
    junhengqi.hidden = NO;
    zaoshengView.hidden = YES;
    
}
- (void) zaoshengyaxianAction:(id)sender{
    [zaoshengmenBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [junhengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fenpingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    junhengqi.hidden = YES;
    fenpinqi.hidden = YES;
    zaoshengView.hidden = NO;
}
- (void) fenpinAction:(id)sender{
    [fenpingBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [junhengqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zaoshengmenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    junhengqi.hidden = YES;
    fenpinqi.hidden = NO;
    zaoshengView.hidden = YES;
}

- (void) okAction:(id)sender{
    
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

