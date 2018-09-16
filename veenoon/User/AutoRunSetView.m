//
//  AutoRunSetView.m
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AutoRunSetView.h"
#import "CheckButton.h"
#import "Scenario.h"
#import "RegulusSDK.h"
#import "WebClient.h"
#import "DataBase.h"
#import "User.h"
#import "UserDefaultsKV.h"
#import "Utilities.h"
#import "NSDate-Helper.h"
#import "KVNProgress.h"

#define SCEN_PICKER_WIDTH  300

@interface AutoRunSetView () <UIPickerViewDelegate,
UIPickerViewDataSource,
UITableViewDelegate,
UITableViewDataSource>
{
    UIView *whiteView;
    
    UIDatePicker *_datePicker;
    UIPickerView *_scriptPicker;
    UITableView *_weakPicker;
    
    int col;
    
    UIView *maskView;
    
    int currentRow;
    
    WebClient *_client;
}
@property (nonatomic, strong) NSMutableArray *_scripts;
@property (nonatomic, strong) NSMutableArray *_weaks;
@property (nonatomic, strong) NSMutableDictionary *_selected;

@end

@implementation AutoRunSetView
@synthesize _scripts;
@synthesize _weaks;
@synthesize _scenarios;
@synthesize _selected;
@synthesize ctrl;
@synthesize _schedule;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithDateAndTime:(CGRect)frame{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [maskView addGestureRecognizer:tapGesture];
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height,
                                                             frame.size.width,
                                                             390)];
        [self addSubview:whiteView];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        int x = (frame.size.width - 650)/2.0;
        
        UILabel* colL = [[UILabel alloc] initWithFrame:CGRectMake(x,
                                                                  10,
                                                                  300, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"时间";
        
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(x,
                                                                     40,
                                                                     300,
                                                                     300)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [whiteView addSubview:_datePicker];
        [_datePicker setLocale:[NSLocale currentLocale]];
        
        
        x+=300;
        x+=50;
        
        col = 0;
        
        colL = [[UILabel alloc] initWithFrame:CGRectMake(x,
                                                         10,
                                                         300, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"执行场景";
        
        self._scripts = [NSMutableArray array];
        self._weaks = [NSMutableArray array];
        
        _scriptPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x, 40,
                                                                       300,
                                                                       300)];
        _scriptPicker.delegate = self;
        _scriptPicker.dataSource = self;
        _scriptPicker.showsSelectionIndicator = YES;
        
        [whiteView addSubview:_scriptPicker];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetHeight(whiteView.frame)-50,
                                                                  CGRectGetWidth(whiteView.frame),
                                                                  1)];
        [whiteView addSubview:line];
        line.backgroundColor = LINE_COLOR;
        
        UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(whiteView.frame), 50);
        [whiteView addSubview:btnSave];
        [btnSave setTitle:@"存储" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
        [btnSave addTarget:self
                    action:@selector(saveSchedule:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        currentRow = 0;
    }
    
    return self;
}
- (id) initWithWeeks:(CGRect)frame{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [maskView addGestureRecognizer:tapGesture];
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height,
                                                             frame.size.width,
                                                             390)];
        [self addSubview:whiteView];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        int x = (frame.size.width - 800)/2.0;
        
        UILabel* colL = [[UILabel alloc] initWithFrame:CGRectMake(x,
                                                                  10,
                                                                  300, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"开始时间";
        
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(x,
                                                                     40,
                                                                     300,
                                                                     300)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [whiteView addSubview:_datePicker];
        [_datePicker setLocale:[NSLocale currentLocale]];
        _datePicker.minimumDate = [NSDate date];
        
        x+=300;
        x+=50;
        
        col = 0;
        
        colL = [[UILabel alloc] initWithFrame:CGRectMake(x,
                                                         10,
                                                         200, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"执行场景";
        
        self._scripts = [NSMutableArray array];
        self._weaks = [NSMutableArray array];
        
        _scriptPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(x, 40,
                                                                       200,
                                                                       300)];
        _scriptPicker.delegate = self;
        _scriptPicker.dataSource = self;
        _scriptPicker.showsSelectionIndicator = YES;
        
        [whiteView addSubview:_scriptPicker];
        
        x+=200;
        x+=50;
        
        colL = [[UILabel alloc] initWithFrame:CGRectMake(x,
                                                         10,
                                                         200, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"重复";
        
        self._selected = [NSMutableDictionary dictionary];
        
        _weakPicker = [[UITableView alloc] initWithFrame:CGRectMake(x,
                                                                    40,
                                                                    200,
                                                                    300)
                                                   style:UITableViewStylePlain];
        _weakPicker.delegate = self;
        _weakPicker.dataSource = self;
        _weakPicker.backgroundColor = [UIColor clearColor];
        _weakPicker.separatorColor = [UIColor clearColor];
        _weakPicker.separatorStyle = UITableViewCellSeparatorStyleNone;
        [whiteView addSubview:_weakPicker];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetHeight(whiteView.frame)-50,
                                                                  CGRectGetWidth(whiteView.frame),
                                                                  1)];
        [whiteView addSubview:line];
        line.backgroundColor = LINE_COLOR;
        
        UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(whiteView.frame), 50);
        [whiteView addSubview:btnSave];
        [btnSave setTitle:@"存储" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
        [btnSave addTarget:self
                    action:@selector(saveSchedule:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        currentRow = 0;
        
    }
    
    return self;
    
}
- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    
    return self;
}

- (void) saveSchedule:(id)sender{
    
    if(_weakPicker)
    {
        if([_selected count] == 0)
        {
            [Utilities showMessage:@"请选择周重复"
                              ctrl:ctrl];
            
            return;
        }
    }
    
    NSMutableDictionary *datas = [NSMutableDictionary dictionary];
    
    NSDate *date =_datePicker.date;
    
    NSInteger m_id = 0;
    NSString *atName = @"自动化";
    if(currentRow < [_scenarios count])
    {
        Scenario *s = [_scenarios objectAtIndex:currentRow];
        m_id = s._rgsSceneObj.m_id;
        
        [datas setObject:[s name] forKey:@"name"];
        
        atName = [s name];
    }
    
    NSMutableArray *weeksArr = [NSMutableArray array];
    NSString *weeks = @"";
    for(id key in [_selected allKeys])
    {
        int k = [key intValue];
        NSDictionary *dic = [_weaks objectAtIndex:k];
        
        [weeksArr addObject:[dic objectForKey:@"value"]];
        
        if([weeks length] == 0)
            weeks = [dic objectForKey:@"value"];
        else
            weeks = [NSString stringWithFormat:@"%@,%@",
                     weeks,
                     [dic objectForKey:@"value"]
                     ];
    }

    
    if(date)
    {
        [datas setObject:[NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]]
                  forKey:@"date"];
    }
    
    [datas setObject:[NSString stringWithFormat:@"%d", (int)m_id]
              forKey:@"m_id"];
    
    [datas setObject:weeks
              forKey:@"weeks"];
    
    if(m_id)
    {
    
        IMP_BLOCK_SELF(AutoRunSetView);
        
        [KVNProgress show];
        
       if(_schedule)
       {
           //编辑
           [[RegulusSDK sharedRegulusSDK] SetScheduler:_schedule.m_id
                                                  name:atName
                                             exce_time:date
                                            start_date:date
                                              end_date:nil
                                            week_items:weeksArr
                                            completion:^(BOOL result, RgsSchedulerObj *scheduler, NSError *error) {
                                                
                                                [block_self excAutoRunSet:scheduler datas:datas];
                                            }];
       }
        else
        {
            //新建
            [[RegulusSDK sharedRegulusSDK] CreateScheduler:atName
                                                 exce_time:date
                                                start_date:date
                                                  end_date:nil
                                                week_items:weeksArr
                                                completion:^(BOOL result, RgsSchedulerObj *scheduler, NSError *error) {
                                                    
                                                    [block_self excAutoRunSet:scheduler datas:datas];
                                                    
                                                }];
        }
       
        
    }
    
    
}

- (void) excAutoRunSet:(RgsSchedulerObj*)scheduler_obj datas:(NSDictionary*)datas{
    
    [KVNProgress dismiss];
    
    if(scheduler_obj)
    {
    
        NSMutableArray * opts = [NSMutableArray array];
        
        NSUInteger m_id = [[datas objectForKey:@"m_id"] integerValue];
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:m_id
                                                                          cmd:@"invoke"
                                                                        param:nil];
        [opts addObject:opt];
        
        IMP_BLOCK_SELF(AutoRunSetView);
        [[RegulusSDK sharedRegulusSDK] SetEventOperatons:scheduler_obj.evt_obj
                                              operation:opts
                                             completion:^(BOOL result, NSError *error) {
                                                 
                                                 [block_self done];
                                                 
                                             }];
    }
    else
    {
        [self done];
    }

}


