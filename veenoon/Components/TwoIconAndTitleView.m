//
//  TwoIconAndTitleView.m
//  veenoon
//
//  Created by chen jack on 2018/4/3.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "TwoIconAndTitleView.h"

@interface TwoIconAndTitleView ()
{
    UIImageView *bigIcon;
    UIImageView *smallIcon;
    
    
    BOOL _isSelected;
}
@property (nonatomic, strong) NSDictionary *_data;
@property (nonatomic, strong) NSDictionary *_inputdata;

@end


@implementation TwoIconAndTitleView
@synthesize delegate;
@synthesize _data;
@synthesize _inputdata;
@synthesize _textLabel;
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
        
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(0,
                                                   0,
                                                   frame.size.width, 20)];
        [self addSubview:_textLabel];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = [UIColor whiteColor];

        
        bigIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, frame.size.width, 50)];
        [self addSubview:bigIcon];
        bigIcon.layer.contentsGravity = kCAGravityCenter;
        
        
        smallIcon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-13, 80,
                                                                     26,
                                                                     26)];
        
        [self addSubview:smallIcon];
        smallIcon.layer.contentsGravity = kCAGravityResizeAspect;
        smallIcon.alpha = 0;
        
        

    }
    
    return self;
}

- (void) fillRelatedData:(NSDictionary*)data{
    
    self._inputdata = data;
    
    NSString *icon = [_inputdata objectForKey:@"icon_sel"];
    [smallIcon setImage:[UIImage imageNamed:icon]];
    
    
    [UIView beginAnimations:nil context:nil];
    smallIcon.alpha = 1;
    [UIView commitAnimations];

}

- (void) setTitle:(NSString *)title{
    
    _textLabel.text = title;
}

- (void) fillData:(NSDictionary*)data{
    
    self._data = data;
    
    NSString *icon = [data objectForKey:@"icon"];
    [bigIcon setImage:[UIImage imageNamed:icon]];
}

- (NSDictionary *)getMyData{
    
    return _data;
}

- (void) selected{
    
    NSString *icon = [_data objectForKey:@"icon_sel"];
    if(icon)
    {
        _isSelected = YES;
        [bigIcon setImage:[UIImage imageNamed:icon]];
    
        _textLabel.textColor = YELLOW_COLOR;
    }
    
}
- (void) unselected{
    
    _isSelected = NO;
    
    NSString *icon = [_data objectForKey:@"icon"];
    [bigIcon setImage:[UIImage imageNamed:icon]];
    
    _textLabel.textColor = [UIColor whiteColor];
    
    [UIView beginAnimations:nil context:nil];
    smallIcon.alpha = 0;
    [UIView commitAnimations];

}
- (BOOL) getIsSelected{
    
    return _isSelected;
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if(_isSelected)
    {
        if([delegate respondsToSelector:@selector(didCancelTouchedTIA:)]){
            [delegate didCancelTouchedTIA:self];
        }
        
        [self unselected];
    }
    else{
        
        
        if([delegate respondsToSelector:@selector(didBeginTouchedTIA:)]){
            [delegate didBeginTouchedTIA:self];
        }
        [self selected];
    
    }
    
  
}



-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {

    
  

    
}
- (BOOL) testIsInDevice
{
    
    NSNumber *number = [_data objectForKey:@"id"];
    int numberInt = [number intValue];
    if (301 <= numberInt && numberInt <= 305) {
        
        return YES;
    }
    
    return NO;
}


@end
