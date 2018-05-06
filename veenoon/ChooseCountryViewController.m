//
//  ChooseCountryViewController.m
//  zhucebao
//
//  Created by chen jack on 13-3-31.
//
//

#import "ChooseCountryViewController.h"
#import "wsDB.h"

@interface ChooseCountryViewController ()

@end

@implementation ChooseCountryViewController
@synthesize data_;
@synthesize root;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"选择国家";
    

    self.data_ = [[wsDB sharedDBInstance] searchByKeywords:@""];
    
    searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, 360, 40)];
	searchBar_.delegate = self;
	searchBar_.placeholder = @"Search";
    searchBar_.placeholder = @"请输入关键字或者国家代码";
    [self.view addSubview:searchBar_];
    
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 380, 500-50) style:UITableViewStyleGrouped];
	tableView_.delegate = self;
	tableView_.dataSource = self;
    tableView_.backgroundColor = [UIColor clearColor];
    tableView_.backgroundView = nil;
	[self.view addSubview:tableView_];
    
    
    
}

#pragma mark UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *txt = searchBar.text;
    if([txt length] > 0){
        self.data_ = [[wsDB sharedDBInstance] searchByKeywords:txt];
        [tableView_ reloadData];
    }
    
    if([searchBar_ isFirstResponder]){
		[searchBar_ resignFirstResponder];
	}
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *txt = searchBar.text;
    if(txt == nil)txt = @"";
    if(txt){
        self.data_ = [[wsDB sharedDBInstance] searchByKeywords:txt];
        [tableView_ reloadData];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
	
	//searchBar.text = @"";
	[searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
	
    searchBar.text = @"";
	if([searchBar_ isFirstResponder]){
		[searchBar_ resignFirstResponder];
	}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
	
	[searchBar setShowsCancelButton:YES animated:YES];
}



#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data_ count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *kCellID = @"listCell";
	
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.editing = NO;
	}
    
    cell.textLabel.text = [data_ objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if(root && [root respondsToSelector:@selector(didPickerCountryValue:)])
    {
        NSString *code = [data_ objectAtIndex:indexPath.row];
        NSRange range = [code rangeOfString:@"中国 (86)"];
        int index = 1;
        if(range.location != NSNotFound)
        {
            index = 0;
        }
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"row",code,@"code", nil];
        [root performSelector:@selector(didPickerCountryValue:) withObject:param];
        
        [self back];
    }
}



- (void) dealloc
{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
