//
//  SIconSelectView.m
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SIconSelectView.h"
#import "IconLayerView.h"
#import "CustomPickerView.h"
#import "YearDatePickerView.h"

@interface SIconSelectView () <UITableViewDelegate,
UITableViewDataSource,
IconLayerViewDelegate, CustomPickerViewDelegate>
{
    UITableView *_tableView;
    UIView     *_maskView;
    
    int _curIndex;
    
    int _cellHeight;
    
    int _row;
    int _section;
    
    CustomPickerView *_picker;
    YearDatePickerView *_ydPicker;
}
@property (nonatomic, strong) NSMutableArray *_autoDatas;

@end

@implementation SIconSelectView
@synthesize _icondata;
@synthesize delegate;
@synthesize _autoDatas;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) initData{
    
    self._autoDatas = [NSMutableArray array];
    
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
        _row = -1;

        
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
        
        _picker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(0, 43, frame.size.width, 160)
                   withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"2", @"3"]}];
        
        
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        IMP_BLOCK_SELF(SIconSelectView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        
        _ydPicker = [[YearDatePickerView alloc]
                     initWithFrame:CGRectMake(0, 43, frame.size.width, 160)
                     withGrayOrLight:@"picker_player.png"];
        
        _ydPicker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerDateValue:values];
        };
    }
    return self;
}

- (void) didPickerDateValue:(NSDictionary*)values{
    
    NSDate *date = [values objectForKey:@"date"];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *sOpen = [fm stringFromDate:date];
    
    if(_curIndex > 1)
    {
        NSMutableDictionary *dic = [_autoDatas objectAtIndex:_curIndex-2];
        NSArray *datas = [dic objectForKey:@"datas"];
        
        if(_ydPicker.tag < [datas count])
        {
            NSMutableDictionary *mdic = [datas objectAtIndex:_ydPicker.tag];
            
            [mdic setObject:date forKey:@"value_obj"];
            [mdic setObject:sOpen forKey:@"value"];
        }
    }
    
    //_curIndex = -1;
    _row = -1;
    [_tableView reloadData];
}

