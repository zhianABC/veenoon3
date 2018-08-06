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

@interface AutoRunCell ()
{
    UILabel* titleL;
}
@property (nonatomic, strong) RgsSchedulerObj *_sch;

@end

@implementation AutoRunCell
@synthesize button;
@synthesize _sch;

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
        
        titleL = [[UILabel alloc] initWithFrame:button.bounds];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.numberOfLines = 2;
        
    }
    
    return self;
    
}

- (void) showRgsSchedule:(RgsSchedulerObj *)sch{
    
    self._sch = sch;
    
    IMP_BLOCK_SELF(AutoRunCell);
    
    [[RegulusSDK sharedRegulusSDK] GetEventOperations:sch.evt_obj
                                           completion:^(BOOL result, NSArray *operatins, NSError *error) {
                                               
                                               [block_self loadData:operatins];
                                               
                                           }];
    
    
}

- (void) loadData:(NSArray*)operatins{
    
    NSDate *date = _sch.exce_time;
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"HH:mm"];
    
    NSString *times = [fm stringFromDate:date];
    
    NSString *scenName = @"";
    
    if([operatins count])
    {
        RgsSceneOperation *opt = [operatins objectAtIndex:0];
        RgsSceneDeviceOperation *rgs = [opt getOperation];
        if(rgs)
        {
            scenName = [NSString stringWithFormat:@"%d", (int)rgs.dev_id];
        }
    }
    
    
    titleL.text = [NSString stringWithFormat:@"%@\n%@",
                   times,
                   scenName];
}


@end