- (void) saveScheduler:(NSDictionary*)datas{
    
    [[DataBase sharedDatabaseInstance] saveScenarioSchedule:datas];
    
#ifdef   REALTIME_NETWORK_MODEL
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/addautoset";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    [param setObject:[datas objectForKey:@"m_id"] forKey:@"scenarioID"];
    [param setObject:[datas objectForKey:@"name"] forKey:@"scenarioName"];
    [param setObject:[datas objectForKey:@"date"] forKey:@"exceTime"];
    [param setObject:[datas objectForKey:@"weeks"] forKey:@"workItems"];
    
    IMP_BLOCK_SELF(AutoRunSetView);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        [block_self done];
        
    } FailBlock:^(id lParam, id rParam) {
        
        [block_self done];
    }];
    
#else
    [self done];
#endif
    
    
}

- (void) done{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Refresh_Items"
                                                        object:nil];
    
    [self hidden];
}

     

- (void) handleTapGesture:(id)sender{
    
    [self hidden];
}

- (void) show{
    
    [self loadData];
    
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         whiteView.frame = CGRectMake(0, self.frame.size.height - 390,
                                                      self.frame.size.width,
                                                      390);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}
- (void) hidden{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         whiteView.frame = CGRectMake(0, self.frame.size.height,
                                                      self.frame.size.width,
                                                      390);
                         
                     } completion:^(BOOL finished) {
                        
                         [self removeFromSuperview];
                     }];
}


