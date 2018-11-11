//
//  AutoRunCell.m
//  veenoon
//
//  Created by chen jack on 2018/8/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AutoRunCell.h"
#import "UIButton+Color.h"
#import "RegulusSDK.h"
#import "UILabel+ContentSize.h"

@interface AutoRunCell ()
{
    UILabel* dateL;
    UILabel* titleL;
    UILabel* weeksL;
    
    UIImageView *_iconDelete;
}
@property (nonatomic, strong) id _sch;

@end

@implementation AutoRunCell
@synthesize button;
@synthesize _sch;
@synthesize delegate;

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
        button = [UIButton buttonWithColor:RGB(0x52, 0x4e, 0x4b)
                                         selColor:nil];
        button.frame = self.bounds;
        [self addSubview:button];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        
        dateL = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 20)];
        dateL.backgroundColor = [UIColor clearColor];
        [self addSubview:dateL];
        dateL.font = [UIFont systemFontOfSize:16];
        dateL.textColor  = [UIColor whiteColor];
        dateL.textAlignment = NSTextAlignmentCenter;
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        weeksL = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 20)];
        weeksL.backgroundColor = [UIColor clearColor];
        [self addSubview:weeksL];
        weeksL.font = [UIFont systemFontOfSize:14];
        weeksL.textColor  = [UIColor whiteColor];
        weeksL.textAlignment = NSTextAlignmentCenter;
        
        
        dateL.frame = CGRectMake(0, 20, self.frame.size.width, 20);
        titleL.frame = CGRectMake(0, 40, self.frame.size.width, 20);
        weeksL.frame = CGRectMake(10, 70, self.frame.size.width-20, 20);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [self addSubview:btn];
        [btn addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        _iconDelete = [[UIImageView alloc]
                       initWithImage:[UIImage imageNamed:@"red_del_icon.png"]];
        [self addSubview:_iconDelete];
        
        _iconDelete.center = CGPointMake(20, 20);
        _iconDelete.hidden = YES;
        
    }
    
    return self;
    
}

- (void) setEditMode:(BOOL)isEdit{

    if(isEdit)
    {
        _iconDelete.hidden = NO;
    }
    else
    {
        _iconDelete.hidden = YES;
    }
    
}

- (void) buttonAction:(UIButton *)sender{
    
    if(_iconDelete.hidden)
    {
        if(delegate && [delegate respondsToSelector:@selector(tappedAutoRunCell:)])
        {
            [delegate tappedAutoRunCell:_sch];
        }
    }
    else
    {
        if(delegate && [delegate respondsToSelector:@selector(deleteAutoRunCell:view:)])
        {
            [delegate deleteAutoRunCell:_sch view:self];
        }
    }
}

- (NSString *)weekIdxFromSum:(NSString*)sum{
    
    
    if([sum isEqualToString:@"Mon"])
    {
        return @"一";
    }
    else if([sum isEqualToString:@"Tues"])
    {
        return @"二";
    }
    else if([sum isEqualToString:@"Wed"])
    {
        return @"三";
    }
    else if([sum isEqualToString:@"Thurs"])
    {
        return @"四";
    }
    else if([sum isEqualToString:@"Fri"])
    {
        return @"五";
    }
    else if([sum isEqualToString:@"Sat"])
    {
        return @"六";
    }
    else if([sum isEqualToString:@"Sun"])
    {
        return @"日";
    }
    
    return @"";
}

- (void) showRgsSchedule:(RgsSchedulerObj *)sch{
    
    self._sch = sch;
    
    NSDate *date = sch.exce_time;
    NSDate *startDate = sch.start_date;
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"HH:mm"];
    
    NSString *times = [fm stringFromDate:date];
    
    dateL.text = times;
    titleL.text = sch.name;
    
    
    NSArray *weeks = sch.week_items;
    if([weeks count])
    {
        
        NSString *weekStr = @"";
        
        if([weeks count] == 7)
        {
            weekStr = @"每天";
        }
        else if([weeks count] == 5)
        {
            if(!([weeks containsObject:@"Sun"] || [weeks containsObject:@"Sat"]))
            {
                weekStr = @"工作日";
            }
            else
            {
                for(NSString *wk in weeks){
                    
                    NSString *wa = [self weekIdxFromSum:wk];
                    
                    if([weekStr length] == 0)
                        weekStr = wa;
                    else
                    {
                        weekStr = [NSString stringWithFormat:@"%@, %@", weekStr, wa];
                    }
                }
            }
        }
        else
        {
            
            for(NSString *wk in weeks){
                
                NSString *wa = [self weekIdxFromSum:wk];
                
                if([weekStr length] == 0)
                    weekStr = wa;
                else
                {
                    weekStr = [NSString stringWithFormat:@"%@, %@", weekStr, wa];
                }
            }
        }
        
        weeksL.text = weekStr;
        [weeksL contentSize];
    }
    else
    {
        [fm setDateFormat:@"yyyy-MM-dd"];
        NSString *times = [fm stringFromDate:startDate];
        weeksL.text = times;
       
    }

}


- (void) showRgsAutoRun:(RgsAutomationObj *)sch{
    
    self._sch = sch;
    
    NSString *names = sch.name;
    NSArray *arrs = [names componentsSeparatedByString:@";"];
    if([arrs count] == 3)
    {
        dateL.frame = CGRectMake(0, 20, self.frame.size.width, 20);
        titleL.frame = CGRectMake(0, 45, self.frame.size.width, 20);
        weeksL.frame = CGRectMake(10, 70, self.frame.size.width-20, 20);
        
        
        dateL.text = [arrs objectAtIndex:0];
        dateL.font = [UIFont systemFontOfSize:14];
        
        titleL.text = [arrs objectAtIndex:1];
        titleL.font = [UIFont systemFontOfSize:12];
        
        weeksL.text = [arrs objectAtIndex:2];
    }
}

- (void) loadData:(NSArray*)operatins{
    
    
}


@end
