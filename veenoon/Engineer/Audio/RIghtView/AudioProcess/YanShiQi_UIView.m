//
//  YaXianQi_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "YanShiQi_UIView.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface YanShiQi_UIView() <UITextFieldDelegate, SlideButtonDelegate, VAProcessorProxysDelegate>{
    
    UIButton *channelBtn;
    
    //UIView   *contentView;
    
    UITextField *haomiaoField;
    UITextField *miField;
    UITextField *yingchiFiedld;
    
    SlideButton *xielvSlider3;
    
    UILabel *labelL1;
    
    int maxDuration;
    int minDuration;
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;
@property (nonatomic, strong) VAProcessorProxys *_curProxy;
@end


@implementation YanShiQi_UIView
//@synthesize _channelBtns;
@synthesize _curProxy;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys {

    if(self = [super initWithFrame:frame]) {
        
        self._proxys = proxys;
        
        if ([self._proxys count]) {
            self._curProxy = [self._proxys objectAtIndex:0];
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
        contentView.frame = CGRectMake(0, y, frame.size.width, 340);
        
        minDuration = 0;
        maxDuration = 1000;
        
        [self contentViewComps];
        
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
    
    [self updateProxyCommandValIsLoaded];
}

- (void) contentViewComps {
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"毫秒 (ms)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(700, 90, 120, 20);
    [contentView addSubview:addLabel];
    
    xielvSlider3 = [[SlideButton alloc] initWithFrame:CGRectMake(670, 105, 120, 120)];
    xielvSlider3._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    xielvSlider3._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [xielvSlider3 enableValueSet:YES];
    xielvSlider3.delegate = self;
    xielvSlider3.tag = 3;
    [contentView addSubview:xielvSlider3];
    
    labelL1 = [[UILabel alloc] initWithFrame:CGRectMake(670, 105+120, 120, 20)];
    labelL1.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelL1];
    labelL1.font = [UIFont systemFontOfSize:13];
    labelL1.textColor = YELLOW_COLOR;
}

- (void) createContentViewBtns {
    int btnStartX = 100;
    int btnY = 150;
    
    haomiaoField = [[UITextField alloc] initWithFrame:CGRectMake(btnStartX,
                                                                   btnY,
                                                                   100,
                                                                   30)];
    haomiaoField.delegate = self;
    haomiaoField.returnKeyType = UIReturnKeyDone;
    haomiaoField.backgroundColor = RGB(75, 163, 202);
    haomiaoField.textColor = [UIColor whiteColor];
    haomiaoField.borderStyle = UITextBorderStyleRoundedRect;
    haomiaoField.textAlignment = NSTextAlignmentLeft;
    haomiaoField.font = [UIFont systemFontOfSize:13];
    haomiaoField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentView addSubview:haomiaoField];
    haomiaoField.tag = 1;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"毫秒";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(CGRectGetMaxX(haomiaoField.frame)+10, btnY, 50, 30);
    [contentView addSubview:addLabel];
    
    
    miField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addLabel.frame)+10, btnY, 100, 30)];
    miField.delegate = self;
    miField.returnKeyType = UIReturnKeyDone;
    miField.backgroundColor = RGB(75, 163, 202);
    miField.textColor = [UIColor whiteColor];
    miField.borderStyle = UITextBorderStyleRoundedRect;
    miField.textAlignment = NSTextAlignmentLeft;
    miField.font = [UIFont systemFontOfSize:13];
    miField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentView addSubview:miField];
    miField.tag = 2;
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"米";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(CGRectGetMaxX(miField.frame)+10, btnY, 50, 30);
    [contentView addSubview:addLabel2];
    
    
    yingchiFiedld = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addLabel2.frame)+10, btnY, 100, 30)];
    yingchiFiedld.delegate = self;
    yingchiFiedld.returnKeyType = UIReturnKeyDone;
    yingchiFiedld.backgroundColor = RGB(75, 163, 202);
    yingchiFiedld.textColor = [UIColor whiteColor];
    yingchiFiedld.borderStyle = UITextBorderStyleRoundedRect;
    yingchiFiedld.textAlignment = NSTextAlignmentLeft;
    yingchiFiedld.font = [UIFont systemFontOfSize:13];
    yingchiFiedld.clearButtonMode = UITextFieldViewModeWhileEditing;
    [contentView addSubview:yingchiFiedld];
    yingchiFiedld.tag = 3;
    
    UILabel *addLabel3 = [[UILabel alloc] init];
    addLabel3.text = @"英尺";
    addLabel3.font = [UIFont systemFontOfSize: 13];
    addLabel3.textColor = [UIColor whiteColor];
    addLabel3.frame = CGRectMake(CGRectGetMaxX(yingchiFiedld.frame)+10, btnY, 50, 30);
    [contentView addSubview:addLabel3];
}

