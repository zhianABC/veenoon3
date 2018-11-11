//
//  EnvStateTableViewCell.h
//  veenoon
//
//  Created by chen jack on 2018/11/4.
//  Copyright © 2018 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class  RgsConnectionObj;
@interface EnvStateTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, strong) RgsConnectionObj *connection;
- (void) refreshData;
- (void) updateValue:(NSDictionary*)val;

@end

NS_ASSUME_NONNULL_END
