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
    
    UIView   *contentView;
    
    UIButton *aecButton;
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;

@end


@implementation HuiShengXiaoChu_UIView
//@synthesize _channelBtns;
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
//        [self addSubview:contentView];
//        contentView.layer.cornerRadius = 5;
//        contentView.clipsToBounds = YES;
//        contentView.backgroundColor = RGB(0, 89, 118);
//
       // [self layoutChannelBtns:16];
        
        [self createContentViewBtns];
    }
    
    return self;
}

//- (void) layoutChannelBtns:(int)num{
//    
//    self._channelBtns = [NSMutableArray array];
//    
//    float x = 0;
//    int y = CGRectGetHeight(self.frame)-60;
//    
//    float spx = (CGRectGetWidth(self.frame) - num*50.0)/(num-1);
//    if(spx > 10)
//        spx = 10;
//    for(int i = 0; i < num; i++)
//    {
//        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
//        btn.frame = CGRectMake(x, y, 50, 50);
//        btn.clipsToBounds = YES;
//        btn.layer.cornerRadius = 5;
//        btn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
//        btn.tag = i;
//        [self addSubview:btn];
//        
//        if(i == 0)
//        {
//            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
//            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
//        }
//        else
//        {
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
//        }
//        
//        [btn addTarget:self
//                action:@selector(channelBtnAction:)
//      forControlEvents:UIControlEventTouchUpInside];
//        
//        x+=50;
//        x+=spx;
//        
//        [_channelBtns addObject:btn];
//    }
//    
//}

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

