//
//  LvBoJunHeng_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "LvBoJunHeng_UIView.h"
#import "veenoon-Swift.h"
#import "UIButton+Color.h"
#import "SlideButton.h"

@interface LvBoJunHeng_UIView() <SlideButtonDelegate>{
    SlideButton *xielvSlider;
    SlideButton *xielvSlider2;
    
    SlideButton *fazhi;
    SlideButton *qidongshijian;
    SlideButton *huifushijian;
    
    UILabel *xielvL1;
    UILabel *xielvL2;
    UILabel *fazhiL;
    UILabel *huifushijianL;
    UILabel *qidongshijianL;
}

@property (nonatomic, strong) NSMutableArray *_boduanChannelBtns;
@end

@implementation LvBoJunHeng_UIView
@synthesize _boduanChannelBtns;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGRect rc = CGRectMake(0, 10, frame.size.width, 280);
        UIView *bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        rc = CGRectMake(0, 300, frame.size.width/4 -10, 200);
        bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        [self createGaoTong:bgv];
        
        rc = CGRectMake(frame.size.width/4, 300, frame.size.width/2, 200);
        bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        [self createBoDuan:bgv];
        
        rc = CGRectMake(frame.size.width/4 *3 +10, 300, frame.size.width/4-10, 200);
        bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        [self createDiTong:bgv];
        
        
        rc = CGRectMake(10, 20, frame.size.width-20, 260);
        FilterGraphView *lm = [[FilterGraphView alloc] initWithFrame:rc];
        lm.backgroundColor = [UIColor clearColor];
        [self addSubview:lm];
        
        
    }
    
    return self;
}

- (void) createGaoTong:(UIView*)view {
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"高通";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize: 15];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(0, 5, view.frame.size.width, 25);
    [view addSubview:addLabel];
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"类型";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(10, 35, view.frame.size.width, 25);
    [view addSubview:addLabel2];
    
    int btnStartX = 10;
    int btnY = 50;
    UIButton *leixingBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    leixingBtn.frame = CGRectMake(btnStartX+60, btnY-20, 100, 30);
    leixingBtn.layer.cornerRadius = 5;
    leixingBtn.layer.borderWidth = 2;
    leixingBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    leixingBtn.clipsToBounds = YES;
    [leixingBtn setTitle:@"  巴特沃斯" forState:UIControlStateNormal];
    leixingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    leixingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(leixingBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [leixingBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [leixingBtn addTarget:self
                action:@selector(leixingBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leixingBtn];
    
    
    UILabel *addLabel3 = [[UILabel alloc] init];
    addLabel3.text = @"频率 (HZ)";
    addLabel3.font = [UIFont systemFontOfSize: 13];
    addLabel3.textColor = [UIColor whiteColor];
    addLabel3.frame = CGRectMake(CGRectGetMaxX(leixingBtn.frame)-35, btnY+20, 75, 25);
    [view addSubview:addLabel3];
    
    btnY+=35;
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"斜率";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(10, btnY, view.frame.size.width, 25);
    [view addSubview:addLabel22];
    
    btnY+=30;
    UIButton *xielvBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    xielvBtn.frame = CGRectMake(btnStartX, btnY, 100, 30);
    xielvBtn.layer.cornerRadius = 5;
    xielvBtn.layer.borderWidth = 2;
    xielvBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    xielvBtn.clipsToBounds = YES;
    [xielvBtn setTitle:@"  -48dB/oct" forState:UIControlStateNormal];
    xielvBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    xielvBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon2 = [[UIImageView alloc]
                         initWithFrame:CGRectMake(xielvBtn.frame.size.width - 20, 10, 10, 10)];
    icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
    [xielvBtn addSubview:icon2];
    icon2.alpha = 0.8;
    icon2.layer.contentsGravity = kCAGravityResizeAspect;
    [xielvBtn addTarget:self
                   action:@selector(xielvBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:xielvBtn];
    
    xielvSlider = [[SlideButton alloc] initWithFrame:CGRectMake(100, 70, 120, 120)];
    xielvSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider enableValueSet:YES];
    xielvSlider.delegate = self;
    xielvSlider.tag = 1;
    [view addSubview:xielvSlider];
    
    xielvL1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 180, 120, 20)];
    xielvL1.text = @"-12dB";
    xielvL1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:xielvL1];
    xielvL1.font = [UIFont systemFontOfSize:13];
    xielvL1.textColor = YELLOW_COLOR;
    
    
    UIButton *zhitongBtn1 = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zhitongBtn1.frame = CGRectMake(10, view.frame.size.height - 30, 50, 25);
    zhitongBtn1.layer.cornerRadius = 5;
    zhitongBtn1.layer.borderWidth = 2;
    zhitongBtn1.layer.borderColor = [UIColor clearColor].CGColor;;
    zhitongBtn1.clipsToBounds = YES;
    [zhitongBtn1 setTitle:@"直通" forState:UIControlStateNormal];
    zhitongBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhitongBtn1 addTarget:self
                   action:@selector(zhitongBtn1Action:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zhitongBtn1];
}
- (void) zhitongBtn1Action:(id) sender {
    
}
- (void) xielvBtnAction:(id) sender {
    
}

