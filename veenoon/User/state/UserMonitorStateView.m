//
//  UserMonitorStateView.m
//  veenoon
//
//  Created by 安志良 on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserMonitorStateView.h"

@implementation UserMonitorStateView
@synthesize _dataArray;

- (id)initWithFrame:(CGRect)frame withData:(NSMutableArray*) dataArray {
    if(self = [super initWithFrame:frame])
    {
        self._dataArray = dataArray;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
