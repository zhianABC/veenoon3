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

@interface FanKuiYiZhiView() <SlideButtonDelegate, VAProcessorProxysDelegate> {
    UIButton *channelBtn;
    
    UIButton *fankuiyizhiBtn;
}
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end

@implementation FanKuiYiZhiView
@synthesize _curProxy;

- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys;
{
    
    if(self = [super initWithFrame:frame])
    {
        self._proxys = proxys;
        
        if ([self._proxys count]) {
            _curProxy = [self._proxys objectAtIndex:0];
        }
        
        channelBtn = [UIButton buttonWithColor:nil selColor:nil];
        channelBtn.frame = CGRectMake(0, 50, 300, 36);
        channelBtn.clipsToBounds = YES;
        channelBtn.layer.cornerRadius = 5;
        channelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        channelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSString *currentName = _curProxy._rgsProxyObj.name;
        [channelBtn setTitle:currentName forState:UIControlStateNormal];
        [channelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:channelBtn];
        
        int y = CGRectGetMaxY(channelBtn.frame)+10;
        contentView.frame  = CGRectMake(0, y, frame.size.width, 340);
        
        [self contentViewComps];
    }
    
    return self;
}

-(void) updateFankuiyizhi {
    BOOL isFanKuiYiZhi = [_curProxy isFanKuiYiZhiStarted];
    
    if(isFanKuiYiZhi)
    {
        [fankuiyizhiBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [fankuiyizhiBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
}

- (void) channelBtnAction:(UIButton*)sender{
    
    for(UIButton * btn in _channelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
        }
    }
    
    int idx = (int)sender.tag;
    self._curProxy = [self._proxys objectAtIndex:idx];
    
    NSString *name = _curProxy._rgsProxyObj.name;
    [channelBtn setTitle:name forState:UIControlStateNormal];
    
    [self updateProxyCommandValIsLoaded];
}

- (void) updateProxyCommandValIsLoaded {
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
}

- (void) didLoadedProxyCommand {
    _curProxy.delegate = nil;
    
    [self updateFankuiyizhi];
}

- (void) contentViewComps {
    
    fankuiyizhiBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:THEME_RED_COLOR];
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
    
    isMute = !isMute;
    
    [_curProxy controlFanKuiYiZhi:isMute];
    
    [self updateFankuiyizhi];
}


- (void) onCopyData:(id)sender{
    
    [_curProxy copyFeedbackSet];
}
- (void) onPasteData:(id)sender{
    
    [_curProxy pasteFeedbackSet];
    [self updateFankuiyizhi];
}
- (void) onClearData:(id)sender{
    
    [_curProxy clearFeedbackSet];
    [self updateFankuiyizhi];
}


@end
