//
//  UserEnvStateView.m
//  veenoon
//
//  Created by 安志良 on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserEnvStateView.h"

@implementation UserEnvStateView
@synthesize _dataArray;

- (id)initWithFrame:(CGRect)frame withData:(NSMutableArray*) dataArray {
    if(self = [super initWithFrame:frame])
    {
        self._dataArray = dataArray;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
