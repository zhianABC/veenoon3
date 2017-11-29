//
//  UserVideoConfigView.m
//  veenoon
//
//  Created by chen jack on 2017/11/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoConfigView.h"
#import "StickerLayerView.h"

@interface UserVideoConfigView () <StickerLayerViewDelegate>
{
    int cellWidth;
}


@end

@implementation UserVideoConfigView
@synthesize _inputDatas;
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
        
        cellWidth = 110;
    }
    
    return self;
    
}


- (void) show{
    
    int x = (SCREEN_WIDTH - ([_inputDatas count]*cellWidth))/2;
    int y = SCREEN_HEIGHT/2 - 100;
    for(int i = 0; i < [_inputDatas count]; i++)
    {
        NSDictionary *dic = [_inputDatas objectAtIndex:i];
        
        StickerLayerView *cell = [[StickerLayerView alloc]
                             initWithFrame:CGRectMake(x, y, cellWidth, cellWidth)];
        [self addSubview:cell];
        cell.tag = i;
        cell.delegate_ = self;
        NSString *image = [dic objectForKey:@"image"];
        [cell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"image_sel"];
        cell.selectedImg = [UIImage imageNamed:sel];
        
        x+=cellWidth;
    }
    
}

- (void) didEndTouchedStickerLayer:(UIView*)layer{
    
    CGPoint pt = [self convertPoint:layer.center
                           fromView:[layer superview]];
    
    
    NSLog(@"%f - %f", pt.x, pt.y);
    
}

@end
