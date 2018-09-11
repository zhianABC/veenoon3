//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerToUseTeslariViewCtrl.h"
#import "EngineerAudioDevicePluginViewCtrl.h"
#import "ChooseDriverViewController.h"
#import "DataSync.h"
#import "UIButton+Color.h"
#import "DriverPropertyView.h"
#import "BasePlugElement.h"
#import "RegulusSDK.h"
#import "EngineerPresetScenarioViewCtrl.h"
#import "DataCenter.h"
#import "KVNProgress.h"

@interface EngineerToUseTeslariViewCtrl () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView             *_tableView;
    
    int                     tableWidth;
    UIPopoverController     *_deviceSelector;
    
    UIImageView             *bottomBar;
    
    DriverPropertyView      *_propertyView;
    
    int                     _indexSel;
    int                     _indexSec;
    
    
}
@property (nonatomic, strong) NSArray *_driver_objs;
@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSArray *_area_objs;

@property (nonatomic, strong) NSMutableArray *_audioDrivers;
@property (nonatomic, strong) NSMutableArray *_videoDrivers;
@property (nonatomic, strong) NSMutableArray *_envDrivers;
@property (nonatomic, strong) NSMutableArray *_chuanganDrivers;
@property (nonatomic, strong) NSMutableArray *_portDrivers;
@property (nonatomic, strong) NSMutableDictionary *_mapFlash;
@end

@implementation EngineerToUseTeslariViewCtrl
@synthesize _selectedDevices;
@synthesize _mapDrivers;
@synthesize _driver_objs;
@synthesize _area_objs;

@synthesize _audioDrivers;
@synthesize _videoDrivers;
@synthesize _envDrivers;
@synthesize _chuanganDrivers;
@synthesize _portDrivers;
@synthesize _mapFlash;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                                      ENGINEER_VIEW_TOP+10,
                                                                      SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"产品驱动属性设置";
    
//    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
//                                                             CGRectGetMaxY(portDNSLabel.frame),
//                                                             SCREEN_WIDTH-80, 30)];
//    portDNSLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:portDNSLabel];
//    portDNSLabel.font = [UIFont systemFontOfSize:15];
//    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
//    portDNSLabel.text = @"TESLARIA将引导您完成整个系统的设置过程";
//
    int top = CGRectGetMaxY(portDNSLabel.frame)+10;
    
    tableWidth = 440;
    
    
//    if(_selectedDevices)
//    {
//        self._audioDrivers = [_selectedDevices objectForKey:@"audio"];
//        self._videoDrivers = [_selectedDevices objectForKey:@"video"];
//        self._envDrivers = [_selectedDevices objectForKey:@"env"];
//        self._chuanganDrivers = [_selectedDevices objectForKey:@"chuangan"];
//        self._portDrivers = [_selectedDevices objectForKey:@"port"];
//    }
    
    if(_audioDrivers == nil)
        self._audioDrivers = [NSMutableArray array];
    
    if(_videoDrivers == nil)
    self._videoDrivers = [NSMutableArray array];
    
    if(_envDrivers == nil)
    self._envDrivers = [NSMutableArray array];
    
    if(_chuanganDrivers == nil)
    self._chuanganDrivers = [NSMutableArray array];
    
    if(_portDrivers == nil)
        self._portDrivers = [NSMutableArray array];
    
    
    _indexSel = -1;
    _indexSec = -1;
    
    self._mapFlash = [NSMutableDictionary dictionary];
    
    UIView *fr = [[UIView alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                          top,
                                                          tableWidth,
                                                          SCREEN_HEIGHT-top-50+10)];
    
    [self.view addSubview:fr];
    fr.layer.cornerRadius = 5;
    fr.clipsToBounds = YES;
    fr.layer.borderColor = USER_GRAY_COLOR.CGColor;
    fr.layer.borderWidth = 1;
    
    
     _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              tableWidth,
                                                              SCREEN_HEIGHT-top-50)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [fr addSubview:_tableView];


    int w = SCREEN_WIDTH - CGRectGetWidth(_tableView.frame) - 2*ENGINEER_VIEW_LEFT - 50;
    
    int xx = CGRectGetMaxX(fr.frame)+50;
    _propertyView = [[DriverPropertyView alloc] initWithFrame:CGRectMake(xx,
                                                             top,
                                                            w, CGRectGetHeight(fr.frame))];
    
    [self.view addSubview:_propertyView];
    _propertyView.hidden = YES;
    
    bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"生成系统" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(saveAction:)
    forControlEvents:UIControlEventTouchUpInside];
   

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyRefreshTable:)
                                                 name:@"NotifyRefreshTableWithCom"
                                               object:nil];
    
    
    [self getDriversFromVeenoon];

    
}


