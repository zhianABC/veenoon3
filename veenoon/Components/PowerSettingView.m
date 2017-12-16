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
#import "CustomPickerView.h"
#import "ComSettingView.h"

@interface PowerSettingView ()
{
    UILabel *_secs;
    
    UIScrollView *_sliders;
    
    UIButton *_btnSave;
    CheckButton *_btnCheck;
    
    UIView *_chooseBg;
    
    ComSettingView *_com;
}
@end

@implementation PowerSettingView

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
        
        self.backgroundColor = RGB(0, 89, 118);
        self.clipsToBounds = YES;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(frame.size.width-90, 20, 70, 40);
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [self addSubview:_btnSave];
        [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSave.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 1)];
        line.backgroundColor = RGB(1, 138, 182);
        [self addSubview:line];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, frame.size.width, 20)];
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
        
        CustomPickerView *levelSetting = [[CustomPickerView alloc]
                                          initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200) withGrayOrLight:@"gray"];
        
        
        NSMutableArray *arr = [NSMutableArray array];
        for(int i = 1; i< 181; i++)
        {
            [arr addObject:[NSString stringWithFormat:@"%ds", i]];
        }
        
        levelSetting._pickerDataArray = @[@{@"values":arr}];
        
        
        levelSetting._selectColor = [UIColor orangeColor];
        levelSetting._rowNormalColor = [UIColor whiteColor];
        [_chooseBg addSubview:levelSetting];
        
        [levelSetting selectRow:0 inComponent:0];
        

        levelSetting._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 219, frame.size.width, 1)];
        line.backgroundColor = RGB(1, 138, 182);
        [_chooseBg addSubview:line];
        
        
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

- (void) didPickerValue:(NSDictionary*)values{
    
    NSString *v = [values objectForKey:@0];
    _secs.text = v;
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
        [slider setScaleValue:1];
        
        yy+=50;
        
    }
    
    _sliders.contentSize = CGSizeMake(_sliders.frame.size.width, yy);
}

- (void) show16Labs{
    
    [[_sliders subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int xx = 15;
    int yy = 10;
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
        [slider setScaleValue:1];
        
        yy+=50;
        
    }
    
    _sliders.contentSize = CGSizeMake(_sliders.frame.size.width, yy);
}

@end
