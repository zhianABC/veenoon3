//
//  ChooseDriverViewController.h
//  zhucebao
//
//  Created by jack on 5/13/14.
//
//

#import <UIKit/UIKit.h>
#import "WebClient.h"

typedef void (^ChooseDriverCallbackBlock)(id object);


@interface ChooseDriverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;

    ChooseDriverCallbackBlock _block;
}
@property (nonatomic, copy) ChooseDriverCallbackBlock _block;
@property (nonatomic, assign) CGSize _size;

@end