- (NSNumber *)weekIdxFromSum:(NSString*)sum{
    
    
    if([sum isEqualToString:@"Mon"])
    {
        return @1;
    }
    else if([sum isEqualToString:@"Tues"])
    {
        return @2;
    }
    else if([sum isEqualToString:@"Wed"])
    {
        return @3;
    }
    else if([sum isEqualToString:@"Thurs"])
    {
        return @4;
    }
    else if([sum isEqualToString:@"Fri"])
    {
        return @5;
    }
    else if([sum isEqualToString:@"Sat"])
    {
        return @6;
    }
    else if([sum isEqualToString:@"Sun"])
    {
        return @0;
    }
    
    return nil;
}


- (void) loadData{
    
    int defRow = currentRow;

    for(int i = 0; i < [_scenarios count]; i++)
    {
        Scenario *s = [_scenarios objectAtIndex:i];
        NSString *scpName = [s name];
        [_scripts addObject:scpName];
        
        if(_schedule && [_schedule.name isEqualToString:scpName])
        {
            defRow = i;
        }
    }
    
    currentRow = defRow;
    
    if(_schedule)
    {
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        [fm setDateFormat:@"yyyy-MM-dd"];
        NSString *ymd = [fm stringFromDate:_schedule.start_date];
        
        [fm setDateFormat:@"HH:mm:ss"];
        NSString *hms = [fm stringFromDate:_schedule.exce_time];
        
        NSString *datestr = [NSString stringWithFormat:@"%@ %@", ymd,hms];
        
        _datePicker.minimumDate = nil;
    
        _datePicker.date = [NSDate dateFromString:datestr
                                       withFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        _datePicker.minimumDate = [NSDate date];
    }
    [_weaks addObject:@{@"name":@"周日",@"value":@"Sun"}];
    [_weaks addObject:@{@"name":@"周一",@"value":@"Mon"}];
    [_weaks addObject:@{@"name":@"周二",@"value":@"Tues"}];
    [_weaks addObject:@{@"name":@"周三",@"value":@"Wed"}];
    [_weaks addObject:@{@"name":@"周四",@"value":@"Thurs"}];
    [_weaks addObject:@{@"name":@"周五",@"value":@"Fri"}];
    [_weaks addObject:@{@"name":@"周六",@"value":@"Sat"}];
    
    [_scriptPicker selectRow:currentRow
                 inComponent:0
                    animated:NO];
    [_scriptPicker reloadAllComponents];
    
    
    if([_schedule.week_items count])
    {
        for(NSString *wk in _schedule.week_items)
        {
            id key = [self weekIdxFromSum:wk];
            
            if(key)
            {
                [_selected setObject:@"1" forKey:key];
            }
        }
    }

    
    [_weakPicker reloadData];
}


#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_weaks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
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
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                5,
                                                                140, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor  = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentCenter;

    if(indexPath.row < [_weaks count])
    {
        id valueRow = [_weaks objectAtIndex:indexPath.row];
        if([valueRow isKindOfClass:[NSString class]])
        {
            titleL.text = valueRow;
        }
        else if([valueRow isKindOfClass:[NSDictionary class]])
        {
            titleL.text = [valueRow objectForKey:@"name"];
        }
    }
    
    CheckButton* btn = [[CheckButton alloc] initWithIcon:[UIImage imageNamed:@"checkbox_unck.png"]
                                             down:[UIImage imageNamed:@"checkbox_cked.png"]
                                            title:@""
                                            frame:CGRectMake(140, 0, 60, 40)];
    [cell.contentView addSubview:btn];
    btn.tag = indexPath.row;
    [btn allowUnCheck:YES];
    
    if([_selected objectForKey:[NSNumber numberWithInt:(int)indexPath.row]])
        [btn check];
    else
        [btn uncheck];
   
    IMP_BLOCK_SELF(AutoRunSetView);
    [btn setClickedCallbackBlock:^(int tagIndex, CheckButton *btn){
        
        [block_self checkClicked:tagIndex btn:btn];
    }];
    
    
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, tableWidth, 1)];
//    line.backgroundColor =  USER_GRAY_COLOR;
//    [cell.contentView addSubview:line];
//
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}

- (void) checkClicked:(int)tagIndex btn:(CheckButton *)btn{
    
    id key = [NSNumber numberWithInteger:btn.tag];
    if(tagIndex)
    {
        [_selected setObject:@"1" forKey:key];
    }
    else
    {
        [_selected removeObjectForKey:key];
    }
    
}

#pragma mark -
#pragma mark PickerView delegate methods
#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentRow = (int)row;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    float width = 200;
     return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _scriptPicker)
        return [_scripts count];
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    NSArray *values = nil;
    int width = 0;
    col = 0;
    if(pickerView == _scriptPicker){
        values = _scripts;
        width = 200;
        col = 1;
    }
    
    UIView *cellRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
   
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    tL.backgroundColor = [UIColor clearColor];
    tL.textAlignment = NSTextAlignmentCenter;

    [cellRow addSubview:tL];
    
    if(row < [values count])
    {
        id valueRow = [values objectAtIndex:row];
        if([valueRow isKindOfClass:[NSString class]])
        {
            tL.text = valueRow;
        }
        else if([valueRow isKindOfClass:[NSDictionary class]])
        {
            tL.text = [valueRow objectForKey:@"name"];
        }
    }
    
    
    return cellRow;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}



@end
