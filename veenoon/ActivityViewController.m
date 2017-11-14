//
//  ActivityViewController.m
//  ws
//
//  Created by jack on 10/18/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "ActivityViewController.h"
#import "UIImageView+WebCache.h"
#import "SBJson4.h"
#import "UserDefaultsKV.h"
#import "WSEvent.h"
#import "UILabel+ContentSize.h"
#import "WaitDialog.h"
#import "UIButton+Color.h"
#import "DataSync.h"
#import "WebClient.h"
#import "Configure.h"

#define EVENT_CELL_IMG_HEIGHT  200

@interface ActivityViewController () <UIActionSheetDelegate, UINavigationBarDelegate, UIScrollViewDelegate>
{
   
    int                 _nextIndex;
    
    WebClient           *_eventClient;
    WebClient           *_http;
    

    int                 _eventId;
}
@property (nonatomic, strong) WSEvent *_selEvent;


@end

@implementation ActivityViewController
@synthesize _data;
@synthesize _selEvent;
@synthesize deleate_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"活动";
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:bg];
    bg.backgroundColor = THEME_RED_COLOR;
    
    UILabel *titlebar = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    titlebar.font = [UIFont boldSystemFontOfSize:18];
    titlebar.textAlignment = NSTextAlignmentCenter;
    titlebar.textColor = [UIColor whiteColor];
    [bg addSubview:titlebar];
    titlebar.text = @"设置门禁活动";
    
    UIButton *btnCancel = [UIButton buttonWithColor:[UIColor whiteColor] selColor:nil];
    btnCancel.frame = CGRectMake(10, 27, 70, 30);
    [bg addSubview:btnCancel];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:COLOR_TEXT_A forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnCancel addTarget:self action:@selector(cancelSet:) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.layer.cornerRadius = 3;
    btnCancel.clipsToBounds = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    

    _nextIndex = 0;
    [self prepareData];
}


- (void) cancelSet:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareData{
    
    self._data = [NSMutableArray array];
    
    _nextIndex = 0;
    [self refreshAction:nil];
    
    
}

- (void) refreshAction:(id)sender{
    
    [_data removeAllObjects];
    _nextIndex = 0;
    
    [self requestData];
}


- (void) requestData{
    
    User *u = [UserDefaultsKV getUser];
    
    NSString *token = nil;
    if(u)
    {
        token = u._authtoken;
    }
    
    
    if(_http == nil)
        _http = [[WebClient alloc] initWithDelegate:self];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%d", _nextIndex], @"start",
                                  @"1", @"num",
                                  @"1", @"scope",
                                  nil];
    
    if(token)
    {
        [param setObject:token forKey:@"token"];
    }
    
    //[param setObject:@"1" forKey:@"NEW_SYS"];
    
    _http._method = NEW_API_EVENT_LIST;
    _http._httpMethod = @"GET";
    _http._requestParam = param;
   
    
    [[WaitDialog sharedDialog] setTitle:@"加载中..."];
    [[WaitDialog sharedDialog] startLoading];
   
    IMP_BLOCK_SELF(ActivityViewController);
    
    [_http requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        // NSLog(@"%@", response);
       
        [[WaitDialog sharedDialog] endLoading];
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                
                NSString *result = [v objectForKey:@"code"];
                
                if([result intValue] == 0)
                {
                    NSArray *list = [v objectForKey:@"list"];
                    [block_self refreshData:list];
                
                }
    
            }
            
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            NSLog(@"OOPS: %@", err);
            
            [[WaitDialog sharedDialog] endLoading];
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
       
        [[WaitDialog sharedDialog] endLoading];
    }];
    
}

-(void) refreshData:(NSArray*)data{
    
    
    for(NSDictionary *dic in data)
    {
        WSEvent *event = [[WSEvent alloc] initWithDictionary:dic];
        [_data addObject:event];
        
        
        _eventId = event.wsId;
        
        break;
    }
    
    [self requestEventInfo];

}

- (void) requestEventInfo{
    
    User *u = [UserDefaultsKV getUser];
    
    NSString *token = nil;
    if(u)
    {
        token = u._authtoken;
    }
    
    
    if(_eventClient == nil)
        _eventClient = [[WebClient alloc] initWithDelegate:self];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if(token)
    {
        [param setObject:token forKey:@"token"];
    }
    
    [param setObject:@"3" forKey:@"scopes"];
    
    //[param setObject:@"1" forKey:@"NEW_SYS"];
    
    _eventClient._method = [NSString stringWithFormat:@"%@/%d", @"/v1/event", _eventId];
    _eventClient._httpMethod = @"GET";
    _eventClient._requestParam = param;
    
    
    IMP_BLOCK_SELF(ActivityViewController);
    
    [_eventClient requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        // NSLog(@"%@", response);
        
        [[WaitDialog sharedDialog] endLoading];
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                
                NSString *result = [v objectForKey:@"code"];
                
                if([result intValue] == 0)
                {
                    
                    [block_self refreshProjectData:v];
                }
                
                return;
            }
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            NSLog(@"OOPS: %@", err);
            
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        [[WaitDialog sharedDialog] endLoading];
        
    }];
    
}



