//
//  PowerSettingView.m
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "PowerSettingView.h"
#import "JHSlideView.h"
#import "CheckButton.h"
#import "CenterCustomerPickerView.h"
#import "ComSettingView.h"
#import "APowerESet.h"

@interface PowerSettingView () <CenterCustomerPickerViewDelegate, UITextFieldDelegate, JHSlideViewDelegate>
{
    UILabel *_secs;
    
    UIScrollView *_sliders;
    
    CheckButton *_btnCheck;
    
    UIView *_chooseBg;
    
    CenterCustomerPickerView *levelSetting;
}


@end

@implementation PowerSettingView
@synthesize _objSet;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        self.backgroundColor = BLACK_COLOR;
        self.clipsToBounds = YES;
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 1)];
        line.backgroundColor = TITLE_LINE_COLOR;
        [self addSubview:line];
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 1)];
        line.backgroundColor = TITLE_LINE_COLOR;
        [self addSubview:line];
        
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, frame.size.width, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        titleL.text = @"开机通道切换时间";
        
        
        _secs = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, frame.size.width-50, 20)];
        _secs.backgroundColor = [UIColor clearColor];
        [self addSubview:_secs];
        _secs.textAlignment = NSTextAlignmentRight;
        _secs.font = [UIFont systemFontOfSize:13];
        _secs.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        _secs.text = @"1s";
        
        UIButton *btnSelectSecs = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSelectSecs.frame = CGRectMake(frame.size.width-110, 60, 110, 40);
        [self addSubview:btnSelectSecs];
        [btnSelectSecs addTarget:self
                          action:@selector(chooseSecs:)
                forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(_secs.frame)+5, 75, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [self addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        
        
        _sliders = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                            100,
                                                            frame.size.width,
                                                            frame.size.height-100)];
        [self addSubview:_sliders];
        
        
        
        _btnCheck = [[CheckButton alloc] initWithIcon:[UIImage imageNamed:@"checkbox_nor.png"]
                                                             down:[UIImage imageNamed:@"checkbox_sel.png"]
                                                            title:@""
                                                            frame:CGRectMake(4, 70-10, 160, 44)];
        [self addSubview:_btnCheck];
        
        [_btnCheck allowUnCheck:YES];
        [_btnCheck check];
        [self checkClicked:1];
        
        IMP_BLOCK_SELF(PowerSettingView);
        [_btnCheck setClickedCallbackBlock:^(int tagIndex, CheckButton *btn){
            
            [block_self checkClicked:tagIndex];
        }];
        
        
        _chooseBg = [[UIView alloc] initWithFrame:CGRectMake(0, 101, frame.size.width, 220)];
        _chooseBg.backgroundColor = self.backgroundColor;
        
        levelSetting = [[CenterCustomerPickerView alloc]
                                          initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200) ];
        [levelSetting removeArray];
        
        NSMutableArray *arr = [NSMutableArray array];
        for(int i = 1; i< 181; i++)
        {
            [arr addObject:[NSString stringWithFormat:@"%ds", i]];
        }
        
        levelSetting._pickerDataArray = @[@{@"values":arr}];
        levelSetting.delegate_ = self;
        
        levelSetting._selectColor = [UIColor orangeColor];
        levelSetting._rowNormalColor = [UIColor whiteColor];
        [_chooseBg addSubview:levelSetting];
        [levelSetting selectRow:0 inComponent:0];
        
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 219, frame.size.width, 1)];
        line.backgroundColor = RGB(1, 138, 182);
        [_chooseBg addSubview:line];
        
        
    }
    return self;
}
    
- (void) didPickerValue:(NSDictionary*)values{
    
    
}

- (void) chooseSecs:(UIButton*)sender{
    
    if([_chooseBg superview])
    {
        [_chooseBg removeFromSuperview];
    }
    else
    {
    
    [self addSubview:_chooseBg];
    
    
    }
    
}
- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    if([_chooseBg superview])
    {
        [_chooseBg removeFromSuperview];
    }
}

