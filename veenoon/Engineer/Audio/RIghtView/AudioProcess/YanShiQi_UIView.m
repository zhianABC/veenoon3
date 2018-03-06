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

@interface YanShiQi_UIView() <UITextFieldDelegate>{
    
    UIButton *channelBtn;
    
    //UIView   *contentView;
    
    UITextField *haomiaoField;
    UITextField *miField;
    UITextField *yingchiFiedld;
}
//@property (nonatomic, strong) NSMutableArray *_channelBtns;

@end


@implementation YanShiQi_UIView
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

- (void) contentViewComps{
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"毫秒 (ms)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(700, 120, 120, 20);
    [contentView addSubview:addLabel];
    
    SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(670, 135, 120, 120)];
    [contentView addSubview:btn];
    
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
    
    UILabel *addLabel3 = [[UILabel alloc] init];
    addLabel3.text = @"英尺";
    addLabel3.font = [UIFont systemFontOfSize: 13];
    addLabel3.textColor = [UIColor whiteColor];
    addLabel3.frame = CGRectMake(CGRectGetMaxX(yingchiFiedld.frame)+10, btnY, 50, 30);
    [contentView addSubview:addLabel3];
}
-(void) fanxiangAction:(id) sender {
    
}
-(void) bianzuAction:(id) sender {
    
}
-(void) lineBtnAction:(id) sender {
    
}

-(void) muteBtnAction:(id) sender {
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //_curIndex = (int)textField.tag;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
@end


