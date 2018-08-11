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

@interface AudioIconSettingView () <UITableViewDelegate,
UITableViewDataSource,AudioIconSettingViewDelegate, EPlusLayerViewDelegate> {
    UITableView *_tableView;
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
        
        NSString *name = basePlugin._name;
        
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
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:finalItems forKey:@"items"];
    [dataDic setObject:@"图标" forKey:@"title"];
    
    self._data = [[NSMutableArray array] arrayByAddingObject:dataDic];
    
}

- (void) setDicIcon:(BasePlugElement*)basePlugin withDic:(NSMutableDictionary*)dataDic {
    
    if ([basePlugin isKindOfClass:[AudioEMix class]])
    {
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon"];
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_05.png" forKey:@"icon_s"];
        [dataDic setObject:@"huiyinhuiyi_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huiyinhuiyi_player_s.png" forKey:@"user_show_icon_s"];
        
    } else if ([basePlugin isKindOfClass:[AudioEHand2Hand class]])
    {
        [dataDic setObject:@"a_wx_2.png" forKey:@"icon"];
        [dataDic setObject:@"a_wx_2.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_03.png" forKey:@"icon_s"];
        [dataDic setObject:@"huatong_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huatong_player_s.png" forKey:@"user_show_icon_s"];
        
    } else if ([basePlugin isKindOfClass:[AudioEWirlessMike class]])
    {
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon"];
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_05.png" forKey:@"icon_s"];
        [dataDic setObject:@"huiyinhuiyi_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huiyinhuiyi_player_s.png" forKey:@"user_show_icon_s"];
        
    } else if ([basePlugin isKindOfClass:[AudioEWirlessMeetingSys class]])
    {
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon"];
        [dataDic setObject:@"a_yx_3.png" forKey:@"icon_sel"];
        [dataDic setObject:@"s3_05.png" forKey:@"icon_s"];
        [dataDic setObject:@"huiyinhuiyi_player_n.png" forKey:@"user_show_icon"];
        [dataDic setObject:@"huiyinhuiyi_player_s.png" forKey:@"user_show_icon_s"];
        
    }
    
}

- (id) initWithFrame:(CGRect)frame withCurrentAudios:(NSArray*) currentAudioArrays {
    self._currentAudioDevices = currentAudioArrays;
    
    if(self = [super initWithFrame:frame]) {
        _curIndex = -1;
        
        [self initData];
        
        self.backgroundColor = RIGHT_VIEW_CORNER_SD_COLOR;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        _tableView.clipsToBounds = NO;
        
    }
    return self;
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_data count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_curIndex == section)
    {
        NSDictionary *row = [_data objectAtIndex:section];
        NSArray *items = [row objectForKey:@"items"];
        
        return [items count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"listCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.editing = NO;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *sec = [_data objectAtIndex:indexPath.section];
    NSArray *items = [sec objectForKey:@"items"];
    
    if(indexPath.row < [items count]) {
        NSDictionary *dic = [items objectAtIndex:indexPath.row];
        
        EPlusLayerView *rowCell = [[EPlusLayerView alloc]
                                   initWithFrame:CGRectMake(0, 0,
                                                            80, 80)];
        [cell.contentView addSubview:rowCell];
        rowCell.tag = indexPath.section * 100 + indexPath.row;
        rowCell._enableDrag = YES;
        rowCell.delegate_ = self;
        rowCell._element = dic;
        NSString *image = [dic objectForKey:@"icon"];
        [rowCell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"icon_sel"];
        rowCell.selectedImg = [UIImage imageNamed:sel];
        
        int xx = 90;
        
        UILabel* textLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(xx,
                                                       20,
                                                       tableView.frame.size.width-xx-10, 20)];
        [cell.contentView addSubview:textLabel];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = [UIColor whiteColor];
        
        UILabel *detailLabel = [[UILabel alloc]
                                initWithFrame:CGRectMake(xx,
                                                         40,
                                                         tableView.frame.size.width-xx-10, 20)];
        [cell.contentView addSubview:detailLabel];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:15];
        detailLabel.textColor = [UIColor whiteColor];
        
        
        textLabel.text = [dic objectForKey:@"name"];
        detailLabel.text = [dic objectForKey:@"type"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_header_bg.png"]];
    [header addSubview:bg];
    bg.frame = header.bounds;
    
    NSDictionary *sec = [_data objectAtIndex:section];
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH, 20)];
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont systemFontOfSize:14];
    [header addSubview:tL];
    
    tL.text = [sec objectForKey:@"title"];
    
    UIImageView *iconAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arraw.png"]];
    [header addSubview:iconAdd];
    iconAdd.center = CGPointMake(20, 20);
    
    if(_curIndex == section)
    {
        iconAdd.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [btn addTarget:self action:@selector(extendAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn];
    btn.tag = section;
    
    return header;
}

- (void) extendAction:(UIButton*)sender{
    
    int nextIndex = (int)sender.tag;
    
    if(_curIndex == nextIndex)
    {
        _curIndex = -1;
    }
    else
    {
        _curIndex = nextIndex;
    }
    
    [_tableView reloadData];
}

- (void) didBeginTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _tableView.scrollEnabled = NO;
    
    //NSLog(@"1");
    
    
    //    EPlusLayerView *st = layer;
    //    UIImageView *icon = sticker;
    //
    //    CGPoint pt = [_tableView convertPoint:icon.center
    //                           fromView:st];
    //
    //    NSLog(@"%f - %f", pt.x, pt.y);
    
}
- (void) didMovedStickerLayer:(id)layer sticker:(id)sticker{
    
    //
    //    EPlusLayerView *st = layer;
    //    UIImageView *icon = sticker;
    //
    //    CGPoint pt = [_tableView convertPoint:icon.center
    //                                 fromView:st];
    //
    //    NSLog(@"%f - %f", pt.x, pt.y);
    
}
- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _tableView.scrollEnabled = YES;
    
    //NSLog(@"-1");
    
    EPlusLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_tableView convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.y = pt.y - _tableView.contentOffset.y;
    
    NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didEndDragingElecCell:pt:)])
    {
        [delegate didEndDragingElecCell:st._element pt:ptNew];
    }
    
}

@end