- (void) didChangedPickerValue:(NSDictionary*)value{
    
    
    NSDictionary *dic = [value objectForKey:@0];
    if(dic)
    {
        NSString *value = [dic objectForKey:@"value"];
        _secs.text = value;
        
        NSString *scs = [value stringByReplacingOccurrencesOfString:@"s" withString:@""];
        int cc = (int)[_objSet._lines count];
        
        for(int i = 0; i < cc; i++)
        {
            [_objSet setLabDelaySecs:[scs intValue]
                           withIndex:i];
        }
        
    }
    
}



- (void) checkClicked:(int)tagIndex{
    
    if(tagIndex == 0)
    {
        _sliders.userInteractionEnabled = YES;
        _sliders.alpha = 1.0;
    }
    else
    {
        _sliders.userInteractionEnabled = NO;
        _sliders.alpha = 0.5;
    }
}

- (void) show8Labs{
    
    [[_sliders subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int xx = 15;
    int yy = 10;
    
    NSArray *vals = _objSet._lines;
    
    int res = [_objSet checkIsSameSeconds];
    if(res)
    {
        _secs.text = [NSString stringWithFormat:@"%ds", res];
        
        [self checkClicked:1];
    }
    else
    {
        [self checkClicked:0];
    }
    
    for(int i = 0; i < 8; i++)
    {
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, 50, 50)];
        tL.backgroundColor = [UIColor clearColor];
        [_sliders addSubview:tL];
        tL.font = [UIFont boldSystemFontOfSize:14];
        tL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        tL.text = [NSString stringWithFormat:@"%d", i+1];
        
        JHSlideView *slider = [[JHSlideView alloc] initWithSliderBg:nil
                                                              frame:CGRectMake(xx+40,
                                                                               yy,
                                                                               230,
                                                                               50)];
        [_sliders addSubview:slider];
        slider.minValue = 1;
        slider.maxValue = 180;
        slider.delegate = self;
        slider.tag = i;
    
        NSMutableDictionary *dic = [vals objectAtIndex:i];
        int val = [[dic objectForKey:@"seconds"] intValue];
        
        [slider setScaleValue:val];
        
        yy+=50;
        
    }
    
    _sliders.contentSize = CGSizeMake(_sliders.frame.size.width, yy);
}

- (void) didSlideValueChanged:(int)value index:(int)index{
    
    [_objSet setLabDelaySecs:value withIndex:index];
}

- (void) show16Labs{
    
    [[_sliders subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int xx = 15;
    int yy = 10;
    
    NSArray *vals = _objSet._lines;
    
    int res = [_objSet checkIsSameSeconds];
    if(res)
    {
        _secs.text = [NSString stringWithFormat:@"%ds", res];
        
        [self checkClicked:1];
    }
    else
    {
        [self checkClicked:0];
    }
    
    for(int i = 0; i < 16; i++)
    {
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(xx, yy, 50, 50)];
        tL.backgroundColor = [UIColor clearColor];
        [_sliders addSubview:tL];
        tL.font = [UIFont boldSystemFontOfSize:14];
        tL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        tL.text = [NSString stringWithFormat:@"%d", i+1];
        
        JHSlideView *slider = [[JHSlideView alloc] initWithSliderBg:nil
                                                              frame:CGRectMake(xx+40,
                                                                               yy,
                                                                               230,
                                                                               50)];
        [_sliders addSubview:slider];
        slider.minValue = 1;
        slider.maxValue = 180;
        slider.tag = i;
        slider.delegate = self;
        
        NSMutableDictionary *dic = [vals objectAtIndex:i];
        int val = [[dic objectForKey:@"seconds"] intValue];
        
        [slider setScaleValue:val];
        
        
        yy+=50;
        
    }
    
    _sliders.contentSize = CGSizeMake(_sliders.frame.size.width, yy);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //_curIndex = (int)textField.tag;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _objSet._ipaddress = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
