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
    int cellHeight;
    
    CGRect _outputFrame;
    
    UIImageView *outputArea;
}


@end

@implementation UserVideoConfigView
@synthesize _inputDatas;
@synthesize _outputDatas;

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
        cellHeight = 120;
        
        outputArea = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:outputArea];
        outputArea.backgroundColor = RGBA(0, 0, 0, 0.1);
        outputArea.alpha = 0;
        outputArea.layer.cornerRadius = 10;
        outputArea.clipsToBounds = YES;
    }
    
    return self;
    
}


- (void) show{
    
    int x = (SCREEN_WIDTH - ([_inputDatas count]*cellWidth))/2;
    int y = SCREEN_HEIGHT/2 - 160;
    for(int i = 0; i < [_inputDatas count]; i++)
    {
        NSDictionary *dic = [_inputDatas objectAtIndex:i];
        
        StickerLayerView *cell = [[StickerLayerView alloc]
                             initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        [self addSubview:cell];
        cell.tag = i;
        cell._enableDrag = YES;
        cell.delegate_ = self;
        NSString *image = [dic objectForKey:@"image"];
        [cell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"image_sel"];
        cell.selectedImg = [UIImage imageNamed:sel];
        cell.textLabel.text = [dic objectForKey:@"name"];
        
        x+=cellWidth;
    }
    
    
    
    x = (SCREEN_WIDTH - ([_outputDatas count]*cellWidth))/2;
    y = SCREEN_HEIGHT/2 + 100;
    
    _outputFrame = CGRectMake(x, y-20, SCREEN_WIDTH-2*x, cellHeight+60);
    outputArea.frame = _outputFrame;
    
    for(int i = 0; i < [_outputDatas count]; i++)
    {
        NSDictionary *dic = [_outputDatas objectAtIndex:i];
        
        StickerLayerView *cell = [[StickerLayerView alloc]
                                  initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        [self addSubview:cell];
        cell.tag = i;
        cell._enableDrag = NO;
        NSString *image = [dic objectForKey:@"image"];
        [cell setSticker:image];

        NSString *sel = [dic objectForKey:@"image_sel"];
        cell.selectedImg = [UIImage imageNamed:sel];
        cell.textLabel.text = [dic objectForKey:@"name"];
        
        x+=cellWidth;
    }
    
}

- (void) didMovedStickerLayer:(StickerLayerView*)layer sticker:(UIImageView*)sticker{

    CGPoint pt = [self convertPoint:sticker.center
                           fromView:layer];
    
    
    if(CGRectContainsPoint(_outputFrame, pt))
    {
       // [UIView beginAnimations:nil context:nil];
        outputArea.alpha = 1.0;
        //[UIView commitAnimations];
        
        layer._resetWhenEndDrag = NO;
    }
    else
    {
        outputArea.alpha = 0.0;
        
        layer._resetWhenEndDrag = YES;
    }
}

- (void) didEndTouchedStickerLayer:(StickerLayerView*)layer sticker:(UIImageView*)sticker{
    
    CGPoint pt = [self convertPoint:layer.center
                           fromView:sticker];
    
    
    if(CGRectContainsPoint(_outputFrame, pt))
    {
        layer._resetWhenEndDrag = NO;
    }
    else
    {
       layer._resetWhenEndDrag = YES;
    }
    
    
    NSLog(@"%f - %f", pt.x, pt.y);
    
}

@end
