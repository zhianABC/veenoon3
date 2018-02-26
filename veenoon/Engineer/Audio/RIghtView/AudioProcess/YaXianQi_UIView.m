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

@interface YaXianQi_UIView()
{
    UIButton *channelBtn;
    
    UIView   *contentView;
}
@property (nonatomic, strong) NSMutableArray *_channelBtns;

@end


@implementation YaXianQi_UIView
@synthesize _channelBtns;
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
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 360)];
        [self addSubview:contentView];
        contentView.layer.cornerRadius = 5;
        contentView.clipsToBounds = YES;
        contentView.backgroundColor = RGB(0, 89, 118);
        
        [self layoutChannelBtns:16];
        [self contentViewComps];
    }
    
    return self;
}

- (void) layoutChannelBtns:(int)num{
    
    self._channelBtns = [NSMutableArray array];
    
    int x = 0;
    int y = CGRectGetHeight(self.frame)-60;
    
    int spx = (CGRectGetWidth(self.frame) - num*50)/(num-1);
    if(spx > 16)
        spx = 16;
    for(int i = 0; i < num; i++)
    {
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        btn.frame = CGRectMake(x, y, 50, 50);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        btn.tag = i;
        [self addSubview:btn];
        
        [btn addTarget:self
                            action:@selector(channelBtnAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        x+=50;
        x+=spx;
        
        [_channelBtns addObject:btn];
    }
    
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
    
    SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(200, 100, 120, 120)];
    [contentView addSubview:btn];
    
}

@end
