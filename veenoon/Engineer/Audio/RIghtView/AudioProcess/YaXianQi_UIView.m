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

@interface YaXianQi_UIView()
{
    UIButton *channelBtn;
    
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
    
    SlideButton *btn1 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    [contentView addSubview:btn1];
    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"斜率";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *btn2 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    [contentView addSubview:btn2];


    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"启动时间（ms）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *btn3 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    [contentView addSubview:btn3];

    
    x+=120;
    x+=10;
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 120, 20)];
    tL.text = @"恢复时间（ms）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *btn4 = [[SlideButton alloc] initWithFrame:CGRectMake(x, y+20, 120, 120)];
    [contentView addSubview:btn4];

}

@end