-(void) updateYanshiqi {
    
    NSString *zengyiDB = [_curProxy getYanshiqiSlide];
    float value = [zengyiDB floatValue];
    float max = (maxDuration - minDuration);
    if(max)
    {
        float f = (value - minDuration)/max;
        f = fabsf(f);
        [xielvSlider3 setCircleValue:f];
    }
    if (zengyiDB) {
        labelL1.text = [zengyiDB stringByAppendingString:@" ms"];
    }
    
    float mi = value / 1000 * 340;
    NSString *miString = [NSString stringWithFormat:@"%.3f", mi];
    miField.text = miString;
    
    float yingchi = mi * 3.280797;
    NSString *yingchiString = [NSString stringWithFormat:@"%.3f", yingchi];
    yingchiFiedld.text = yingchiString;
    
    NSString *haomiaoStr = [NSString stringWithFormat:@"%.2f", value];
    haomiaoField.text = haomiaoStr;
}

- (void) updateProxyCommandValIsLoaded
{
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
    
}

- (void) didLoadedProxyCommand{
    
    _curProxy.delegate = nil;
    
    NSDictionary *result = [_curProxy getSetDelayOptions];
    
    maxDuration = [[result objectForKey:@"max"] intValue];
    minDuration = [[result objectForKey:@"min"] intValue];
    
    [self updateYanshiqi];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    int index = (int) textField.tag;
    if (index == 1) {
        NSString *haomiaoStr = textField.text;
        [_curProxy controlYanshiqiSlide:haomiaoStr];
        haomiaoField.text = haomiaoStr;
        
        float haomiao = roundf([textField.text floatValue]);
        
        float mi = haomiao/1000*340;
        NSString *miString = [NSString stringWithFormat:@"%.3f", mi];
        miField.text = miString;
        
        float yingchi = mi * 3.280797;
        NSString *yingchiString = [NSString stringWithFormat:@"%.3f", yingchi];
        yingchiFiedld.text = yingchiString;
        
    } else if (index == 2) {
        NSString *miString = textField.text;
        float mi = [miString floatValue];
        
        float haomiao = roundf(mi/340*1000);
        NSString *haomiaoString = [NSString stringWithFormat:@"%.2f", haomiao];
        [_curProxy controlYanshiqiSlide:haomiaoString];
        haomiaoField.text = haomiaoString;
        
        float yingchi = mi * 3.280797;
        NSString *yingchiString = [NSString stringWithFormat:@"%.3f", yingchi];
        yingchiFiedld.text = yingchiString;
    } else if (index == 3) {
        float yingchi = [textField.text floatValue];
        
        float mi = yingchi/3.280797;
        NSString *miString = [NSString stringWithFormat:@"%.3f", mi];
        miField.text = miString;
        
        float haomiao = roundf(mi/340*1000);
        NSString *haomiaoString = [NSString stringWithFormat:@"%.2f", haomiao];
        [_curProxy controlYanshiqiSlide:haomiaoString];
        haomiaoField.text = haomiaoString;
        [_curProxy controlYanshiqiSlide:haomiaoString];
        
    }
    
    NSString *zengyiDB = [_curProxy getYanshiqiSlide];
    float value = [zengyiDB floatValue];
    float max = (maxDuration - minDuration);
    if(max)
    {
        float f = (value - minDuration)/max;
        f = fabsf(f);
        [xielvSlider3 setCircleValue:f];
    }
    if (zengyiDB) {
        labelL1.text = [zengyiDB stringByAppendingString:@" ms"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float k = roundf((value *(maxDuration-minDuration)) + minDuration);
    NSString *valueStr= [NSString stringWithFormat:@"%0.2f ms", k];
    
    labelL1.text = valueStr;
    
    [_curProxy controlYanshiqiSlide:[NSString stringWithFormat:@"%0.2f", k]];
    
    [self updateYanshiqi];
}

@end


