//
//  ChooseDriverViewController.m
//  zhucebao
//
//  Created by jack on 5/13/14.
//
//

#import "TeslariaComboChooser.h"
#import "SBJson4.h"
#import "DataCenter.h"
#import "UserDefaultsKV.h"

@interface TeslariaComboChooser () <UISearchBarDelegate>
{
    UISearchBar *searchBar_;
    UIView *maskView;
}

@end

@implementation TeslariaComboChooser
@synthesize _dataArray;
@synthesize _type;
@synthesize _block;
@synthesize _size;
@synthesize _unit;

@synthesize _titleStr;

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
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textAlignment = NSTextAlignmentCenter;
    
    titleL.textColor = [UIColor whiteColor];
    
    if(_titleStr)
    {
        titleL.text = _titleStr;
    }
    else
    {
        if (_type == 0) {
            titleL.text = @"选择高通类型";
        } else if (_type == 1) {
            titleL.text = @"选择低通类型";
        } else if (_type == 2) {
            titleL.text = @"选择高通斜率";
        } else if (_type == 3) {
            titleL.text = @"选择频率";
        } else if (_type == 4) {
            titleL.text = @"选择波段";
        } else if (_type == 5) {
            titleL.text = @"电平类型";
        } else if (_type == 6) {
            titleL.text = @"灵敏度";
        }
    }
    
    [titleV addSubview:titleL];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40,
                                                               _size.width,
                                                               _size.height-40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

- (void) refreshData {
    
    [_tableView reloadData];
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
    
    NSString *data = [_dataArray objectAtIndex:indexPath.row];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                _size.width, 30)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    titleL.text = data;
    if(_unit)
    {
        titleL.text = [NSString stringWithFormat:@"%@%@",data,_unit];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _size.width, 1)];
    line.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.2];
    [cell.contentView addSubview:line];
    
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}


#pragma mark UITableView delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *data = nil;
    int idx = indexPath.row;
    if(indexPath.section == 0)
    {
        data = [_dataArray objectAtIndex:indexPath.row];
    }
    
    if(_block)
    {
        _block(data, idx);
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

