//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "MixVoiceSettingsView.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "ComSettingView.h"

@interface MixVoiceSettingsView () <CustomPickerViewDelegate>
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    
    UIView *_yuyinjiliView;
    UIView *_biaozhunfayanView;
    UIView *_yinpinchuliView;
    UIView *_shexiangzhuizongView;
    
    UIButton *_shedingzhuxiBtn;
    UIButton *_fayanrenshuBtn;
    UIButton *_shexiangxieyiBtn;
    CustomPickerView *levelSetting;
    
    int shedingzhuxiNumber;
    int fayanrenshuNumber;
    
    ComSettingView *_com;
}
@end

@implementation MixVoiceSettingsView

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
        self.backgroundColor = RGB(0, 89, 118);
        
        shedingzhuxiNumber = 12;
        fayanrenshuNumber = 5;
        
        int bw = 120;
        int x = (frame.size.width - bw)/2;
        int top = (frame.size.height/2 - 40*4 - 5*3)/2;
        btn1 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn1.frame = CGRectMake(x, top, bw, 40);
        btn1.clipsToBounds = YES;
        btn1.layer.cornerRadius = 5;
        [self addSubview:btn1];
        
        [btn1 setTitle:@"语音激励" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(yuyinjiliAction:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn2 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn2.frame = CGRectMake(x, top, bw, 40);
        btn2.clipsToBounds = YES;
        btn2.layer.cornerRadius = 5;
        [self addSubview:btn2];
        
        [btn2 setTitle:@"标准发言" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(biaozhunfayanAction:) forControlEvents:UIControlEventTouchUpInside];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn3 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn3.frame = CGRectMake(x, top, bw, 40);
        btn3.clipsToBounds = YES;
        btn3.layer.cornerRadius = 5;
        [self addSubview:btn3];
        
        [btn3 setTitle:@"音频处理" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(yinpinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
        btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn4 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn4.frame = CGRectMake(x, top, bw, 40);
        btn4.clipsToBounds = YES;
        btn4.layer.cornerRadius = 5;
        [self addSubview:btn4];
        
        [btn4 setTitle:@"摄像追踪" forState:UIControlStateNormal];
        [btn4 addTarget:self action:@selector(shexiangzhuizongAction:) forControlEvents:UIControlEventTouchUpInside];
        btn4.titleLabel.font = [UIFont systemFontOfSize:15];

        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2,
                                                                  self.frame.size.width, 1)];
        line.backgroundColor =  M_GREEN_LINE;
        [self addSubview:line];
        
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
    }
    
    return self;
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
- (void) yuyinjiliAction:(id)sender{
    [btn1 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (_biaozhunfayanView) {
        [_biaozhunfayanView removeFromSuperview];
    }
    if (_shexiangzhuizongView) {
        [_shexiangzhuizongView removeFromSuperview];
    }
    [self createYuYinJiLiView];
}
- (void) biaozhunfayanAction:(id)sender{
    [btn2 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (_yuyinjiliView) {
        [_yuyinjiliView removeFromSuperview];
    }
    if (_shexiangzhuizongView) {
        [_shexiangzhuizongView removeFromSuperview];
    }
    
    [self createBiaoZhunFaYanView];
}
- (void) yinpinchuliAction:(id)sender{
    [btn3 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void) shexiangzhuizongAction:(id)sender{
    [btn4 setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (_biaozhunfayanView) {
        [_biaozhunfayanView removeFromSuperview];
    }
    if (_yuyinjiliView) {
        [_yuyinjiliView removeFromSuperview];
    }
    [self createShexiangzhuizongView];
}

- (void) createShexiangzhuizongView {
    _shexiangzhuizongView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+1, self.frame.size.width, self.frame.size.height/2-1)];
    
    [self addSubview:_shexiangzhuizongView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, _shexiangzhuizongView.frame.size.width, 20)];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"摄像机协议";
    titleL.textColor = [UIColor whiteColor];
    [_shexiangzhuizongView addSubview:titleL];
    
    int x = 70;
    _shexiangxieyiBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _shexiangxieyiBtn.frame = CGRectMake(x, CGRectGetMaxY(titleL.frame) + 10, self.frame.size.width-2*x, 25);
    _shexiangxieyiBtn.clipsToBounds = YES;
    _shexiangxieyiBtn.layer.cornerRadius = 5;
    [_shexiangzhuizongView addSubview:_shexiangxieyiBtn];
    [_shexiangxieyiBtn addTarget:self action:@selector(shexiangxieyiAction:) forControlEvents:UIControlEventTouchUpInside];
    _shexiangxieyiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    levelSetting = [[CustomPickerView alloc]
                                      initWithFrame:CGRectMake(x, 160, self.frame.size.width-2*x, 120) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"VISCA"];
    [arr addObject:@"PELCO_D"];
    [arr addObject:@"PELCO_P"];
    [arr addObject:@"VISCA"];
    
    
    levelSetting._pickerDataArray = @[@{@"values":arr}];
    levelSetting.delegate_ = self;
    
    levelSetting._selectColor = [UIColor orangeColor];
    levelSetting._rowNormalColor = [UIColor whiteColor];
    [_shexiangzhuizongView addSubview:levelSetting];
    levelSetting.hidden = YES;
}
-(void) shexiangxieyiAction:(id)sender {
    if (levelSetting.hidden) {
        levelSetting.hidden = NO;
    } else {
        levelSetting.hidden=YES;
    }
}
- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    [_shexiangxieyiBtn setTitle:pickerValue forState:UIControlStateNormal];
    
    levelSetting.hidden=YES;
}

- (void) createYuYinJiLiView {
    if (_biaozhunfayanView) {
        [_biaozhunfayanView removeFromSuperview];
    }
    if (_yinpinchuliView) {
        [_yinpinchuliView removeFromSuperview];
    }
    if (_shexiangzhuizongView) {
        [_shexiangzhuizongView removeFromSuperview];
    }
    _yuyinjiliView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+1, self.frame.size.width, self.frame.size.height/2-1)];
    
    [self addSubview:_yuyinjiliView];
    
    int bw = 120;
    int top = 40;
    int gap = 5;
    int x = self.frame.size.width/2 - gap/2 - bw;
    _shedingzhuxiBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _shedingzhuxiBtn.frame = CGRectMake(x, top, bw, 25);
    _shedingzhuxiBtn.clipsToBounds = YES;
    _shedingzhuxiBtn.layer.cornerRadius = 5;
    [_yuyinjiliView addSubview:_shedingzhuxiBtn];
    [_shedingzhuxiBtn setTitle:@"设定主席" forState:UIControlStateNormal];
    [_shedingzhuxiBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    _shedingzhuxiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    x = self.frame.size.width/2 + gap/2;
    _fayanrenshuBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _fayanrenshuBtn.frame = CGRectMake(x, top, bw, 25);
    _fayanrenshuBtn.clipsToBounds = YES;
    _fayanrenshuBtn.layer.cornerRadius = 5;
    [_yuyinjiliView addSubview:_fayanrenshuBtn];
    [_fayanrenshuBtn setTitle:@"发言人数" forState:UIControlStateNormal];
    [_fayanrenshuBtn addTarget:self action:@selector(fayanrenshuAction:) forControlEvents:UIControlEventTouchUpInside];
    _fayanrenshuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}

