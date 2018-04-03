//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ZaoShengMen_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"

@interface ZaoShengMen_UIView() <SlideButtonDelegate>{
    
    UIButton *channelBtn;
    
    SlideButton *fazhi;
    SlideButton *qidongshijian;
    SlideButton *huifushijian;
    
    UILabel *fazhiL;
    UILabel *qidongshijianL;
    UILabel *huifushijianL;
}

@end


@implementation ZaoShengMen_UIView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        channelBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 70, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [channelBtn setTitle:@"In 1" forState:UIControlStateNormal];
        [channelBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+20;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
        

        [self contentViewComps];
    }
    
    return self;
}

- (void) channelBtnAction:(UIButton*)sender{
    
    int tag = (int)sender.tag+1;
    [channelBtn setTitle:[NSString stringWithFormat:@"In %d", tag] forState:UIControlStateNormal];
    
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

- (void) contentViewComps{
    int startX = 140;
    int gap = 250;
    int labelY = 100;
    int labelBtnGap = 25;
    int weiYi = 20;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"阀值 (db)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(startX+weiYi+12, labelY, 120, 20);
    [contentView addSubview:addLabel];
    
    fazhi = [[SlideButton alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap, 120, 120)];
    fazhi._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    fazhi._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [fazhi enableValueSet:YES];
    fazhi.delegate = self;
    fazhi.tag = 1;
    [contentView addSubview:fazhi];
    
    fazhiL = [[UILabel alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap+120, 120, 20)];
    fazhiL.text = @"-12dB";
    fazhiL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:fazhiL];
    fazhiL.font = [UIFont systemFontOfSize:13];
    fazhiL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"启动时间 (ms)";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(startX+gap+weiYi, labelY, 120, 20);
    [contentView addSubview:addLabel2];
    
    qidongshijian = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    qidongshijian._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    qidongshijian._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [qidongshijian enableValueSet:YES];
    qidongshijian.delegate = self;
    qidongshijian.tag = 2;
    [contentView addSubview:qidongshijian];
    
    qidongshijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap+120, 120, 20)];
    qidongshijianL.text = @"-12dB";
    qidongshijianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:qidongshijianL];
    qidongshijianL.font = [UIFont systemFontOfSize:13];
    qidongshijianL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"恢复时间 (ms)";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(startX+gap*2+weiYi, labelY, 120, 20);
    [contentView addSubview:addLabel22];
    
    huifushijian = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap, 120, 120)];
    huifushijian._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    huifushijian._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [huifushijian enableValueSet:YES];
    huifushijian.delegate = self;
    huifushijian.tag = 3;
    [contentView addSubview:huifushijian];
    
    huifushijianL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap+120, 120, 20)];
    huifushijianL.text = @"-12dB";
    huifushijianL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:huifushijianL];
    huifushijianL.font = [UIFont systemFontOfSize:13];
    huifushijianL.textColor = YELLOW_COLOR;
    
    
    UIButton *zhitongBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zhitongBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height - 40, 50, 30);
    zhitongBtn.layer.cornerRadius = 5;
    zhitongBtn.layer.borderWidth = 2;
    zhitongBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zhitongBtn.clipsToBounds = YES;
    [zhitongBtn setTitle:@"启用" forState:UIControlStateNormal];
    zhitongBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhitongBtn addTarget:self
                action:@selector(zhitongBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:zhitongBtn];
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        fazhiL.text = valueStr;
    } else if (tag == 2) {
        int k = (value *2000)-1000;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        qidongshijianL.text = valueStr;
    } else {
        int k = (value *2000)-1000;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        huifushijianL.text = valueStr;
    }
}
- (void) zhitongBtnAction:(id) sender {
    
}
@end


