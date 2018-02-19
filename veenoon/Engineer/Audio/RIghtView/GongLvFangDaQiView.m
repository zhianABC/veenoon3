//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "GongLvFangDaQiView.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "ComSettingView.h"

@interface GongLvFangDaQiView () <CustomPickerViewDelegate> {
    
    ComSettingView *_com;
    UIButton *btnSelectSecs;
    int gonglvNumber;
    
    CustomPickerView *_picker;
    
    UIImageView *icon;
    UILabel *line;
    
    NSMutableArray *_btns;
}
@end

@implementation GongLvFangDaQiView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(0, 89, 118);
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        int startX = 20;
        int top = 60;
        
        gonglvNumber = 4;
        
        _btns = [[NSMutableArray alloc] init];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX, top, 60, 40)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        titleL.text = @"输入源";
        
        icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(frame.size.width-15, top+15, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [self addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        
        btnSelectSecs = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSelectSecs setTitle:@"1+2" forState:UIControlStateNormal];
        btnSelectSecs.frame = CGRectMake(frame.size.width-80, top, 80, 40);
        [self addSubview:btnSelectSecs];
        btnSelectSecs.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [btnSelectSecs addTarget:self
                          action:@selector(chooseSecs:)
                forControlEvents:UIControlEventTouchUpInside];
        
        _picker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSelectSecs.frame)+5, self.frame.size.width, 160) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"1+2", @"3"]}];
        
        [self addSubview:_picker];
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        _picker.hidden = YES;
        
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSelectSecs.frame)+10,
                                                                  self.frame.size.width, 1)];
        line.backgroundColor =  M_GREEN_LINE;
        [self addSubview:line];
        
        int colNumber = 4;
        int space = 5;
        int cellWidth = 115/2;
        int cellHeight = 115/2;
        int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
        int top2 = self.frame.size.height - 120;
        UIColor *rectColor = RGB(0, 146, 174);
        
        for (int index = 0; index < gonglvNumber; index++) {
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top2;
            
            UIButton *scenarioBtn = [UIButton buttonWithColor:rectColor selColor:nil];
            scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            scenarioBtn.clipsToBounds = YES;
            scenarioBtn.layer.cornerRadius = 5;
            scenarioBtn.tag = index;
            [self addSubview:scenarioBtn];
            int titleInt = index + 1;
            NSString *string = [NSString stringWithFormat:@"%d",titleInt];
            [scenarioBtn setTitle:string forState:UIControlStateNormal];
            [scenarioBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [_btns addObject:scenarioBtn];
        }
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
    }
    
    return self;
}

- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    [btnSelectSecs setTitle:pickerValue forState:UIControlStateNormal];
    
    line.frame = CGRectMake(0, CGRectGetMaxY(btnSelectSecs.frame)+10,
                            self.frame.size.width, 1);
    
    _picker.hidden = YES;
}
- (void) buttonAction:(UIButton*)btn{
    
    [self chooseChannelAtTagIndex:(int)btn.tag];
}

- (void) chooseChannelAtTagIndex:(int)index{
    
    for(UIButton *btn in _btns)
    {
        if(btn.tag == index)
        {
            [btn setTitleColor:YELLOW_COLOR
                      forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
        }
    }
}

- (void) chooseSecs:(id)sender {
    
    line.frame = CGRectMake(0, CGRectGetMaxY(_picker.frame)+10,
                            self.frame.size.width, 1);
    _picker.hidden = NO;
}

- (void) switchComSetting{
    
    if([_com superview])
        return;
    
    CGRect rc = _com.frame;
    rc.origin.y = 0-rc.size.height;
    
    _com.frame = rc;
    [self addSubview:_com];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _com.frame = self.bounds;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

@end