- (void) createBiaoZhunFaYanView {
    _biaozhunfayanView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+1, self.frame.size.width, self.frame.size.height/2-1)];
    
    [self addSubview:_biaozhunfayanView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, _biaozhunfayanView.frame.size.height/2 -10, _biaozhunfayanView.frame.size.width, 20)];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"所有话筒均可打开或关闭";
    titleL.textColor = [UIColor whiteColor];
    [_biaozhunfayanView addSubview:titleL];
}

- (void) shedingzhuxiAction:(id)sender {
    [_shedingzhuxiBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    _fayanrenshuBtn.hidden=YES;
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    int top = _shedingzhuxiBtn.frame.origin.y + 45;
    for (int index = 0; index < shedingzhuxiNumber; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        [_yuyinjiliView addSubview:scenarioBtn];
        int titleInt = index + 1;
        NSString *string = [NSString stringWithFormat:@"%d",titleInt];
        [scenarioBtn setTitle:string forState:UIControlStateNormal];
        [scenarioBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
        scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}
- (void) fayanrenshuAction:(id)sender{
    [_fayanrenshuBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
    _shedingzhuxiBtn.hidden=YES;
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    int top = _shedingzhuxiBtn.frame.origin.y + 45;
    for (int index = 0; index < fayanrenshuNumber; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        [_yuyinjiliView addSubview:scenarioBtn];
        int titleInt = index + 1;
        NSString *string = [NSString stringWithFormat:@"%d",titleInt];
        [scenarioBtn setTitle:string forState:UIControlStateNormal];
        [scenarioBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
        scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}
@end
