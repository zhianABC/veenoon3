//
//  ChooseDriverViewController.m
//  zhucebao
//
//  Created by jack on 5/13/14.
//
//

#import "ChooseDriverViewController.h"
#import "SBJson4.h"
#import "DataCenter.h"
#import "UserDefaultsKV.h"

@interface ChooseDriverViewController () <UISearchBarDelegate>
{
    UISearchBar *searchBar_;
    UIView *maskView;
}
@property (nonatomic, strong) NSArray *_audioDrivers;
@property (nonatomic, strong) NSArray *_videoDrivers;
@property (nonatomic, strong) NSArray *_envDrivers;
@property (nonatomic, strong) NSArray *_otherDrivers;
@end

@implementation ChooseDriverViewController
@synthesize _audioDrivers;
@synthesize _videoDrivers;
@synthesize _envDrivers;
@synthesize _otherDrivers;

@synthesize _block;
@synthesize _size;

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
    
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView *titleV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _size.width, 40)];
    titleV.backgroundColor = DARK_GRAY_COLOR;
    [self.view addSubview:titleV];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _size.width-20, 20)];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"选择插件";
    titleL.textColor = [UIColor whiteColor];
    [titleV addSubview:titleL];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40,
                                                               _size.width,
                                                               _size.height-40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    [self requestPrinterList];
    
}



- (void) refreshData{
    
    
    
    
    [_tableView reloadData];
}


- (void) requestPrinterList{
    
    self._audioDrivers = @[@{@"type":@"audio",
                             @"name":@"音频处理器",
                             @"driver":UUID_Audio_Processor,
                             @"brand":@"Teslaria",
                             @"icon":@"engineer_yinpinchuli_n.png",
                             @"icon_s":@"engineer_yinpinchuli_s.png",
                             @"driver_class":@"AudioEProcessor",
                             @"ptype":@"Audio Processor"
                             }];
    
    self._videoDrivers = @[@{@"type":@"video",
                             @"name":@"摄像机",
                             @"driver":UUID_NetCamera,
                             @"brand":@"Teslaria",
                             @"icon":@"engineer_video_shexiangji_n.png",
                             @"icon_s":@"engineer_video_shexiangji_s.png",
                             @"driver_class":@"VCameraSettingSet",
                             @"ptype":@"Camera"
                             },
                           @{@"type":@"video",
                             @"name":@"投影机",
                             @"driver":UUID_CANON_WUX450,
                             @"brand":@"Canon",
                             @"icon":@"engineer_video_touyingji_n.png",
                             @"icon_s":@"engineer_video_touyingji_s.png",
                             @"driver_class":@"VTouyingjiSet",
                             @"ptype":@"WUX450"
                             }];
    
    self._envDrivers = @[@{@"type":@"env",
                             @"name":@"照明",
                             @"driver":UUID_6CH_Dimmer_Light,
                             @"brand":@"Teslaria",
                             @"icon":@"engineer_env_zhaoming_n.png",
                           @"icon_s":@"engineer_env_zhaoming_s.png",
                           @"driver_class":@"EDimmerLight",
                             @"ptype":@"6 CH Dimmer Light"
                             }];

    self._otherDrivers = @[@{@"type":@"other",
                               @"name":@"串口服务器",
                               @"driver":UUID_Serial_Com,
                               @"brand":@"Teslaria",
                             @"icon":@"engineer_video_xinxihe_n.png",
                             @"icon_s":@"engineer_video_xinxihe_s.png",
                             @"driver_class":@"ComDriver",
                               @"ptype":@"Com"
                               }];
    
    [self refreshData];

}


#pragma mark UITableView dataSource
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIndentifier = @"MOrgCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIndentifier];
	}
	cell.accessoryType = UITableViewCellAccessoryNone;
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *data = nil;
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
        data = [_otherDrivers objectAtIndex:indexPath.row];
    }
    
    UIImage *img = [UIImage imageNamed:[data objectForKey:@"icon_s"]];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:img];
    iconImage.frame = CGRectMake(10, 15, 30, 30);
    [cell.contentView addSubview:iconImage];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                10,
                                                                _size.width-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    UILabel* subL = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                30,
                                                                _size.width-35, 20)];
    subL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:subL];
    subL.font = [UIFont systemFontOfSize:14];
    subL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    
    titleL.text = [data objectForKey:@"name"];
    subL.text = [NSString stringWithFormat:@"%@ %@",
                 [data objectForKey:@"brand"],
                 [data objectForKey:@"ptype"]];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _size.width, 1)];
    line.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.2];
    [cell.contentView addSubview:line];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAdd setImage:[UIImage imageNamed:@"buy_food.png"]
            forState:UIControlStateNormal];
    [cell.contentView addSubview:btnAdd];
    btnAdd.frame = CGRectMake(_size.width - 50, 0, 50, 50);
    [btnAdd addTarget:self
               action:@selector(buttonAdd:)
     forControlEvents:UIControlEventTouchUpInside];
    
    btnAdd.tag = indexPath.section * 1000 + indexPath.row;
    
	return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return [_audioDrivers count];
    if(section == 1)
        return [_videoDrivers count];
    if(section == 2)
        return [_envDrivers count];
    
    return [_otherDrivers count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    int height = 40;
    
    return height;
    
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              _tableView.frame.size.width, 40)];
    header.backgroundColor = USER_GRAY_COLOR;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39,
                                                              _tableView.frame.size.width, 1)];
    line.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.2];
    [header addSubview:line];
    
    UILabel* rowL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              12,
                                                              CGRectGetWidth(_tableView.frame)-20, 20)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont systemFontOfSize:13];
    rowL.textColor  = [UIColor whiteColor];
    
    
    if(section == 0)
        rowL.text = @"音频设备";
    else if(section == 1)
        rowL.text = @"视频设备";
    else if(section == 2)
        rowL.text = @"环境设备";
    else
        rowL.text = @"辅助设备";
    
    [header addSubview:rowL];
    
    
    return header;
}


#pragma mark UITableView delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = nil;
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
        data = [_otherDrivers objectAtIndex:indexPath.row];
    }
    
    if(_block)
    {
        _block(data);
    }
    
}

- (void) buttonAdd:(UIButton*)sender{
    
    int section = sender.tag/1000;
    int row = sender.tag % 1000;
    
    NSDictionary *data = nil;
    if(section == 0)
    {
        data = [_audioDrivers objectAtIndex:row];
    }
    else if(section == 1)
    {
        data = [_videoDrivers objectAtIndex:row];
    }
    else if(section == 2)
    {
        data = [_envDrivers objectAtIndex:row];
    }
    else if(section == 3)
    {
        data = [_otherDrivers objectAtIndex:row];
    }
    
    if(_block)
    {
        _block(data);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dealloc
{
    
}

@end
