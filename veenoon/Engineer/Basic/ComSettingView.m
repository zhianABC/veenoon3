//
//  ComSettingView.m
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "ComSettingView.h"
#import "JHSlideView.h"
#import "CheckButton.h"
#import "CenterCustomerPickerView.h"

@interface ComSettingView () <CenterCustomerPickerViewDelegate>
{
    UILabel *_secs;
    UIView *_chooseBg;
}
@end

@implementation ComSettingView
@synthesize _isAllowedClose;
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
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, frame.size.width, 1)];
        line.backgroundColor = RGB(1, 138, 182);
        [self addSubview:line];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, frame.size.width, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        titleL.text = @"串口号";
        
        _secs = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, frame.size.width-50, 20)];
        _secs.backgroundColor = [UIColor clearColor];
        [self addSubview:_secs];
        _secs.textAlignment = NSTextAlignmentRight;
        _secs.font = [UIFont systemFontOfSize:13];
        _secs.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
        _secs.text = @"Com 1";
        
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
        
        
        _chooseBg = [[UIView alloc] initWithFrame:CGRectMake(0, 101, frame.size.width, 220)];
        _chooseBg.backgroundColor = self.backgroundColor;
        
        CenterCustomerPickerView *levelSetting = [[CenterCustomerPickerView alloc]
                                          initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200) withGrayOrLight:@"light"];
        [levelSetting removeArray];
        
        levelSetting._pickerDataArray = @[@{@"values":@[@"Com 1", @"Com 2", @"Com 3"]}];
        
        
        levelSetting._selectColor = [UIColor orangeColor];
        levelSetting._rowNormalColor = [UIColor whiteColor];
        levelSetting.delegate_ = self;
        [_chooseBg addSubview:levelSetting];
        
        [levelSetting selectRow:0 inComponent:0];
        

        IMP_BLOCK_SELF(ComSettingView);
        levelSetting._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 219, frame.size.width, 1)];
        line.backgroundColor = RGB(1, 138, 182);
        [_chooseBg addSubview:line];
        
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(closeComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionUp;
        
        
        [self addGestureRecognizer:swip];
        
        self._isAllowedClose = YES;
        
    }
    return self;
}

- (void) closeComSetting{
    
    if(_isAllowedClose)
    {
    
    CGRect rc = self.frame;
    rc.origin.y = 0-rc.size.height;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.frame = rc;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    }
}

- (void) didPickerValue:(NSDictionary*)values{
    
    NSString *v = [values objectForKey:@0];
    _secs.text = v;
}

- (void) didScrollPickerValue:(NSString *)pickerValue {
     _secs.text = pickerValue;
    
    if([_chooseBg superview])
    {
        [_chooseBg removeFromSuperview];
    }
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

@end
