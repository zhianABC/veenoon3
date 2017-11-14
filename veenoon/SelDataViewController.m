//
//  SelDataViewController.m
//  DataCollector
//
//  Created by chen jack on 13-4-14.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import "SelDataViewController.h"

@interface SelDataViewController ()

@end

@implementation SelDataViewController
@synthesize data_;
@synthesize root;
@synthesize _data_type;
@synthesize contentSize_;

- (void) dealloc
{
   
}

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    tableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                               contentSize_.width,
                                                               contentSize_.height)];
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView_];
    
}

#pragma mark UITableView delegate
#pragma mark -
#pragma mark ==== tableView delegate ====
#pragma mark -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [data_ count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 40.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"house-cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"house-cell"];
	}
	
    id dic = [data_ objectAtIndex:indexPath.row];
    if([dic isKindOfClass:[NSDictionary class]])
    {
        cell.textLabel.text = [dic objectForKey:@"name"];
    }
    else
    {
        cell.textLabel.text = dic;
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:NO];
	
    id value = [data_ objectAtIndex:indexPath.row];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:value, @"value",
                         [NSNumber numberWithInt:_data_type],@"type",
                         [NSNumber numberWithInt:(int)indexPath.row],@"index",
                         nil];
    if(root && [root respondsToSelector:@selector(didSelectedData:)])
    {
        [root performSelector:@selector(didSelectedData:) withObject:dic];
    }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