- (void) leixingBtnAction:(id) sender {
    
}

- (void) createBoDuan:(UIView*)view {
    
    int num = 16;
    
    self._boduanChannelBtns = [NSMutableArray array];
    
    float x = 15;
    int y = 10;
    int bw = 40;
    int bh = 25;
    
    float spx = (view.frame.size.width - bw * 8 - x *2)/7;
    if(spx > 10)
        spx = 10;
    for(int i = 0; i < num; i++) {
        UIButton *btn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
        btn.frame = CGRectMake(x+15, y, bw, bh);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        btn.tag = i;
        [view addSubview:btn];
        
        if(i == 0)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        }
        
        [btn addTarget:self
                action:@selector(boduanChannelBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 7) {
            x = 15;
            y += bh + spx;
        } else {
            x+=bw;
            x+=spx;
        }
        
        [_channelBtns addObject:btn];
    }
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"类型";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(10, 95, view.frame.size.width, 25);
    [view addSubview:addLabel2];
    
    int btnStartX = 10;
    int btnY = 125;
    UIButton *leixingBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    leixingBtn.frame = CGRectMake(btnStartX, btnY, 100, 30);
    leixingBtn.layer.cornerRadius = 5;
    leixingBtn.layer.borderWidth = 2;
    leixingBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    leixingBtn.clipsToBounds = YES;
    [leixingBtn setTitle:@"  参量均衡" forState:UIControlStateNormal];
    leixingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    leixingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(leixingBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [leixingBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [leixingBtn addTarget:self
                   action:@selector(leixingBtn2Action:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leixingBtn];
    
    
    int startX = 120;
    int gap = 100;
    int labelY = 80;
    int labelBtnGap = 0;
    int weiYi = 20;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"频率 (Hz)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(startX+weiYi+12, labelY, 120, 20);
    [view addSubview:addLabel];
    
    fazhi = [[SlideButton alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap, 120, 120)];
    fazhi._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    fazhi._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [fazhi enableValueSet:YES];
    fazhi.delegate = self;
    fazhi.tag = 3;
    [view addSubview:fazhi];
    
    fazhiL = [[UILabel alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap+95, 120, 20)];
    fazhiL.text = @"-12dB";
    fazhiL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:fazhiL];
    fazhiL.font = [UIFont systemFontOfSize:13];
    fazhiL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel23 = [[UILabel alloc] init];
    addLabel23.text = @"增益 (dB)";
    addLabel23.font = [UIFont systemFontOfSize: 13];
    addLabel23.textColor = [UIColor whiteColor];
    addLabel23.frame = CGRectMake(startX+gap+weiYi+10, labelY, 120, 20);
    [view addSubview:addLabel23];
    
    qidongshijian = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    qidongshijian._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    qidongshijian._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [qidongshijian enableValueSet:YES];
    qidongshijian.delegate = self;
    qidongshijian.tag = 4;
    [view addSubview:qidongshijian];
    
    qidongshijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap+95, 120, 20)];
    qidongshijianL.text = @"-12dB";
    qidongshijianL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:qidongshijianL];
    qidongshijianL.font = [UIFont systemFontOfSize:13];
    qidongshijianL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel224= [[UILabel alloc] init];
    addLabel224.text = @"Q";
    addLabel224.font = [UIFont systemFontOfSize: 13];
    addLabel224.textColor = [UIColor whiteColor];
    addLabel224.frame = CGRectMake(startX+gap*2+weiYi+33, labelY, 120, 20);
    [view addSubview:addLabel224];
    
    huifushijian = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap, 120, 120)];
    huifushijian._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    huifushijian._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [huifushijian enableValueSet:YES];
    huifushijian.delegate = self;
    huifushijian.tag = 5;
    [view addSubview:huifushijian];
    
    huifushijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap+95, 120, 20)];
    huifushijianL.text = @"-12dB";
    huifushijianL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:huifushijianL];
    huifushijianL.font = [UIFont systemFontOfSize:13];
    huifushijianL.textColor = YELLOW_COLOR;
    
    UIButton *zhitongBtn1 = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zhitongBtn1.frame = CGRectMake(10, view.frame.size.height - 30, 50, 25);
    zhitongBtn1.layer.cornerRadius = 5;
    zhitongBtn1.layer.borderWidth = 2;
    zhitongBtn1.layer.borderColor = [UIColor clearColor].CGColor;;
    zhitongBtn1.clipsToBounds = YES;
    [zhitongBtn1 setTitle:@"直通" forState:UIControlStateNormal];
    zhitongBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhitongBtn1 addTarget:self
                    action:@selector(zhitongBtn2Action:)
          forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zhitongBtn1];
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%dB", k];
        
        xielvL1.text = valueStr;
    } else if (tag == 2) {
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%dB", k];
        
        xielvL2.text = valueStr;
    } else if (tag == 3) {
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%dB", k];
        
        fazhiL.text = valueStr;
    } else if (tag == 4) {
        int k = (value *2000)-1000;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        qidongshijianL.text = valueStr;
    } else {
        int k = (value *2000)-1000;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        huifushijianL.text = valueStr;
    }
}

