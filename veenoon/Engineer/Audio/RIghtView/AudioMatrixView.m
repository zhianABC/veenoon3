//
//  AudioMatrixView.m
//  veenoon
//
//  Created by chen jack on 2018/3/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioMatrixView.h"
#import "UIButton+Color.h"

@interface AudioMatrixView ()
{
    
}
@property (nonatomic, strong) UIButton *_curSelectBtn;
@end

@implementation AudioMatrixView
@synthesize delegate;
@synthesize _curSelectBtn;

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
        [self createButtons];
    }
    
    return self;
}

- (void) createButtons{
    
    int x = 0;
    int y = 0;
    int i = 0;
    for(int row = 0; row < 8; row++){
        
        y = 45 * row;
        x = 0;
        for(int col = 0; col < 8; col++)
        {
            UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
            btn.frame = CGRectMake(x, y, 40, 40);
            [self addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitle:@"0.0" forState:UIControlStateNormal];
            x+=45;
            
            [btn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
            
            btn.tag = i;
            i++;
        }
        
        
    }
}

- (void) buttonAction:(UIButton*)btn{
    
    self._curSelectBtn = btn;
    
    int tag = (int)btn.tag;
    
    if(delegate && [delegate respondsToSelector:@selector(didSelectButton:view:)])
    {
        [delegate didSelectButton:tag view:self];
    }
}

- (void) changeValue:(float)value{
    
    if(_curSelectBtn)
    {
        [_curSelectBtn setTitle:[NSString stringWithFormat:@"%0.0f", value]
                       forState:UIControlStateNormal];
        
        if(value > 0)
        {
            [_curSelectBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        }
         else
         {
             [_curSelectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         }
    }
}

@end
