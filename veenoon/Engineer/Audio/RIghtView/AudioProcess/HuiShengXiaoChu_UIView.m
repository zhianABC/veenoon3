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
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface HuiShengXiaoChu_UIView() {
    
    UIButton *channelBtn;
    
    UIButton *qidongBtn;
    
    UIButton *aecButton;
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end


@implementation HuiShengXiaoChu_UIView
@synthesize delegate_;
@synthesize _curProxy;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys;
{
    self._proxys = proxys;
    
    if(self = [super initWithFrame:frame])
    {
        if (self._curProxy == nil) {
            if (self._proxys) {
                self._curProxy = [self._proxys objectAtIndex:0];
            }
        }
        
        channelBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 70, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [channelBtn setTitle:_curProxy._rgsProxyObj.name forState:UIControlStateNormal];
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
    
    int idx = (int)sender.tag;
    self._curProxy = [self._proxys objectAtIndex:idx];
    
    NSString *name = _curProxy._rgsProxyObj.name;
    [channelBtn setTitle:name forState:UIControlStateNormal];
    
    [self updateMuteButtonState];
    
}

- (void) updateMuteButtonState{
    
    BOOL isZiDongHunYin = [_curProxy isHuiShengXiaoChuStarted];
    
    if(isZiDongHunYin)
    {
        [qidongBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [qidongBtn changeNormalColor:RGB(75, 163, 202)];
    }
}


- (void) createContentViewBtns {
    UIImage *roomImage = [UIImage imageNamed:@"huishengxiaochu.png"];
    UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
    roomeImageView.userInteractionEnabled=YES;
    roomeImageView.contentMode = UIViewContentModeScaleAspectFill;
    roomeImageView.frame = CGRectMake(100, 25, contentView.frame.size.width-200, contentView.frame.size.height-50);
    
    [contentView addSubview:roomeImageView];
    
    qidongBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    qidongBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height - 40, 50, 30);
    qidongBtn.layer.cornerRadius = 5;
    qidongBtn.layer.borderWidth = 2;
    qidongBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    qidongBtn.clipsToBounds = YES;
    [qidongBtn setTitle:@"启用" forState:UIControlStateNormal];
    qidongBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [qidongBtn addTarget:self
                   action:@selector(zhitongBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:qidongBtn];
    
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
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy isHuiShengXiaoChuStarted];
    
    [_curProxy controlHuiShengXiaoChu:!isMute];
    
    [self updateMuteButtonState];
}

@end