- (void) leixingBtn2Action:(id)sender {
    
}


- (void) zhitongBtn2Action:(id)sender {
    
}

- (void) createDiTong:(UIView*)view {
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"低通";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize: 15];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(0, 5, view.frame.size.width, 25);
    [view addSubview:addLabel];
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"类型";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(10, 35, view.frame.size.width, 25);
    [view addSubview:addLabel2];
    
    int btnStartX = 10;
    int btnY = 50;
    UIButton *leixingBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    leixingBtn.frame = CGRectMake(btnStartX+60, btnY-20, 100, 30);
    leixingBtn.layer.cornerRadius = 5;
    leixingBtn.layer.borderWidth = 2;
    leixingBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    leixingBtn.clipsToBounds = YES;
    [leixingBtn setTitle:@"  巴特沃斯" forState:UIControlStateNormal];
    leixingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    leixingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(leixingBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [leixingBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [leixingBtn addTarget:self
                   action:@selector(leixingBtn3Action:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leixingBtn];
    
    
    UILabel *addLabel3 = [[UILabel alloc] init];
    addLabel3.text = @"频率 (HZ)";
    addLabel3.font = [UIFont systemFontOfSize: 13];
    addLabel3.textColor = [UIColor whiteColor];
    addLabel3.frame = CGRectMake(CGRectGetMaxX(leixingBtn.frame)-35, btnY+20, 75, 25);
    [view addSubview:addLabel3];
    
    btnY+=35;
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"斜率";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(10, btnY, view.frame.size.width, 25);
    [view addSubview:addLabel22];
    
    btnY+=30;
    UIButton *xielvBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    xielvBtn.frame = CGRectMake(btnStartX, btnY, 100, 30);
    xielvBtn.layer.cornerRadius = 5;
    xielvBtn.layer.borderWidth = 2;
    xielvBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    xielvBtn.clipsToBounds = YES;
    [xielvBtn setTitle:@"  -48dB/oct" forState:UIControlStateNormal];
    xielvBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    xielvBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon2 = [[UIImageView alloc]
                          initWithFrame:CGRectMake(xielvBtn.frame.size.width - 20, 10, 10, 10)];
    icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
    [xielvBtn addSubview:icon2];
    icon2.alpha = 0.8;
    icon2.layer.contentsGravity = kCAGravityResizeAspect;
    [xielvBtn addTarget:self
                 action:@selector(xielvBtn2Action:)
       forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:xielvBtn];
    
    xielvSlider2 = [[SlideButton alloc] initWithFrame:CGRectMake(100, 70, 120, 120)];
    xielvSlider2._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider2._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider2 enableValueSet:YES];
    xielvSlider2.delegate = self;
    xielvSlider2.tag = 2;
    [view addSubview:xielvSlider2];
    
    xielvL2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 180, 120, 20)];
    xielvL2.text = @"-12dB";
    xielvL2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:xielvL2];
    xielvL2.font = [UIFont systemFontOfSize:13];
    xielvL2.textColor = YELLOW_COLOR;
    
    UIButton *zhitongBtn1 = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zhitongBtn1.frame = CGRectMake(10, view.frame.size.height - 30, 50, 25);
    zhitongBtn1.layer.cornerRadius = 5;
    zhitongBtn1.layer.borderWidth = 2;
    zhitongBtn1.layer.borderColor = [UIColor clearColor].CGColor;;
    zhitongBtn1.clipsToBounds = YES;
    [zhitongBtn1 setTitle:@"直通" forState:UIControlStateNormal];
    zhitongBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhitongBtn1 addTarget:self
                    action:@selector(zhitongBtn3Action:)
          forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zhitongBtn1];
}
-(void) leixingBtn3Action:(id)sender {
    
}

-(void) xielvBtn2Action:(id)sender {
    
}

- (void) zhitongBtn3Action:(id) sender {
    
}

- (void) boduanChannelBtnAction:(UIButton*)sender{
    
    for(UIButton * btn in _boduanChannelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
- (void) channelBtnAction:(UIButton*)sender{
    
    for(UIButton * btn in _channelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

@end
