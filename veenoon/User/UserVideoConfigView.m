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

@property (nonatomic, strong) NSMutableArray *_outputs;
@property (nonatomic, strong) NSMutableDictionary *_outputDmap;

@property (nonatomic, strong) NSMutableArray *_inputCells;

@property (nonatomic, strong) StickerLayerView *_curSelectInput;

@end

@implementation UserVideoConfigView
@synthesize delegate_;
@synthesize _inputDatas;
@synthesize _outputDatas;
@synthesize _result;
@synthesize _outputs;
@synthesize _outputDmap;

@synthesize _inputCells;

@synthesize _curSelectInput;

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
        
        self._result = [NSMutableDictionary dictionary];
        
        self._outputDmap = [NSMutableDictionary dictionary];
        
        self._inputCells = [NSMutableArray array];
    }
    
    return self;
    
}

- (void) updateSelectedStatus:(BOOL)isSelected layer:(id)layer{
    
    StickerLayerView *obj = layer;
    
    if(obj.tag < 100)//输入
    {
        if(isSelected)
        {
            self._curSelectInput = layer;
            
            for(StickerLayerView *cell in _inputCells)
            {
                if(cell == layer)
                    continue;
                else{
                    
                    cell.delegate_ = nil;
                    [cell unselected];
                    cell.delegate_ = self;
                }
            }
        }
        else
            self._curSelectInput = nil;
        
    }
    else
    {
        StickerLayerView *output = layer;
        //输出设备
        NSDictionary *outData = output._element;
    
        if(isSelected)
        {
            //如果是选中输出设备，意味着执行Link
            if(_curSelectInput)
            {
                [self linkCell:_curSelectInput
                       outCell:output
                    actCtrlCmd:YES];
            }
        }
        else
        {

            //点击输出，并且输出已经处于选中状态，要么移除原来的链接/要么就是链接新的输入
            id oValKey = [outData objectForKey:@"ctrl_val"];
            id iValKey = [output._linkedElement objectForKey:@"ctrl_val"];
            
            NSDictionary* newInputD = nil;
            id iNewValKey = nil;
            if(_curSelectInput){
                
                newInputD = _curSelectInput._element;
                iNewValKey = [newInputD objectForKey:@"ctrl_val"];
            }
            
            if(iNewValKey && [iNewValKey intValue] != [iValKey intValue])
            {
                [self linkCell:_curSelectInput
                       outCell:output
                    actCtrlCmd:YES];
            }
            else
            {
                //移除原来的link
                
                [_result removeObjectForKey:oValKey];
                [output setTopIconImage:nil];
                
                NSDictionary* inputD = output._linkedElement;
                
                if(delegate_ && [delegate_ respondsToSelector:@selector(didControlInOutState:outSrc:linked:)])
                {
                    [delegate_ didControlInOutState:inputD
                                             outSrc:outData
                                             linked:NO];
                }
                
            }
            
        }
    }

}

- (void) createP2P:(NSDictionary *)p2p{
    
    for(StickerLayerView *cell in _inputCells)
    {
        if(cell._element)
        {
            NSString *ctrl_val = [cell._element objectForKey:@"ctrl_val"];
            NSArray *outputs = [p2p objectForKey:ctrl_val];
            if(outputs && [outputs count])
            {
                for(id val in outputs)
                {
                    
                    StickerLayerView *toCell = [_outputDmap objectForKey:val];
                    if(toCell)
                    {
                        [self linkCell:cell outCell:toCell actCtrlCmd:NO];
                        
                    }
                    
                }
            }
        }
    }
}

- (void) linkCell:(StickerLayerView *)inCell
          outCell:(StickerLayerView* )outCell
       actCtrlCmd:(BOOL)actCtrlCmd{
    

    //输出设备
    NSDictionary *outData = outCell._element;
    if(inCell)
    {
        //输入源
        NSDictionary* inputD = inCell._element;
        
        [_result setObject:inputD
                    forKey:[outData objectForKey:@"ctrl_val"]];
        
        NSString *imageN = [inputD objectForKey:@"user_show_icon_s"];
        [outCell setTopIconImage:[UIImage imageNamed:imageN]];
        
        outCell._linkedElement = inputD;
        
        [outCell selected];
        
        if(actCtrlCmd)
        {
            //链接输入和输出
            if(delegate_ && [delegate_ respondsToSelector:@selector(didControlInOutState:outSrc:linked:)])
            {
                [delegate_ didControlInOutState:inputD
                                         outSrc:outData
                                         linked:YES];
            }
        }
    }
    
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
        cell._enableDrag = NO;
        [cell enableLongPressed];
        
        if([dic objectForKey:@"id"])
        {
            cell.delegate_ = self;
            cell._element = dic;
            
            NSString *image = [dic objectForKey:@"user_show_icon"];
            [cell setSticker:image];
            
            NSString *sel = [dic objectForKey:@"user_show_icon_s"];
            cell.selectedImg = [UIImage imageNamed:sel];
            cell.textLabel.text = [dic objectForKey:@"name"];
        }
        else
        {
            [cell setSticker:@"engineer_scenario_add_small.png"];
            cell.textLabel.text = @"空位";
        }
        x+=cellWidth;
        [_inputCells addObject:cell];
    }
    
    
    
    x = (SCREEN_WIDTH - ([_outputDatas count]*cellWidth))/2;
    y = SCREEN_HEIGHT/2 + 100;
    
    _outputFrame = CGRectMake(x, y-20, SCREEN_WIDTH-2*x, cellHeight+60);
    outputArea.frame = _outputFrame;
    
    self._outputs = [NSMutableArray array];
    
    for(int i = 0; i < [_outputDatas count]; i++)
    {
        NSDictionary *dic = [_outputDatas objectAtIndex:i];
        
        StickerLayerView *cell = [[StickerLayerView alloc]
                                  initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        [cell enableLongPressed];
        cell.delegate_ = self;
        cell._element = dic;
        [self addSubview:cell];

        cell.tag = 100+i;
        
        if([dic objectForKey:@"id"])
        {
            
            cell._enableDrag = NO;
            NSString *image = [dic objectForKey:@"user_show_icon"];
            [cell setSticker:image];
            
            NSString *sel = [dic objectForKey:@"user_show_icon_s"];
            cell.selectedImg = [UIImage imageNamed:sel];
            cell.textLabel.text = [dic objectForKey:@"name"];
            
            [_outputDmap setObject:cell
                            forKey:[dic objectForKey:@"ctrl_val"]];
        }
        else
        {
            [cell setSticker:@"engineer_scenario_add_small.png"];
            cell.textLabel.text = @"空位";
        }
        
        x+=cellWidth;
        [_outputs addObject:cell];
    }
    
}

- (void) longPressed:(StickerLayerView*)sticker {
    
    if([delegate_ respondsToSelector:@selector(didPupConfigView:)]){
        [delegate_ didPupConfigView:sticker];
    }
    
}

@end