- (void) refreshProjectData:(NSDictionary*)data{
    
    NSArray *list = [data objectForKey:@"eventlist"];
    
    for(NSDictionary *dic in list)
    {
        WSEvent *event = [[WSEvent alloc] initWithDictionary:dic];
        [_data addObject:event];
        
    }
    
    [_tableView reloadData];
    
}


- (void) addActivityAction:(UIButton*)btn{
    
    
}


#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"StaffSeatCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, EVENT_CELL_IMG_HEIGHT+140)];
    [cell.contentView addSubview:cellV];
    cellV.backgroundColor = [UIColor whiteColor];
    cellV.layer.cornerRadius = 3;
    cellV.clipsToBounds = YES;
    cellV.layer.borderColor = LINE_COLOR.CGColor;
    cellV.layer.borderWidth = 1;
    
    if(indexPath.row < [_data count])
    {
        WSEvent *event = [_data objectAtIndex:indexPath.row];
        
        UIImageView *cellBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, EVENT_CELL_IMG_HEIGHT+102)];
        [cellV addSubview:cellBg];
        cellBg.clipsToBounds = YES;
        cellBg.layer.contentsGravity = kCAGravityResizeAspectFill;
        
        NSString *url = event.coverurl;
        if([event.sliderurls count])
        {
            url = [event.sliderurls objectAtIndex:0];
        }
        
        [cellBg setImageWithURL:[NSURL URLWithString:url]];

//
        //CGRectGetMaxY(cellImage.frame)
        UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, EVENT_CELL_IMG_HEIGHT, SCREEN_WIDTH-20, 140)];
        [cellV addSubview:bk];
        bk.userInteractionEnabled = YES;
        
        bk.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    10,
                                                                    CGRectGetWidth(cellV.frame)-20, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [bk addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textColor  = [UIColor blackColor];
        titleL.text = event.title;
        titleL.textAlignment = NSTextAlignmentLeft;
        [titleL contentSize];
        
        CGRect rc = titleL.frame;
        if(rc.size.height > 40){
            rc.size.height = 40;
            titleL.frame = rc;
        }
        
        UILabel* address = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                     60,
                                                                     CGRectGetWidth(cellV.frame)-20, 20)];
        address.backgroundColor = [UIColor clearColor];
        [bk addSubview:address];
        address.font = [UIFont systemFontOfSize:12];
        address.textColor  = COLOR_TEXT_A;
        address.text = event.address;
        
        
        UILabel* timeL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                   CGRectGetMaxY(address.frame)-2,
                                                                   SCREEN_WIDTH-35, 20)];
        timeL.backgroundColor = [UIColor clearColor];
        [bk addSubview:timeL];
        timeL.font = [UIFont systemFontOfSize:12];
        timeL.textColor  = COLOR_TEXT_A;
        timeL.text = event.eventtime;
        
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                                  CGRectGetMaxY(timeL.frame)+5,
                                                                  CGRectGetWidth(bk.frame)-10, 1)];
        line.backgroundColor = LINE_COLOR;
        [bk addSubview:line];
        
        
        UILabel* tL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(line.frame)+10, 40, 20)];
        tL.backgroundColor = RGB(0xff, 0x73, 0x25);
        [bk addSubview:tL];
        tL.font = [UIFont systemFontOfSize:12];
        tL.textColor = [UIColor whiteColor];
        tL.textAlignment = NSTextAlignmentCenter;
        tL.text = @"展览";
        tL.layer.cornerRadius = 3;
        tL.clipsToBounds = YES;
        
        if(indexPath.row > 0)
        {
            tL.text = @"论坛";
        }
        
        
        int sp = [[NSDate date] timeIntervalSince1970] - event.closetime;
        if(sp > 0)
        {
            tL = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMinY(line.frame)+10, 50, 20)];
            tL.backgroundColor = THEME_RED_COLOR;
            [bk addSubview:tL];
            tL.font = [UIFont systemFontOfSize:12];
            tL.textColor = [UIColor whiteColor];
            tL.textAlignment = NSTextAlignmentCenter;
            tL.text = @"已结束";
            tL.layer.cornerRadius = 3;
            tL.clipsToBounds = YES;
        }
        else
        {
            tL = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMinY(line.frame)+10, 50, 20)];
            tL.backgroundColor = RGB(110, 213, 106);
            [bk addSubview:tL];
            tL.font = [UIFont systemFontOfSize:12];
            tL.textColor = [UIColor whiteColor];
            tL.textAlignment = NSTextAlignmentCenter;
            tL.text = @"进行中";
            tL.layer.cornerRadius = 3;
            tL.clipsToBounds = YES;
        }
        
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row < [_data count])
    {
        WSEvent *event = [_data objectAtIndex:indexPath.row];
       
        self._selEvent = event;
        
        NSString *msg = [NSString stringWithFormat:@"确认设置\"%@\"为门禁会议？",event.title];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"设置", nil];
        alert.tag = 2016;
        [alert show];
        
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVENT_CELL_IMG_HEIGHT+140+10;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.cancelButtonIndex != buttonIndex)
    {
        if(deleate_ && [deleate_ respondsToSelector:@selector(didSetEvent:)])
        {
            [deleate_ didSetEvent:_selEvent];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
