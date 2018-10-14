//
//  SIconSelectView.m
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SIconSelectView.h"
#import "IconLayerView.h"


@interface SIconSelectView () <IconLayerViewDelegate>
{
    UIScrollView *_content;
   
}

@end

@implementation SIconSelectView
@synthesize _icondata;
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) initData{
    
    self._icondata = @[@{@"title":@"环境照明",@"icon":@"ce_l_01.png",
                         @"iconbig":@"senario_02_03.png",
                         @"icon_user":@"senario_02_03_big.png",
                         @"en_name":@"Lighting"
                         },
                       @{@"title":@"环境控制",@"icon":@"ce_l_02.png",
                         @"iconbig":@"senario_02_07.png",
                         @"icon_user":@"senario_02_07_big.png",
                         @"en_name":@"Environmental"
                         },
                       @{@"title":@"宾客接待",@"icon":@"ce_l_03.png",
                         @"iconbig":@"senario_02_11.png",
                         @"icon_user":@"senario_02_11_big.png",
                         @"en_name":@"Guest reception"
                         },
                       @{@"title":@"专业培训",@"icon":@"ce_l_04.png",
                         @"iconbig":@"senario_02_15.png",
                         @"icon_user":@"senario_02_15_big.png",
                         @"en_name":@"Professional"
                         },
                       @{@"title":@"讨论会议",@"icon":@"ce_l_05.png",
                         @"iconbig":@"senario_02_18.png",
                         @"icon_user":@"senario_02_18_big.png",
                         @"en_name":@"Meeting"
                         },
                       @{@"title":@"离开模式",@"icon":@"ce_l_06.png",
                         @"iconbig":@"senario_02_20.png",
                         @"icon_user":@"senario_02_20_big.png",
                         @"en_name":@"Close system"
                         },
                       @{@"title":@"洽谈",@"icon":@"ce_l_07.png",
                         @"iconbig":@"senario_02_26.png",
                         @"icon_user":@"senario_02_26_big.png",
                         @"en_name":@"Talk"
                         },
                       @{@"title":@"影音模式",@"icon":@"ce_l_08.png",
                         @"iconbig":@"senario_02_23.png",
                         @"icon_user":@"senario_02_23_big.png",
                         @"en_name":@"Video"
                         },
//                       @{@"title":@"娱乐",@"icon":@"ce_l_09.png",
//                         @"iconbig":@"senario_02_26.png",
//                         @"icon_user":@"senario_02_26_big.png"
//                         },
                       @{@"title":@"商务",@"icon":@"ce_l_10.png",
                         @"iconbig":@"senario_02_28.png",
                         @"icon_user":@"senario_02_28_big.png",
                         @"en_name":@"Bussiness"
                         }];
}

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initData];
        
        
        self.backgroundColor = [UIColor clearColor];
        
        _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  frame.size.width,
                                                                  frame.size.height)];
        [self addSubview:_content];
        _content.clipsToBounds = NO;
        
        
        [self layoutCells];
        
    }
    return self;
}



- (void) layoutCells{
    
    float xx = 15;
    float i = (self.frame.size.width - ([_icondata count] * 80))/2.0;
    if(xx < i )
        xx = i;
    

    for(int idx = 0; idx < [_icondata count]; idx++)
    {
        NSDictionary *dic = [_icondata objectAtIndex:idx];
        
        IconLayerView *rowCell = [[IconLayerView alloc]
                                  initWithFrame:CGRectMake(xx, 10,
                                                           80, 80)];
        [_content addSubview:rowCell];
        rowCell.tag = idx;
        rowCell._enableDrag = YES;
        rowCell.delegate_ = self;
        rowCell._element = dic;
        NSString *image = [dic objectForKey:@"iconbig"];
        [rowCell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"iconbig"];
        rowCell.selectedImg = [UIImage imageNamed:sel];
        rowCell.textLabel.text = [dic objectForKey:@"name"];
        rowCell.detailLabel.text = [dic objectForKey:@"type"];

        
        xx+=80;
    }
    

    if(xx > _content.frame.size.width)
        _content.contentSize  = CGSizeMake(xx, 100);
    
}



- (void) didBeginTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _content.scrollEnabled = NO;
    
}
- (void) didMovedStickerLayer:(id)layer sticker:(id)sticker{
    
    IconLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_content convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.x = pt.x - _content.contentOffset.x;
    
    //NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didMoveDragingElecCell:pt:)])
    {
        [delegate didMoveDragingElecCell:st._element pt:ptNew];
    }
    
}
- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker{
   
    _content.scrollEnabled = YES;
    
    //NSLog(@"-1");
    
    IconLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_content convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.x = pt.x - _content.contentOffset.x;
    
    //NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didEndDragingElecCell:pt:)])
    {
        [delegate didEndDragingElecCell:st._element pt:ptNew];
    }
    
}

@end
