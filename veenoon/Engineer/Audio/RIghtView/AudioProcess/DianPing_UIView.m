//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DianPing_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"

@interface DianPing_UIView() {
    
    UIButton *channelBtn;
    
    //UIView   *contentView;
    SlideButton *fazhi;
    SlideButton *qidongshijian;
    SlideButton *huifushijian;
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;

@end


@implementation DianPing_UIView
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
        [channelBtn setTitle:@"Out 1" forState:UIControlStateNormal];
        [channelBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+20;
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
//
        [self contentViewComps];
    }
    
    return self;
}


- (void) channelBtnAction:(UIButton*)sender{
    
    int tag = (int)sender.tag+1;
    [channelBtn setTitle:[NSString stringWithFormat:@"Out %d", tag] forState:UIControlStateNormal];
    
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
    int btnStartX = 250;
    int btnY = 150;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"频率 (Hz)";
    addLabel2.font = [UIFont boldSystemFontOfSize: 14];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(btnStartX, btnY -30, 120, 20);
    [contentView addSubview:addLabel2];
    
    UIButton *lineBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    lineBtn.frame = CGRectMake(btnStartX, btnY, 120, 30);
    lineBtn.layer.cornerRadius = 5;
    lineBtn.layer.borderWidth = 2;
    lineBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lineBtn.clipsToBounds = YES;
    [lineBtn setTitle:@"  0db" forState:UIControlStateNormal];
    lineBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    lineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(lineBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [lineBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [lineBtn addTarget:self
                action:@selector(lineBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:lineBtn];
    
    UIButton *zerodbBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zerodbBtn.frame = CGRectMake(CGRectGetMaxX(lineBtn.frame)+20, btnY, 50, 30);
    zerodbBtn.layer.cornerRadius = 5;
    zerodbBtn.layer.borderWidth = 2;
    zerodbBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zerodbBtn.clipsToBounds = YES;
    [zerodbBtn setTitle:@"  反相" forState:UIControlStateNormal];
    zerodbBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    zerodbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [contentView addSubview:zerodbBtn];
    
    
    UIButton *muteBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    muteBtn.frame = CGRectMake(CGRectGetMaxX(zerodbBtn.frame)+10, btnY, 50, 30);
    muteBtn.layer.cornerRadius = 5;
    muteBtn.layer.borderWidth = 2;
    muteBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    muteBtn.clipsToBounds = YES;
    [muteBtn setTitle:@"静音" forState:UIControlStateNormal];
    muteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [muteBtn addTarget:self
                action:@selector(muteBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:muteBtn];
    
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"增益 (dB)";
    addLabel.font = [UIFont boldSystemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(630, 120, 120, 20);
    [contentView addSubview:addLabel];
    
    SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(600, 135, 120, 120)];
    [contentView addSubview:btn];
}

-(void) bianzuAction:(id) sender {
    
}
-(void) lineBtnAction:(id) sender {
    
}

-(void) muteBtnAction:(id) sender {
    
}

@end