- (void) getDriversFromVeenoon{
    
    IMP_BLOCK_SELF(EngineerToUseTeslariViewCtrl);
    
    RgsAreaObj *areaObj = [DataSync sharedDataSync]._currentArea;
    if(areaObj)
    {
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] GetDrivers:areaObj.m_id
                                       completion:^(BOOL result, NSArray *drivers, NSError *error) {
                                           
                                           if (error) {
                                               
                                               [KVNProgress dismiss];
                                           }
                                           else
                                           {
                                               
                                               [block_self prepareCurrentAreaDrivers:drivers];
                                               
                                               [KVNProgress dismiss];
                                           }
                                       }];
    }
    
}

- (void) prepareCurrentAreaDrivers:(NSArray*)drivers{
    
    NSMutableArray *audios = [NSMutableArray array];
    NSMutableArray *videos = [NSMutableArray array];
    NSMutableArray *envs = [NSMutableArray array];
    NSMutableArray *others = [NSMutableArray array];
    NSMutableArray *ports = [NSMutableArray array];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:audios forKey:@"audio"];
    [result setObject:videos forKey:@"video"];
    [result setObject:envs forKey:@"env"];
    [result setObject:others forKey:@"chuangan"];
    [result setObject:ports forKey:@"port"];
    
    self._selectedDevices = result;
    
    for(RgsDriverObj *driver in drivers)
    {
        RgsDriverInfo *info = driver.info;
        
        NSString *serialStr = info.serial;
        NSDictionary *device = [[DataCenter defaultDataCenter] driverWithKey:serialStr];
        
        if(device)
        {
            NSString *classname = [device objectForKey:@"driver_class"];
            Class someClass = NSClassFromString(classname);
            BasePlugElement * obj = [[someClass alloc] init];
            
            if(obj)
            {
                obj._name = driver.name;
                obj._brand = [device objectForKey:@"brand"];
                obj._type = [device objectForKey:@"ptype"];
                obj._driverUUID = [device objectForKey:@"driver"];
                
                obj._driverInfo = info;
                
                obj._plugicon = [device objectForKey:@"icon"];
                obj._plugicon_s = [device objectForKey:@"icon_s"];
                
                obj._driver = driver;
                
                
                
                NSString *type = [device objectForKey:@"type"];
                if([type isEqualToString:@"audio"])
                {
                    [audios addObject:obj];
                }
                else if([type isEqualToString:@"video"])
                {
                    [videos addObject:obj];
                }
                else if([type isEqualToString:@"env"])
                {
                    [envs addObject:obj];
                }
                else if([type isEqualToString:@"other"])
                {
                    [others addObject:obj];
                }
                else if([type isEqualToString:@"com"])
                {
                    [ports addObject:obj];
                }
            }
            
        }
        
    }

    
    self._audioDrivers = audios;
    self._videoDrivers = videos;
    self._envDrivers = envs;
    self._chuanganDrivers = others;
    self._portDrivers = ports;
    
    [_tableView reloadData];
}



- (void) notifyRefreshTable:(id)sender{
    
    if([_propertyView superview])
        [_propertyView updateConnectionSet];
    
    [_tableView reloadData];
}

