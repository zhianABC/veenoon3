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

@interface ZaoShengMen_UIView() {
    
    UIButton *channelBtn;
    
    SlideButton *fazhi;
    SlideButton *qidongshijian;
    SlideButton *huifushijian;
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
    int startX = 150;
    int gap = 250;
    int labelY = 100;
    int labelBtnGap = 50;
    int weiYi = 20;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"阀值 (db)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(startX+weiYi+12, labelY, 120, 20);
    [contentView addSubview:addLabel];
    
    fazhi = [[SlideButton alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap, 120, 120)];
    [contentView addSubview:fazhi];
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"启动时间 (ms)";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(startX+gap+weiYi, labelY, 120, 20);
    [contentView addSubview:addLabel2];
    
    qidongshijian = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    [contentView addSubview:qidongshijian];
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"恢复时间 (ms)";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(startX+gap*2+weiYi, labelY, 120, 20);
    [contentView addSubview:addLabel22];
    
    huifushijian = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap, 120, 120)];
    [contentView addSubview:huifushijian];
    
    
    UIButton *zhitongBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zhitongBtn.frame = CGRectMake(CGRectGetMaxX(qidongshijian.frame) - 85, CGRectGetMaxY(qidongshijian.frame) + 35, 50, 30);
    zhitongBtn.layer.cornerRadius = 5;
    zhitongBtn.layer.borderWidth = 2;
    zhitongBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zhitongBtn.clipsToBounds = YES;
    [zhitongBtn setTitle:@"直通" forState:UIControlStateNormal];
    zhitongBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [zhitongBtn addTarget:self
                action:@selector(zhitongBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:zhitongBtn];
}
- (void) zhitongBtnAction:(id) sender {
    
}
@end


