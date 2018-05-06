//
//  ChooseCountryViewController.h
//  zhucebao
//
//  Created by chen jack on 13-3-31.
//
//

#import <UIKit/UIKit.h>

@protocol ChooseCountryViewControllerDelegate <NSObject>

- (void) didPickerCountryValue:(NSDictionary*)value;

@end

@interface ChooseCountryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
     UITableView    *tableView_;
    NSMutableArray *data_;
 
    
    UISearchBar *searchBar_;
}
@property (nonatomic, strong) NSArray *data_;
@property (nonatomic, weak) id root;

@end
