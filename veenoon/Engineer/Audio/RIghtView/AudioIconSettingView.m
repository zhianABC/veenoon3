//
//  ECPlusSelectView.m
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "AudioIconSettingView.h"
#import "EPlusLayerView.h"
#import "ComSettingView.h"
#import "RgsDriverObj.h"
#import "APowerESet.h"
#import "AudioEMix.h"
#import "AudioEHand2Hand.h"
#import "AudioEWirlessMike.h"
#import "AudioEWirlessMeetingSys.h"

@interface AudioIconSettingView () < EPlusLayerViewDelegate> {
   
    UIScrollView *_content;
    UIView     *_maskView;
    
    int _curIndex;
}
@end

@implementation AudioIconSettingView
@synthesize _data;
@synthesize delegate;
@synthesize _currentAudioDevices;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (void) initData{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"audio_icon" ofType:@"plist"];
    NSArray *bundelArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSDictionary *sec = [bundelArray objectAtIndex:0];
    NSMutableArray *items = [sec objectForKey:@"items"];
    
    NSMutableArray *finalItems = [NSMutableArray array];
    [finalItems addObjectsFromArray:items];
    
    int itemID = 304;
    
    for (BasePlugElement *basePlugin in _currentAudioDevices) {
        
        NSString *name = @"";
        if ([basePlugin isKindOfClass:[AudioEMix class]]) {
            name = [basePlugin deviceName];
        } else if ([basePlugin isKindOfClass:[AudioEHand2Hand class]]) {
            name = audio_handtohand_name;
        } else if ([basePlugin isKindOfClass:[AudioEWirlessMike class]]) {
            name = audio_wireless_name;
        } else if ([basePlugin isKindOfClass:[AudioEWirlessMeetingSys class]]) {
            name = audio_wireless_name;
        }
        
        if([basePlugin isKindOfClass:[AudioEMix class]] ||
           [basePlugin isKindOfClass:[AudioEHand2Hand class]] ||
           [basePlugin isKindOfClass:[AudioEWirlessMike class]] ||
           [basePlugin isKindOfClass:[AudioEWirlessMeetingSys class]])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:[NSString stringWithFormat:@"%d", itemID] forKey:@"id"];
            
            [dic setObject:name forKey:@"name"];
            NSString *deviceID = [NSString stringWithFormat:@"%d", (int)
                                  ((RgsDriverObj*)(basePlugin._driver)).m_id];
            [dic setObject:deviceID forKey:@"type"];
            [dic setObject:deviceID forKey:@"driverid"];
            
            if(basePlugin){
                NSString *className  = NSStringFromClass([basePlugin class]);
                [dic setObject:className forKey:@"class"];
            }
            
            //set dic
            [self setDicIcon:basePlugin withDic:dic];
            
            [finalItems addObject:dic];
            
            itemID++;
        }
    }

    self._data = finalItems;
    
}

- (void) setDicIcon:(BasePlugElement*)basePlugin withDic:(NSMutableDictionary*)dataDic {
    
    if ([basePlugin isKindOfClass:[AudioEMix class]])
    {
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon"];
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon_sel"];
        [dataDic setObject:@"a_processor_ico_mix_small.png" forKey:@"icon_s"];
        [dataDic setObject:@"a_processor_ico_mix.png" forKey:@"icon_drag"];
        [dataDic setObject:@"huiyinhuiyi_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huiyinhuiyi_player_s.png" forKey:@"user_show_icon_s"];
        
    } else if ([basePlugin isKindOfClass:[AudioEHand2Hand class]])
    {
        [dataDic setObject:@"a_wx_2.png" forKey:@"icon"];
        [dataDic setObject:@"a_wx_2.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_03.png" forKey:@"icon_s"];
        [dataDic setObject:@"a_processor_ico_lan.png" forKey:@"icon_drag"];
        [dataDic setObject:@"huatong_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huatong_player_s.png" forKey:@"user_show_icon_s"];
        
    } else if ([basePlugin isKindOfClass:[AudioEWirlessMike class]])
    {
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon"];
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_05.png" forKey:@"icon_s"];
        [dataDic setObject:@"a_processor_ico_mic.png" forKey:@"icon_drag"];
        [dataDic setObject:@"huiyinhuiyi_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huiyinhuiyi_player_s.png" forKey:@"user_show_icon_s"];
        
    } else if ([basePlugin isKindOfClass:[AudioEWirlessMeetingSys class]])
    {
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon"];
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_05.png" forKey:@"icon_s"];
        [dataDic setObject:@"a_processor_ico_wir.png" forKey:@"icon_drag"];
        [dataDic setObject:@"huiyinhuiyi_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huiyinhuiyi_player_s.png" forKey:@"user_show_icon_s"];
        
    }
    
}

- (id) initWithFrame:(CGRect)frame withCurrentAudios:(NSArray*) currentAudioArrays {
    
    
    if(self = [super initWithFrame:frame]) {
        
        self._currentAudioDevices = currentAudioArrays;
        
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
    float i = (self.frame.size.width - 30 - ([_data count] * 80 ))/2.0;
    if(xx < i )
        xx = i+15;
    
    
    for(int idx = 0; idx < [_data count]; idx++)
    {
        NSDictionary *dic = [_data objectAtIndex:idx];
        
        EPlusLayerView *rowCell = [[EPlusLayerView alloc]
                                   initWithFrame:CGRectMake(xx, 10,
                                                            80, 80)];
        [_content addSubview:rowCell];
        [rowCell setIconContentsGravity:kCAGravityCenter];
        rowCell.tag = idx;
        rowCell._enableDrag = YES;
        rowCell.delegate_ = self;
        rowCell._element = dic;
        NSString *image = [dic objectForKey:@"icon_drag"];
        [rowCell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"icon_drag"];
        rowCell.selectedImg = [UIImage imageNamed:sel];
        
        xx+=80;
    }

    if(xx > _content.frame.size.width)
        _content.contentSize  = CGSizeMake(xx, 100);
}


- (void) didBeginTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _content.scrollEnabled = NO;
    
}


- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _content.scrollEnabled = YES;
    
    //NSLog(@"-1");
    
    EPlusLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_content convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.x = pt.x - _content.contentOffset.x;
    
    NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didEndDragingElecCell:pt:)])
    {
        [delegate didEndDragingElecCell:st._element pt:ptNew];
    }
    
}

@end

