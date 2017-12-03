//
//  OutputScreenView.m
//  veenoon
//
//  Created by chen jack on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "OutputScreenView.h"

@implementation OutputScreenView
@synthesize _txtLabel;
@synthesize _input;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    if([super initWithFrame:frame])
    {
        _txtLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _txtLabel.backgroundColor = [UIColor clearColor];
        _txtLabel.textColor = [UIColor whiteColor];
        _txtLabel.font = [UIFont boldSystemFontOfSize:15];
        _txtLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_txtLabel];
        _txtLabel.adjustsFontSizeToFitWidth = YES;
        
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void) fillInputSource{
    
    if(_input)
    {
        _txtLabel.text = [_input objectForKey:@"title"];
        _txtLabel.font = [UIFont boldSystemFontOfSize:30];
    }
}

@end
