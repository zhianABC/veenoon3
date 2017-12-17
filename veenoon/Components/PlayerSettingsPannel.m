//
//  PlayerSettingsPannel.m
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "PlayerSettingsPannel.h"
#import "ComSettingView.h"
#import "CustomPickerView.h"

@interface PlayerSettingsPannel () <UITableViewDelegate, UITableViewDataSource, CustomPickerViewDelegate>
{
    UIButton *btnCom;
    UIButton *btnIR;
    
    ComSettingView *_com;
    
    UITableView *_tableView;
    
    int _curIndex;
    BOOL _isAdding;
    
    UIButton *_btnSave;
    
    CustomPickerView *_picker;
}
@property (nonatomic, strong) NSArray *_studyItems;

@end


@implementation PlayerSettingsPannel
@synthesize _studyItems;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGB(0, 89, 118);
        
        
        UIImageView *header = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_header_bg.png"]];
        [self addSubview:header];
        
        CGRect rc = header.frame;
        rc.size.width = frame.size.width;
        header.frame = rc;
        
        btnCom = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCom.frame = CGRectMake(0, 0, 60, rc.size.height);
        [btnCom setImage:[UIImage imageNamed:@"com_icon_sel.png"]
                forState:UIControlStateNormal];
        [self addSubview:btnCom];
        
        btnIR = [UIButton buttonWithType:UIButtonTypeCustom];
        btnIR.frame = CGRectMake(0, 0, 60, rc.size.height);
        [btnIR setImage:[UIImage imageNamed:@"ir_icon_nor.png"]
                forState:UIControlStateNormal];
        [self addSubview:btnIR];
        
        btnCom.center = CGPointMake(CGRectGetMidX(rc)-40, btnCom.center.y);
        btnIR.center = CGPointMake(CGRectGetMidX(rc)+40, btnCom.center.y);
        
        [btnCom addTarget:self
                   action:@selector(comAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [btnIR addTarget:self
                   action:@selector(irAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        CGRect vRc  = CGRectMake(0,
                                CGRectGetMaxY(header.frame),
                                frame.size.width,
                                frame.size.height - CGRectGetMaxY(header.frame));
        
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(frame.size.width-90, 20+CGRectGetMaxY(header.frame), 70, 40);
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [self addSubview:_btnSave];
        [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSave.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        _btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _curIndex = -1;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   80+CGRectGetMaxY(header.frame),
                                                                   frame.size.width,
                                                                   frame.size.height-80-CGRectGetMaxY(header.frame))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        
        _com = [[ComSettingView alloc]
                initWithFrame:vRc];
        [self addSubview:_com];
        _com._isAllowedClose = NO;
        
        
        _picker = [[CustomPickerView alloc]
                                          initWithFrame:CGRectMake(frame.size.width-108, 43, 108, 100) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"2", @"3"]}];
        
        
        _picker._selectColor = [UIColor orangeColor];
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        IMP_BLOCK_SELF(PlayerSettingsPannel);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        
        
    }
    
    return self;
}

- (void) didPickerValue:(NSDictionary *)values{
    
    
}

- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    _curIndex = -1;
    
    _tableView.scrollEnabled = YES;
    [_tableView reloadData];
}

- (void) comAction:(id)sender{
    
    _com.hidden = NO;
    [btnCom setImage:[UIImage imageNamed:@"com_icon_sel.png"]
            forState:UIControlStateNormal];
    [btnIR setImage:[UIImage imageNamed:@"ir_icon_nor.png"]
           forState:UIControlStateNormal];
}

- (void) irAction:(id)sender{
    
    _com.hidden = YES;
    [btnCom setImage:[UIImage imageNamed:@"com_icon_nor.png"]
            forState:UIControlStateNormal];
    [btnIR setImage:[UIImage imageNamed:@"ir_icon_sel.png"]
           forState:UIControlStateNormal];
}



#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(_isAdding)
        return 2;
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
        return 4;
    
    return [_studyItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(_curIndex == indexPath.row)
        {
            return 144;
        }
    }
    
    return 44;
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
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)-20, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)-35, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 16, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [cell.contentView addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        
        if(indexPath.row == 0)
        {
            titleL.text = @"红外端口";
            valueL.text = @"1";
        }
        else if(indexPath.row == 1)
        {
            titleL.text = @"选择品牌";
            valueL.text = @"PHLIPS";
        }
        else if(indexPath.row == 2)
        {
            titleL.text = @"选择型号";
            valueL.text = @"XXXXX";
        }
        else if(indexPath.row == 3)
        {
            titleL.text = @"添加";
            icon.frame = CGRectMake(CGRectGetMaxX(valueL.frame)-20, 11, 20, 20);
            icon.image = [UIImage imageNamed:@"add_brand_icon.png"];
            
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        line.backgroundColor =  RGB(1, 138, 182);
        [cell.contentView addSubview:line];
        if(_curIndex == indexPath.row)
        {
            line.frame = CGRectMake(0, 143, self.frame.size.width, 1);
            
            [cell.contentView addSubview:_picker];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 3)
        {
            _curIndex = -1;
            
            //Add
            
            _isAdding = YES;
        }
        else
        {
            if(indexPath.row == _curIndex)
            {
                _curIndex = -1;
            }
            else
            {
                _curIndex = (int)indexPath.row;
                _tableView.scrollEnabled = NO;
            }
        }
         [_tableView reloadData];
    }
    
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return 0;
    return 44*3;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return nil;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*3)];
    
    
    
    return header;
}


@end