- (void) didPickerValue:(NSDictionary*)values{
    
    NSString *v = [values objectForKey:@0];
    id row = [values objectForKey:@"row"];
    if(_curIndex > 1)
    {
        NSMutableDictionary *dic = [_autoDatas objectAtIndex:_curIndex-2];
        NSArray *datas = [dic objectForKey:@"datas"];
        
        if(_picker.tag < [datas count])
        {
            NSMutableDictionary *mdic = [datas objectAtIndex:_picker.tag];
            
            [mdic setObject:row forKey:@"value_obj"];
            [mdic setObject:v forKey:@"value"];
        }
    }
    
    //_curIndex = -1;
    _row = -1;
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2+[_autoDatas count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if(_curIndex == 0)
        return 1;
    if(_curIndex > 1)
    {
        if(_curIndex == section)
            return 5;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section > 1)
    {
        if(_row == indexPath.row)
        {
            return 44*5;
        }
        return 44;
    }
    else if(indexPath.section == 1)
    {
        return 0;
    }
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
    else if(indexPath.section > 1)
    {
        cell.backgroundColor = M_GREEN_COLOR;
        NSDictionary *dic = [_autoDatas objectAtIndex:indexPath.section - 2];
        NSArray *datas = [dic objectForKey:@"datas"];
        if(indexPath.row < [datas count])
        {
            NSDictionary *data = [datas objectAtIndex:indexPath.row];
            
            int wd = self.frame.size.width;
            
            UILabel* tL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    0,
                                                                    100, 44)];
            tL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:tL];
            tL.font = [UIFont systemFontOfSize:13];
            tL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
            tL.text = [data objectForKey:@"name"];
            
            UILabel* vL = [[UILabel alloc] initWithFrame:CGRectMake(110,
                                                                    0,
                                                                    wd-140, 44)];
            vL.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:vL];
            vL.font = [UIFont systemFontOfSize:13];
            vL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
            vL.textAlignment = NSTextAlignmentRight;
            vL.text = [data objectForKey:@"value"];
            
            UIImageView *icon = [[UIImageView alloc]
                                 initWithFrame:CGRectMake(wd - 20, 17, 10, 10)];
            icon.image = [UIImage imageNamed:@"remote_video_down.png"];
            [cell.contentView addSubview:icon];
            icon.alpha = 0.8;
            icon.layer.contentsGravity = kCAGravityResizeAspect;
            
            if(_row == indexPath.row)
            {
                if (_row == 0) {
                    
                    _ydPicker.tag = 0;
                    [cell.contentView addSubview:_ydPicker];
                }
                else if(_row == 1)
                {
                    int sIdx = [[data objectForKey:@"idx"] intValue];
                    [cell.contentView addSubview:_picker];
                    _picker.tag = 1;
                    NSArray *options = [data objectForKey:@"options"];
                    if(options){
                        _picker._pickerDataArray = @[@{@"values":options}];
                        [_picker selectRow:sIdx inComponent:0];
                    }
                }
                else if (_row == 2) {

                    _ydPicker.tag = 2;
                    [cell.contentView addSubview:_ydPicker];
                    
                }
                else if(_row == 3)
                {
                    int sIdx = [[data objectForKey:@"idx"] intValue];
                    [cell.contentView addSubview:_picker];
                    _picker.tag = 3;
                    NSArray *options = [data objectForKey:@"options"];
                    if(options){
                        _picker._pickerDataArray = @[@{@"values":options}];
                        [_picker selectRow:sIdx inComponent:0];
                    }
                }
                else if(_row == 4)
                {
                    int sIdx = [[data objectForKey:@"idx"] intValue];
                    [cell.contentView addSubview:_picker];
                    _picker.tag = 4;
                    NSArray *options = [data objectForKey:@"options"];
                    if(options){
                        _picker._pickerDataArray = @[@{@"values":options}];
                        [_picker selectRow:sIdx inComponent:0];
                    }
                }
            }
            
        }
        
    }

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
    int crow = (int)indexPath.row;
    
    if(crow == _row)
        _row = -1;
    else
        _row = crow;
    
    [_tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return 40;
    
    if(section > 1)
        return 40;
    
    return 40+100;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = nil;
    
    if(section == 0)
    {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_header_bg.png"]];
        [header addSubview:bg];
        bg.frame = header.bounds;
        
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.frame.size.width, 20)];
        tL.textColor = [UIColor whiteColor];
        tL.font = [UIFont systemFontOfSize:14];
        [header addSubview:tL];
        
        if(section == 0)
            tL.text = @"图标";
    }
    else if(section == 1)
    {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 140)];
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_header_bg.png"]];
        [header addSubview:bg];
        bg.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.frame.size.width, 20)];
        tL.textColor = [UIColor whiteColor];
        tL.font = [UIFont systemFontOfSize:14];
        [header addSubview:tL];
        tL.text = @"自动化";
        
        UIButton* btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(self.frame.size.width-60,
                                  50, 50, 40);
        [btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [header addSubview:btnSave];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSave.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        UILabel *aL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                100,
                                                                self.frame.size.width,
                                                                40)];
        aL.textColor = [UIColor whiteColor];
        aL.font = [UIFont systemFontOfSize:14];
        [header addSubview:aL];
        
        
        aL.text = @"自动化";
        
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(self.frame.size.width-40, 110, 20, 20)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [header addSubview:icon];
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        icon.image = [UIImage imageNamed:@"add_brand_icon.png"];
        
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(0, 100, self.frame.size.width, 40);
        [header addSubview:btnAdd];
        [btnAdd addTarget:self
                   action:@selector(addAutoChannel:)
         forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        
        header.backgroundColor = M_GREEN_COLOR;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    0,
                                                                    CGRectGetWidth(self.frame)-30, 40)];
        titleL.backgroundColor = [UIColor clearColor];
        [header addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        
        NSDictionary *dic = [_autoDatas objectAtIndex:section-2];
        titleL.text = [dic objectForKey:@"title"];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
        line.backgroundColor =  M_GREEN_LINE;
        [header addSubview:line];
        
        if(_curIndex == section)
        {
            line = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, CGRectGetWidth(self.frame)-10, 1)];
            line.backgroundColor =  M_GREEN_LINE;
            [header addSubview:line];
        }
        
    }
    
    if(section < 2)
    {
    
        UIImageView *iconAdd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arraw.png"]];
        [header addSubview:iconAdd];
        iconAdd.center = CGPointMake(20, 20);
        
        if(_curIndex == section || _curIndex > 1)
        {
            iconAdd.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    [btn addTarget:self action:@selector(extendAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btn];
    btn.tag = section;
    
    return header;
}

- (void) addAutoChannel:(id)sender{
    
    int c = (int)[_autoDatas count] + 1;
    NSMutableDictionary *secDic = [NSMutableDictionary dictionary];
    [secDic setObject:[NSString stringWithFormat:@"自动化 %d", c] forKey:@"title"];
    
    NSMutableArray *datas = [NSMutableArray array];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setObject:@"开始日期时间" forKey:@"name"];
    [dic setObject:@"" forKey:@"value"];
    [datas addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic setObject:@"执行场景" forKey:@"name"];
    [dic setObject:@"" forKey:@"value"];
    
    [dic setObject:@[@"宾客接待",@"培训会议",@"离开会场"]
            forKey:@"options"];
    
    [datas addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic setObject:@"结束日期时间" forKey:@"name"];
    [dic setObject:@"" forKey:@"value"];
    [datas addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic setObject:@"执行场景" forKey:@"name"];
    [dic setObject:@"" forKey:@"value"];
    
    [dic setObject:@[@"宾客接待",@"培训会议",@"离开会场"]
            forKey:@"options"];
    
    [datas addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic setObject:@"执行标准" forKey:@"name"];
    [dic setObject:@"" forKey:@"value"];
    
    [dic setObject:@[@"每天",@"工作日",@"周六、周日"]
            forKey:@"options"];
    
    [datas addObject:dic];
    
    [secDic setObject:datas forKey:@"datas"];
    
    [_autoDatas addObject:secDic];
    
    [_tableView reloadData];
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
