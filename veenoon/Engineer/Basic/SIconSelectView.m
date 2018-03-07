//
//  SIconSelectView.m
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SIconSelectView.h"
#import "IconLayerView.h"

@interface SIconSelectView () <UITableViewDelegate,
UITableViewDataSource,
IconLayerViewDelegate>
{
    UITableView *_tableView;
    UIView     *_maskView;
    
    int _curIndex;
    
    int _cellHeight;
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
    
    self._icondata = @[@{@"title":@"环境照明",@"icon":@"ce_l_01.png",@"iconbig":@"ce_l_01_big.png"},
                       @{@"title":@"环境控制",@"icon":@"ce_l_02.png",@"iconbig":@"ce_l_02_big.png"},
                       @{@"title":@"宾客接待",@"icon":@"ce_l_03.png",@"iconbig":@"ce_l_03_big.png"},
                       @{@"title":@"专业培训",@"icon":@"ce_l_04.png",@"iconbig":@"ce_l_04_big.png"},
                       @{@"title":@"讨论会议",@"icon":@"ce_l_05.png",@"iconbig":@"ce_l_05_big.png"},
                       @{@"title":@"离开模式",@"icon":@"ce_l_06.png",@"iconbig":@"ce_l_06_big.png"},
                       @{@"title":@"洽谈",@"icon":@"ce_l_07.png",@"iconbig":@"ce_l_07_big.png"},
                       @{@"title":@"影音模式",@"icon":@"ce_l_08.png",@"iconbig":@"ce_l_08_big.png"},
                       @{@"title":@"娱乐",@"icon":@"ce_l_09.png",@"iconbig":@"ce_l_09_big.png"},
                       @{@"title":@"商务",@"icon":@"ce_l_10.png",@"iconbig":@"ce_l_10_big.png"}];
}

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _curIndex = 0;
        
        [self initData];
        
        _cellHeight = self.bounds.size.height - 88;
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _tableView.clipsToBounds = NO;
        
        self.backgroundColor = RGB(0, 89, 118);
        
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                             frame.size.width,
                                                             _cellHeight)];
        
        
    
        
        
        int x = 20;
        int y = 20;
        for(int i = 0; i < [_icondata count]; i++)
        {
            int row = i/5;
            int col = i%5;
            x = 20 + col * 55;
            y = 20 + row * 55;
            
            NSDictionary *dic = [_icondata objectAtIndex:i];
            
            IconLayerView *rowCell = [[IconLayerView alloc]
                                       initWithFrame:CGRectMake(x, y,
                                                                50, 50)];
            [_maskView addSubview:rowCell];
            rowCell.tag = i;
            rowCell._enableDrag = YES;
            rowCell.delegate_ = self;
            rowCell._element = dic;
            NSString *image = [dic objectForKey:@"icon"];
            [rowCell setSticker:image];
            
            NSString *sel = [dic objectForKey:@"icon_sel"];
            rowCell.selectedImg = [UIImage imageNamed:sel];
            rowCell.textLabel.text = [dic objectForKey:@"name"];
            rowCell.detailLabel.text = [dic objectForKey:@"type"];

            
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if(_curIndex == section)
    {
       if(section == 0)
           return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
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
    
    
    if(indexPath.section == 0)
    {
        [cell.contentView addSubview:_maskView];

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
    

    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH, 20)];
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont systemFontOfSize:14];
    [header addSubview:tL];
    
    if(section == 0)
        tL.text = @"图标";
    else
        tL.text = @"自动化";
    
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
    
    IconLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_tableView convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.y = pt.y - _tableView.contentOffset.y;
    
    //NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didMoveDragingElecCell:pt:)])
    {
        [delegate didMoveDragingElecCell:st._element pt:ptNew];
    }
    
}
- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker{
   
    _tableView.scrollEnabled = YES;
    
    //NSLog(@"-1");
    
    IconLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_tableView convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.y = pt.y - _tableView.contentOffset.y;
    
    //NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didEndDragingElecCell:pt:)])
    {
        [delegate didEndDragingElecCell:st._element pt:ptNew];
    }
    
}

@end
