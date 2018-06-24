//
//  DriverConnectionsView.m
//  veenoon
//
//  Created by chen jack on 2018/5/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DriverConnectionsView.h"
#import "RegulusSDK.h"
#import "BasePlugElement.h"


@interface DriverConnectionsView () <UITableViewDataSource, UITableViewDelegate>
{
    UIView *_secView;
    
    UITableView *_tableView;
    
    int tableWidth;
    
    int cy;
    int cx;
}

@property (nonatomic, strong) NSArray *_canconnects;

@end

@implementation DriverConnectionsView
@synthesize _driver;
@synthesize _plug;
@synthesize _canconnects;
@synthesize _connectIdx;
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
       // self.backgroundColor = RGBA(0, 0, 0, 0.3);
        
        tableWidth = 300;
        _connectIdx = 0;
        
        UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:mask];
        
        _secView = [[UIView alloc] initWithFrame:CGRectZero];
        _secView.backgroundColor = [UIColor grayColor];
        _secView.layer.cornerRadius = 10;
        _secView.clipsToBounds = YES;
        [self addSubview:_secView];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [mask addGestureRecognizer:tapGesture];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_secView addSubview:_tableView];
        
        _secView.frame = CGRectMake(0, 0, tableWidth, 0);
        _tableView.frame = CGRectMake(0, 0, tableWidth, 0);
        
    }
    
    return self;
}

- (void) handleTapGesture:(id)sender{
    
    [self removeFromSuperview];
}

- (void) showFromPoint:(CGPoint)pt{
    
    //_secView.frame = CGRectMake(pt.x, 0, tableWidth, 0);
    
    cy = pt.y;
    cx = pt.x;
    
   if(_connectIdx < [_plug._connections count])//如果插件有connection
   {
       //获取可以链接的connection
       
       IMP_BLOCK_SELF(DriverConnectionsView);
       RgsConnectionObj *connect = [_plug._connections objectAtIndex:_connectIdx];
       
       [connect GetCanConnect:^(BOOL result, NSArray *connections, NSError *error) {
           
           if (result) {
               
               block_self._canconnects = connections;
               
               [block_self layoutDatas];
           }
       }];
       
       
       
   }
}

- (void) layoutDatas{
    
    int h = ((int)[_canconnects count] + 1)*60;
    
    if(h > 420)
        h = 420;
    
    _secView.frame = CGRectMake(_secView.frame.origin.x, 0, tableWidth, h);
    _secView.center = CGPointMake(cx, cy);
    
    _tableView.frame = _secView.bounds;
    
    [_tableView reloadData];
    
}



#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_canconnects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"listCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.editing = NO;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    
    RgsConnectionObj *data = nil;
    
    data = [self._canconnects objectAtIndex:indexPath.row];
    
//    UIImage *img = [UIImage imageNamed:data._plugicon];
//    UIImageView *iconImage = [[UIImageView alloc] initWithImage:img];
//    iconImage.frame = CGRectMake(tableWidth-30, 12, 16, 16);
//    [cell.contentView addSubview:iconImage];
//    iconImage.contentMode = UIViewContentModeScaleAspectFit;
//
  
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                10,
                                                                tableWidth-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    UILabel* subL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              30,
                                                              tableWidth-35, 20)];
    subL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:subL];
    subL.font = [UIFont systemFontOfSize:14];
    subL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    
    titleL.text = [NSString stringWithFormat:@"%d: %@",
                   data.driver_id,
                   data.driver_name];
    subL.text = data.name;

    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, tableWidth, 1)];
    line.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.2];
    [cell.contentView addSubview:line];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RgsConnectionObj *data = nil;
    data = [self._canconnects objectAtIndex:indexPath.row];
    RgsConnectionObj *connect = [_plug._connections objectAtIndex:_connectIdx];
    
    [_plug createConnection:connect withConnect:data];
    
}


@end
