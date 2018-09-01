//
//  APBaseView.m
//  veenoon
//
//  Created by chen jack on 2018/3/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "APBaseView.h"
#import "UIButton+Color.h"

@interface APBaseView ()
{
    
}


@end

@implementation APBaseView
@synthesize _channelBtns;
@synthesize _proxys;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:contentView];
        contentView.layer.cornerRadius = 5;
        contentView.clipsToBounds = YES;
        contentView.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        //[self layoutChannelBtns:16];
       
    }
    
    return self;
}

- (void) layoutChannelBtns:(int)num{
    
    if(_channelBtns && [_channelBtns count])
    {
        [_channelBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self._channelBtns = [NSMutableArray array];
    
    float x = 0;
    int y = CGRectGetHeight(self.frame)-60;
    
    float spx = (CGRectGetWidth(self.frame) - num*50.0)/(num-1);
    if(spx > 10)
        spx = 10;
    for(int i = 0; i < num; i++)
    {
        UIButton *btn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
        btn.frame = CGRectMake(x, y, 50, 50);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        btn.tag = i;
        [self addSubview:btn];
        
        if(i == 0)
        {
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        }
        
        [btn addTarget:self
                action:@selector(channelBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        x+=50;
        x+=spx;
        
        [_channelBtns addObject:btn];
        
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [btn addGestureRecognizer:longPress0];
        
    }
    
    if([_channelBtns count])
        [self channelBtnAction:[_channelBtns objectAtIndex:0]];
    
}

- (void) handleTapGesture:(id)sender{
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    
}

- (void) longPressed0:(UILongPressGestureRecognizer*)sender{
    
    UIView* view = sender.view;
    
    if([view isKindOfClass:[UIButton class]])
    {
        [self becomeFirstResponder];
        CGRect rect = [self convertRect:view.frame fromView:view.superview];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        //初始化menu
        [menu setMenuItems:[self getLongTouchMessageCellMenuList]];
        [menu setTargetRect:rect inView:self];
        [menu setMenuVisible:YES animated:YES];
        
    }
    
}

- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList {
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                      action:@selector(onCopyData:)];
    UIMenuItem *pasteItem =
    [[UIMenuItem alloc] initWithTitle:@"粘贴"
                               action:@selector(onPasteData:)];
    
    UIMenuItem *deleteItem =
    [[UIMenuItem alloc] initWithTitle:@"复位"
                               action:@selector(onClearData:)];
    
    
    
    return [NSArray arrayWithObjects:copyItem,pasteItem,deleteItem, nil];
}

// 用于UIMenuController显示，缺一不可
-(BOOL)canBecomeFirstResponder{
    
    return YES;
    
}
// 用于UIMenuController显示，缺一不可
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    //NSLog(@"%@", action);
    
    if (action ==@selector(onCopyData:)
        || action ==@selector(onPasteData:)
        || action ==@selector(onClearData:)){
        
        return YES;
        
    }
    
    return NO;//隐藏系统默认的菜单项
}

- (void) channelBtnAction:(UIButton*)sender
{
    
}
- (void) onCopyData:(id)sender{
}
- (void) onPasteData:(id)sender{
}
- (void) onClearData:(id)sender{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