- (void) saveAction:(UIButton*)sender{
    
    EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
    NSMutableDictionary *selectedSysDic = [[NSMutableDictionary alloc] init];
    
    [selectedSysDic setObject:_audioDrivers forKey:@"audio"];
    [selectedSysDic setObject:_videoDrivers forKey:@"video"];
    [selectedSysDic setObject:_envDrivers forKey:@"env"];
    [selectedSysDic setObject:_chuanganDrivers forKey:@"chuangan"];
    [selectedSysDic setObject:_portDrivers forKey:@"port"];
    
    ctrl._selectedDevices = selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void) addDeviceAction:(UIButton*)sender{
    
    if([_deviceSelector isPopoverVisible])
        [_deviceSelector dismissPopoverAnimated:NO];
    
    
    ChooseDriverViewController *sel = [[ChooseDriverViewController alloc] init];
    sel.preferredContentSize = CGSizeMake(300, _tableView.frame.size.height);
    sel._size = CGSizeMake(300, _tableView.frame.size.height);
    
    IMP_BLOCK_SELF(EngineerToUseTeslariViewCtrl);
    sel._block = ^(id object)
    {
        [block_self didAddDevice:object];
    };
    
    CGRect rect = [self.view convertRect:sender.frame
                                fromView:bottomBar];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                   inView:self.view
                 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

- (void) didAddDevice:(NSDictionary*)device{
    
    NSString *type = [device objectForKey:@"type"];
    if([type isEqualToString:@"audio"]){
        
        NSString *classname = [device objectForKey:@"driver_class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
  
        if(obj)
        {
            obj._name = [device objectForKey:@"name"];
            obj._brand = [device objectForKey:@"brand"];
            obj._type = [device objectForKey:@"ptype"];
            obj._driverUUID = [device objectForKey:@"driver"];
            
            id key = [device objectForKey:@"driver"];
            obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
            
            obj._plugicon = [device objectForKey:@"icon"];
            obj._plugicon_s = [device objectForKey:@"icon_s"];
            
            //根据此类型的插件，创建自己的驱动，上传到中控
            [obj createDriver];
            
            [_audioDrivers addObject:obj];
        }

    }
    else if([type isEqualToString:@"video"])
    {
        NSString *classname = [device objectForKey:@"driver_class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        
        if(obj)
        {
            obj._name = [device objectForKey:@"name"];
            obj._brand = [device objectForKey:@"brand"];
            obj._type = [device objectForKey:@"ptype"];
            obj._driverUUID = [device objectForKey:@"driver"];
            
            id key = [device objectForKey:@"driver"];
            obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
            
            obj._plugicon = [device objectForKey:@"icon"];
            obj._plugicon_s = [device objectForKey:@"icon_s"];
            
            //根据此类型的插件，创建自己的驱动，上传到中控
            [obj createDriver];
            
            [_videoDrivers addObject:obj];
        }
    }
    else if([type isEqualToString:@"env"])
    {
        NSString *classname = [device objectForKey:@"driver_class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        
        if(obj)
        {
            obj._name = [device objectForKey:@"name"];
            obj._brand = [device objectForKey:@"brand"];
            obj._type = [device objectForKey:@"ptype"];
            obj._driverUUID = [device objectForKey:@"driver"];
            
            id key = [device objectForKey:@"driver"];
            obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
            
            obj._plugicon = [device objectForKey:@"icon"];
            obj._plugicon_s = [device objectForKey:@"icon_s"];
            
            //根据此类型的插件，创建自己的驱动，上传到中控
            [obj createDriver];
            
            [_envDrivers addObject:obj];
        }
    }
    else if ([type isEqualToString:@"chuangan"])
    {
        NSString *classname = [device objectForKey:@"driver_class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        
        if(obj)
        {
            obj._name = [device objectForKey:@"name"];
            obj._brand = [device objectForKey:@"brand"];
            obj._type = [device objectForKey:@"ptype"];
            obj._driverUUID = [device objectForKey:@"driver"];
            
            id key = [device objectForKey:@"driver"];
            obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
            
            obj._plugicon = [device objectForKey:@"icon"];
            obj._plugicon_s = [device objectForKey:@"icon_s"];
            
            //根据此类型的插件，创建自己的驱动，上传到中控
            [obj createDriver];
            
            [_chuanganDrivers addObject:obj];
        }
    }
    else if ([type isEqualToString:@"port"])
    {
        NSString *classname = [device objectForKey:@"driver_class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        
        if(obj)
        {
            obj._name = [device objectForKey:@"name"];
            obj._brand = [device objectForKey:@"brand"];
            obj._type = [device objectForKey:@"ptype"];
            obj._driverUUID = [device objectForKey:@"driver"];
            
            id key = [device objectForKey:@"driver"];
            obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
            
            obj._plugicon = [device objectForKey:@"icon"];
            obj._plugicon_s = [device objectForKey:@"icon_s"];
            
            //根据此类型的插件，创建自己的驱动，上传到中控
            [obj createDriver];
            
            [_portDrivers addObject:obj];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
        return [_audioDrivers count];
    if(section == 1)
        return [_videoDrivers count];
    if(section == 2)
        return [_envDrivers count];
    if(section == 3)
        return [_chuanganDrivers count];
    if(section == 4)
        return [_portDrivers count];
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    BasePlugElement *data = nil;
    if(indexPath.section == 0)
    {
        data = [_audioDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        data = [_videoDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 2)
    {
        data = [_envDrivers objectAtIndex:indexPath.row];
    } else if(indexPath.section == 3)
    {
        data = [_chuanganDrivers objectAtIndex:indexPath.row];
    } else if(indexPath.section == 4)
    {
        data = [_portDrivers objectAtIndex:indexPath.row];
    }
    
//    if(data && data._com)
//    {
//        return 120;
//    }
    
    return 60;
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
    
    
    BasePlugElement *data = nil;
    if(indexPath.section == 0)
    {
        data = [_audioDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        data = [_videoDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 2)
    {
        data = [_envDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 3)
    {
        data = [_chuanganDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 4)
    {
        data = [_portDrivers objectAtIndex:indexPath.row];
    }
    
    UIImage *img = [UIImage imageNamed:data._plugicon];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:img];
    iconImage.frame = CGRectMake(tableWidth-30, 12, 16, 16);
    [cell.contentView addSubview:iconImage];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                10,
                                                                tableWidth-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    UILabel* subL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              30,
                                                              tableWidth-35, 20)];
    subL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:subL];
    subL.font = [UIFont systemFontOfSize:14];
    subL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    
    titleL.text = [data deviceName];
    subL.text = [NSString stringWithFormat:@"%@ %@", data._brand, data._type];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, tableWidth, 1)];
    line.backgroundColor =  USER_GRAY_COLOR;
    [cell.contentView addSubview:line];
    
    
    if(data._driver)
    {
        UILabel* driverIDL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                  30,
                                                                  tableWidth-20, 20)];
        driverIDL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:driverIDL];
        driverIDL.font = [UIFont systemFontOfSize:12];
        driverIDL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        driverIDL.textAlignment = NSTextAlignmentRight;
        driverIDL.text = [NSString stringWithFormat:@"ID: %d",
                          (int)((RgsDriverObj*)data._driver).m_id];
        
    }
    int lh = 60;
    
    id key = [NSString stringWithFormat:@"%d-%d",
              (int)indexPath.section,
              (int)indexPath.row];
    if(![_mapFlash objectForKey:key])
    {
        [_mapFlash setObject:@"1" forKey:key];
        
        cell.transform = CGAffineTransformMakeTranslation(0, 40);
        [UIView animateWithDuration:0.5 animations:^{
            
            cell.transform = CGAffineTransformIdentity;
        }];
    }
    
    if(_indexSec == indexPath.section && _indexSel == indexPath.row)
    {
        UILabel *lineSel = [[UILabel alloc] initWithFrame:CGRectMake(tableWidth-3, 0, 3, lh)];
        lineSel.backgroundColor =  YELLOW_COLOR;
        [cell.contentView addSubview:lineSel];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _indexSec = (int)indexPath.section;
    _indexSel = (int)indexPath.row;
    
    BasePlugElement *data = nil;
    if(indexPath.section == 0)
    {
        data = [_audioDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        data = [_videoDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 2)
    {
        data = [_envDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 3)
    {
        data = [_chuanganDrivers objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 4)
    {
        data = [_portDrivers objectAtIndex:indexPath.row];
    }
    
    _propertyView._plugDriver = data;
    
    // if 空气质量,refresh label
    if ([other_air_quality isEqualToString:[data deviceName]]) {
        _propertyView._isAirQuality = YES;
        [_propertyView refreshLabelToAirQuality];
    } else {
        _propertyView._isAirQuality = NO;
        [_propertyView refreshLabelToAirQuality];
    }
    
    //检查，如果插件的Driver没添加上，再补一下
    if(data._driver == nil)
    {
        [data createDriver];
        
    }
    
    //在这里加载插件的属性，如果差价没有IP属性，加载插件的connection
    //为后面做链接做准备
    [_propertyView recoverSetting];
    
    _propertyView.hidden = NO;
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
 
    int height = 42;
    
    return height;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}



- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IMP_BLOCK_SELF(EngineerToUseTeslariViewCtrl);
    
//    UITableViewRowAction *down = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                                    title:@"重命名"
//                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//                                                                      [block_self renameDriverAtIndex:(int)indexPath.row andCol:(int)indexPath.section];
//                                                                  }];
//    down.backgroundColor = [UIColor orangeColor];
    
    
    UITableViewRowAction *del = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                   title:@"删除"
                                                                 handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                     
                                                                     [block_self removeDriverAtIndex:(int)indexPath.row andCol:(int)indexPath.section];
                                                                 }];
    
    return @[del];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        
 
    }
}


- (void) renameDriverAtIndex:(int)row andCol:(int)col{
    
    BasePlugElement *data = nil;
    NSMutableArray *ma = nil;
    if(col == 0)
    {
        data = [_audioDrivers objectAtIndex:row];
        ma = _audioDrivers;
    }
    else if(col == 1)
    {
        data = [_videoDrivers objectAtIndex:row];
        ma = _videoDrivers;
    }
    else if(col == 2)
    {
        data = [_envDrivers objectAtIndex:row];
        ma = _envDrivers;
    }
    else if(col == 3)
    {
        data = [_chuanganDrivers objectAtIndex:row];
        ma = _chuanganDrivers;
    }
    else if(col == 4)
    {
        data = [_portDrivers objectAtIndex:row];
        ma = _portDrivers;
    }
    
    if(data._driver)
    {
        RgsDriverObj *dr = (RgsDriverObj*)data._driver;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"重命名" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"设备名";
            textField.text = dr.name;
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *drNameTxt = alertController.textFields.firstObject;
            NSString *drName = drNameTxt.text;
            if (drName && [drName length] > 0) {
                
                
                [[RegulusSDK sharedRegulusSDK] RenameDriver:dr.m_id
                                                       name:drName
                                                 completion:^(BOOL result, NSError *error) {
                                                     
                                                     dr.name = drName;
                                                     data._name = drName;
                                                     [_tableView reloadData];
                                                     
                                                 }];
                
            }
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}


- (void) removeDriverAtIndex:(int)row andCol:(int)col{
    
    BasePlugElement *data = nil;
    NSMutableArray *ma = nil;
    if(col == 0)
    {
        data = [_audioDrivers objectAtIndex:row];
        ma = _audioDrivers;
    }
    else if(col == 1)
    {
        data = [_videoDrivers objectAtIndex:row];
        ma = _videoDrivers;
    }
    else if(col == 2)
    {
        data = [_envDrivers objectAtIndex:row];
        ma = _envDrivers;
    }
    else if(col == 3)
    {
        data = [_chuanganDrivers objectAtIndex:row];
        ma = _chuanganDrivers;
    }
    else if(col == 4)
    {
        data = [_portDrivers objectAtIndex:row];
        ma = _portDrivers;
    }
    
    if(data._driver)
    {
        [data removeDriver];
    }
    
    [ma removeObject:data];
    
    [_tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              _tableView.frame.size.width, 40)];
    header.backgroundColor = RGB(0x2b, 0x2b, 0x2c);

    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, tableWidth, 1)];
    line.backgroundColor =  USER_GRAY_COLOR;
    [header addSubview:line];

    UILabel* rowL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              12,
                                                              CGRectGetWidth(_tableView.frame)-20, 20)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont boldSystemFontOfSize:14];
    rowL.textColor  = [UIColor whiteColor];
    
    
    if(section == 0)
        rowL.text = @"音频设备";
    else if(section == 1)
        rowL.text = @"视频设备";
    else if(section == 2)
        rowL.text = @"环境设备";
    else if(section == 3)
        rowL.text = @"传感器设备";
    else
        rowL.text = @"辅助设备";
    
    [header addSubview:rowL];
    
   
    return header;
}


- (void) okAction:(id)sender{
    
    EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];

    NSMutableDictionary *selectedSysDic = [[NSMutableDictionary alloc] init];
    
    [selectedSysDic setObject:_audioDrivers forKey:@"audio"];
    [selectedSysDic setObject:_videoDrivers forKey:@"video"];
    [selectedSysDic setObject:_envDrivers forKey:@"env"];
    [selectedSysDic setObject:_chuanganDrivers forKey:@"chuangan"];
    [selectedSysDic setObject:_portDrivers forKey:@"port"];
    
    ctrl._selectedDevices = selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

