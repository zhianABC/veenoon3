//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "HuiShengXiaoChu_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"

@interface HuiShengXiaoChu_UIView() {
    
    UIButton *channelBtn;
    
    
    UIButton *aecButton;
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;

@end


@implementation HuiShengXiaoChu_UIView

@synthesize delegate_;
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
        contentView.frame  = CGRectMake(0, y, frame.size.width, 340);
        
        [self createContentViewBtns];
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

- (void) createContentViewBtns {
    UIImage *roomImage = [UIImage imageNamed:@"huishengxiaochu.png"];
    UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
    roomeImageView.userInteractionEnabled=YES;
    roomeImageView.contentMode = UIViewContentModeScaleAspectFit;
    roomeImageView.frame = CGRectMake(100, 25, contentView.frame.size.width-200, contentView.frame.size.height-50);
    
    [contentView addSubview:roomeImageView];UIButton *zhitongBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    zhitongBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height - 40, 50, 30);
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
    
    aecButton = [UIButton buttonWithColor:nil selColor:nil];
    aecButton.frame = CGRectMake(350, 150, 50, 75);
    aecButton.clipsToBounds = YES;
    aecButton.layer.cornerRadius = 5;
    [aecButton addTarget:self
                   action:@selector(aceBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:aecButton];
}
- (void) aceBtnAction:(id) sender {
    if(delegate_ && [delegate_ respondsToSelector:@selector(didAecButtonAction)]) {
        [delegate_ didAecButtonAction];
    }
}
- (void) zhitongBtnAction:(id) sender {
    
}

@end

