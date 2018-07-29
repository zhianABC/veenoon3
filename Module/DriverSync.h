//
//  DriverSync.h
//  veenoon
//
//  Created by chen jack on 2018/7/29.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DriverSyncDelegate <NSObject>

@optional
- (void) uploadDoneAndNext;
- (void) syncDoneAndNext;

@end

@interface DriverSync : NSObject
{
    
}
@property (nonatomic, weak) id <DriverSyncDelegate> delegate;

- (id) initWithDict:(id)data;

- (void) uploadData;
- (void) syncData;

@end
