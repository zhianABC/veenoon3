//
//  ActivityViewController.h
//  ws
//
//  Created by jack on 10/18/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ActivityViewControllerDelegate <NSObject>

- (void) didSetEvent:(id)event;

@end

@interface ActivityViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *_data;
@property (nonatomic, weak) id <ActivityViewControllerDelegate> deleate_;

@end
