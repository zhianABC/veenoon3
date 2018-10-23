//
//  USenceBlockView.m
//  veenoon
//
//  Created by chen jack on 2018/10/21.
//  Copyright © 2018 jack. All rights reserved.
//

#import "USenceBlockView.h"
#import "Scenario.h"

@interface USenceBlockView () <ScenarioDelegate>
{
    UIButton *btn;
    UILabel* titleL;
    UILabel* titleEnL;
    UIImageView *iconView;
}

@end

@implementation USenceBlockView
@synthesize _senario;
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
        UIImage *_nor_image = [UIImage imageNamed:@"user_training_n.png"];
        UIImage *_sel_image = [UIImage imageNamed:@"user_training_s.png"];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn setImage:_nor_image
             forState:UIControlStateNormal];
        [btn setImage:_sel_image
             forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(userTrainingAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 200, 40)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:20];
        titleL.textColor  = [UIColor whiteColor];
        titleL.tag = 102;
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.center = CGPointMake(titleL.center.x, 90);
        
        titleEnL = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 300, 40)];
        titleEnL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleEnL];
        titleEnL.font = [UIFont systemFontOfSize:20];
        titleEnL.textColor  = [UIColor whiteColor];
        titleEnL.tag = 103;
        titleEnL.textAlignment = NSTextAlignmentLeft;
        titleEnL.center = CGPointMake(titleEnL.center.x, 120);
    }
    
    return self;
}

- (void) userTrainingAction:(UIButton*)sender{
    
    if(delegate && [delegate respondsToSelector:@selector(didSelectRoomScenario:cell:)])
    {
        [delegate didSelectRoomScenario:_senario cell:self];
    }
}

- (void) refreshData{
    
    NSDictionary *sDic = [_senario senarioData];
    
    if(![_senario checkNeedReload])
    {
        NSString *iconUser = [sDic objectForKey:@"icon_user"];
        UIImage *img = [UIImage imageNamed:iconUser];
        if(img)
        {
            if(iconView)
            {
                [iconView removeFromSuperview];
            }
            iconView = [[UIImageView alloc] initWithImage:img];
            [btn addSubview:iconView];
            iconView.contentMode = UIViewContentModeCenter;
            
            iconView.center = CGPointMake(100, 105);
            
            
        }
        
        NSString *name = [sDic objectForKey:@"name"];
        titleL.text = name;
        
        NSString *en_name = [sDic objectForKey:@"en_name"];
        if(en_name == nil)
        {
            en_name = @"";
        }
        titleEnL.text = en_name;
    }
    else
    {
        _senario.delegate = self;
        [_senario syncDataFromRegulus];
    }
}

- (void) didEndLoadingUserData{
    
    NSDictionary *sDic = [_senario senarioData];
    
    if(sDic)
    {
        NSString *iconUser = [sDic objectForKey:@"icon_user"];
        UIImage *img = [UIImage imageNamed:iconUser];
        if(img)
        {
            if(iconView)
            {
                [iconView removeFromSuperview];
            }
            iconView = [[UIImageView alloc] initWithImage:img];
            [btn addSubview:iconView];
            iconView.contentMode = UIViewContentModeCenter;
            
            iconView.center = CGPointMake(100, 105);
        }
        
        NSString *name = [sDic objectForKey:@"name"];
        titleL.text = name;
        
        NSString *en_name = [sDic objectForKey:@"en_name"];
        if(en_name == nil)
        {
            en_name = @"";
        }
        titleEnL.text = en_name;
    }
}

- (void) selectedCell:(BOOL)selected{
    
    UIImage *_nor_image = [UIImage imageNamed:@"user_training_n.png"];
    UIImage *_sel_image = [UIImage imageNamed:@"user_training_s.png"];
    
    if(selected)
    {
        //选中
        [btn setImage:_sel_image forState:UIControlStateNormal];
        [btn setImage:_sel_image forState:UIControlStateHighlighted];
        
    }
    else
    {
        //取消
        [btn setImage:_nor_image forState:UIControlStateNormal];
        [btn setImage:_sel_image forState:UIControlStateHighlighted];
    }
}

@end
