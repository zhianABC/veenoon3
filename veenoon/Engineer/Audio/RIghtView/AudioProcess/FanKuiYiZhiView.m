//
//  FanKuiYiZhiView.m
//  veenoon
//
//  Created by 安志良 on 2018/5/21.
//  Copyright © 2018年 jack. All rights reserved.
//

//
//  ZiDongHunYin_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "FanKuiYiZhiView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface FanKuiYiZhiView() <SlideButtonDelegate> {
    UIButton *channelBtn;
    
    UIButton *fankuiyizhiBtn;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end

@implementation FanKuiYiZhiView
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

- (void) contentViewComps {
    
    fankuiyizhiBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    fankuiyizhiBtn.frame = CGRectMake(contentView.frame.size.width/2 - 25, contentView.frame.size.height/2 - 15, 50, 30);
    fankuiyizhiBtn.layer.cornerRadius = 5;
    fankuiyizhiBtn.layer.borderWidth = 2;
    fankuiyizhiBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    fankuiyizhiBtn.clipsToBounds = YES;
    [fankuiyizhiBtn setTitle:@"启用" forState:UIControlStateNormal];
    fankuiyizhiBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [fankuiyizhiBtn addTarget:self
                   action:@selector(zhitongBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:fankuiyizhiBtn];
}
- (void) zhitongBtnAction:(id) sender {
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy isFanKuiYiZhiStarted];
    
    [_curProxy controlFanKuiYiZhi:!isMute];
    
    [self updateMuteButtonState];
}

- (void) updateMuteButtonState{
    
    BOOL isFanKuiYiZhi = [_curProxy isFanKuiYiZhiStarted];
    
    if(isFanKuiYiZhi)
    {
        [fankuiyizhiBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [fankuiyizhiBtn changeNormalColor:RGB(75, 163, 202)];
    }
}

@end
