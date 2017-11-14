//
//  SelDataViewController.h
//  DataCollector
//
//  Created by chen jack on 13-4-14.
//  Copyright (c) 2013年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelDataViewControllerDelegate <NSObject>

- (void) didSelectedData:(NSDictionary*)dic;

@end


@interface SelDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableView_;

    
    int _data_type;
    
    CGSize contentSize_;
}
@property (nonatomic, strong) NSMutableArray *data_;
@property (nonatomic, assign) id root;
@property (nonatomic, assign) int _data_type;
@property (nonatomic, assign) CGSize contentSize_;

@end
