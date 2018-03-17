//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "YaXianQi_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "GradeLineView.h"

@interface YaXianQi_UIView() <SlideButtonDelegate>
{
    UIButton *channelBtn;
    
    UILabel *lableL1;
    UILabel *lableL2;
    UILabel *lableL3;
    UILabel *lableL4;
    
}

@end


@implementation YaXianQi_UIView
//@synthesize _channelBtns;
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
    
    int w = CGRectGetHeight(contentView.frame)*0.8;
    int m = w%5;
    w = w-m;
    
    int y = (CGRectGetHeight(contentView.frame) - w)/2;
    CGRect rc = CGRectMake(50, y+20, w, w);
    GradeLineView *g = [[GradeLineView alloc] initWithFrame:rc];
    
    [contentView addSubview:g];
    
    [g drawXY:@[@"-100",@"-77",@"-54",@"-31",@"-8",@"15"]
            y:@[@"15",@"-8",@"-31",@"-54",@"-77"]];
    [g processValueToPoints];
    
    g.backgroundColor = [UIColor clearColor];
    
    int x = CGRectGetMaxX(g.frame);
    y = CGRectGetHeight(contentView.frame)/2-50;
    x+=10;
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"阀值（db）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *xielvSlider1 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    xielvSlider1._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider1._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider1 enableValueSet:YES];
    xielvSlider1.delegate = self;
    xielvSlider1.tag = 1;
    [contentView addSubview:xielvSlider1];
    
    lableL1 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL1.text = @"-12dB";
    lableL1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL1];
    lableL1.font = [UIFont systemFontOfSize:13];
    lableL1.textColor = YELLOW_COLOR;
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"斜率";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];

    SlideButton *xielvSlider2 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    xielvSlider2._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider2._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider2 enableValueSet:YES];
    xielvSlider2.delegate = self;
    xielvSlider2.tag = 2;
    [contentView addSubview:xielvSlider2];

    lableL2 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL2.text = @"-12dB";
    lableL2.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL2];
    lableL2.font = [UIFont systemFontOfSize:13];
    lableL2.textColor = YELLOW_COLOR;
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"启动时间（ms）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *xielvSlider3 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    xielvSlider3._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider3._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider3 enableValueSet:YES];
    xielvSlider3.delegate = self;
    xielvSlider3.tag = 3;
    [contentView addSubview:xielvSlider3];

    lableL3 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL3.text = @"0";
    lableL3.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL3];
    lableL3.font = [UIFont systemFontOfSize:13];
    lableL3.textColor = YELLOW_COLOR;
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"恢复时间（ms）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *xielvSlider4 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    xielvSlider4._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider4._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider4 enableValueSet:YES];
    xielvSlider4.delegate = self;
    xielvSlider4.tag = 3;
    [contentView addSubview:xielvSlider4];
    
    lableL4 = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20+120, 120, 20)];
    lableL4.text = @"0";
    lableL4.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:lableL4];
    lableL4.font = [UIFont systemFontOfSize:13];
    lableL4.textColor = YELLOW_COLOR;

}
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (tag == 1) {
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%dB", k];
        
        lableL1.text = valueStr;
    } else if (tag == 2) {
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%dB", k];
        
        lableL2.text = valueStr;
    } else if (tag == 3) {
        int k = (value *1000)-500;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        lableL3.text = valueStr;
    } else {
        int k = (value *2000)-1000;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        lableL4.text = valueStr;
    }
}
@end
