//
//  ZiDongHunYin_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ZiDongHunYin_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface ZiDongHunYin_UIView() <SlideButtonDelegate> {
    UIButton *channelBtn;
    
    SlideButton *zengyi;
    
    UILabel *labelL1;
    
    UIButton *qidongBtn;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end

@implementation ZiDongHunYin_UIView
@synthesize _curProxy;

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
        contentView.frame  = CGRectMake(0, y, frame.size.width, 340);
        
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
    int idx = (int)sender.tag;
    self._curProxy = [self._proxys objectAtIndex:idx];
    
    NSString *name = _curProxy._rgsProxyObj.name;
    [channelBtn setTitle:name forState:UIControlStateNormal];
}

- (void) contentViewComps{
    int startX = 140;
    int gap = 250;
    int labelY = 100;
    int labelBtnGap = 0;
    int weiYi = 30;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"增益 (dB)";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(startX+gap+weiYi, labelY-20, 120, 20);
    [contentView addSubview:addLabel2];
    
    SlideButton *zengyi = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    zengyi._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    zengyi._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [zengyi enableValueSet:YES];
    zengyi.delegate = self;
    zengyi.tag = 3;
    [contentView addSubview:zengyi];
    
    labelL1 = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap+80, 120, 120)];
    labelL1.text = @"-20dB";
    labelL1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelL1];
    labelL1.font = [UIFont systemFontOfSize:13];
    labelL1.textColor = YELLOW_COLOR;
    
    qidongBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    qidongBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height - 40, 50, 30);
    qidongBtn.layer.cornerRadius = 5;
    qidongBtn.layer.borderWidth = 2;
    qidongBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    qidongBtn.clipsToBounds = YES;
    [qidongBtn setTitle:@"启用" forState:UIControlStateNormal];
    qidongBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [qidongBtn addTarget:self
                   action:@selector(qiyongBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:qidongBtn];
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int k = (value *40)-20;
    NSString *valueStr= [NSString stringWithFormat:@"%dB", k];
    
    labelL1.text = valueStr;
}
- (void) qiyongBtnAction:(id) sender {
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy isZiDongHunYinStarted];
    
    [_curProxy controlZiDongHunYin:!isMute];
    
    [self updateMuteButtonState];
}

- (void) updateMuteButtonState{
    
    BOOL isZiDongHunYin = [_curProxy isZiDongHunYinStarted];
    
    if(isZiDongHunYin)
    {
        [qidongBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [qidongBtn changeNormalColor:RGB(75, 163, 202)];
    }
}

@end
