//
//  ECPlusSelectView.m
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "VideoProcessRightView.h"
#import "EPlusLayerView.h"
#import "ComSettingView.h"
#import "UIButton+Color.h"

@interface VideoProcessRightView () <UITableViewDelegate,
UITableViewDataSource,
VideoProcessRightViewDelegate, EPlusLayerViewDelegate, UITextFieldDelegate>
{
    UITableView *_tableView;
    UIView     *_maskView;
    
    int _curIndex;
    
    ComSettingView *_com;
    
    UITextField *ipTextField;
    UIView *_footerView;
    
    UIView *_headerView;
}
@property (nonatomic, strong) NSMutableArray *_btns;
@property (nonatomic) int _numOfChannel;
@end

@implementation VideoProcessRightView
@synthesize _data;
@synthesize delegate;
@synthesize _btns;
@synthesize _numOfChannel;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (void) initData{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"icon" ofType:@"plist"];
    self._data = [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (id) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _curIndex = -1;
        
        [self initData];
        
        _numOfChannel= 8;
        
        self.backgroundColor = RGB(0, 89, 118);
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
        
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 40, 30)];
        titleL.textColor = [UIColor whiteColor];
        titleL.backgroundColor = [UIColor clearColor];
//        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.text = @"IP地址";
        
        ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+30, 25, self.bounds.size.width - 35 - CGRectGetMaxX(titleL.frame), 30)];
        ipTextField.delegate = self;
        ipTextField.backgroundColor = [UIColor clearColor];
        ipTextField.returnKeyType = UIReturnKeyDone;
        ipTextField.text = @"192.168.1.100";
        ipTextField.textColor = [UIColor whiteColor];
        ipTextField.borderStyle = UITextBorderStyleRoundedRect;
        ipTextField.textAlignment = NSTextAlignmentRight;
        ipTextField.font = [UIFont systemFontOfSize:13];
        ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-60-160)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        _tableView.clipsToBounds = NO;
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 160,
                                                               self.frame.size.width,
                                                               160)];
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,
                                                               self.frame.size.width,
                                                               60)];
        _headerView.backgroundColor = RGB(0, 89, 118);
        [self addSubview:_headerView];
        [_headerView addSubview:ipTextField];
        [_headerView addSubview:titleL];
        
        [_headerView addSubview:headView];
        
        
        [self addSubview:_footerView];
        _footerView.backgroundColor = M_GREEN_COLOR;
        
        [self layoutFooter];
        
    }
    return self;
}

- (void)layoutFooter{
    
    [[_footerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIColor *rectColor = RGB(0, 146, 174);
    
    self._btns = [NSMutableArray array];
    
    int w = 50;
    int sp = 8;
    int y = (160 - w*2 - sp)/2;
    int x = (self.frame.size.width - 4*w - 3*sp)/2;
    for(int i = 0; i < _numOfChannel; i++)
    {
        int col = i%4;
        int xx = x + col*w + col*sp;
        
        if(i && i%4 == 0)
        {
            y+=w;
            y+=sp;
        }
        
        UIButton *btn = [UIButton buttonWithColor:rectColor selColor:BLUE_DOWN_COLOR];
        btn.frame = CGRectMake(xx, y, w, w);
        [_footerView addSubview:btn];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1]
             forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [_btns addObject:btn];
        
        if (i == 6) {
            [btn setTitle:@"全部"
                 forState:UIControlStateNormal];
            break;
        }
    }
    
    [self chooseChannelAtTagIndex:0];
    
}

- (void) buttonAction:(UIButton*)btn{
    
    [self chooseChannelAtTagIndex:(int)btn.tag];
}

- (void) chooseChannelAtTagIndex:(int)index{
    
    for(UIButton *btn in _btns)
    {
        if(btn.tag == index)
        {
            [btn setTitleColor:YELLOW_COLOR
                      forState:UIControlStateNormal];
            [btn setSelected:YES];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //_curIndex = (int)textField.tag;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) switchComSetting{
    
    if([_com superview])
        return;
    
    CGRect rc = _com.frame;
    rc.origin.y = 0-rc.size.height;
    
    _com.frame = rc;
    [self addSubview:_com];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _com.frame = self.bounds;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    float fy = scrollView.contentOffset.y;
    
    if(fy < -40)
    {
        [self switchComSetting];
    }
    
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
        
        if (indexPath.row == 0 || indexPath.row == 6) {
            cell.userInteractionEnabled=NO;
            [rowCell moveTitleToLeft];
        }
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
