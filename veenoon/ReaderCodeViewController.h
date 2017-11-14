//
//  ReaderCodeViewController.h
//  Hint
//
//  Created by chen jack on 2017/3/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "BaseViewController.h"

@protocol ReaderCodeDelegate <NSObject>

@optional
- (void) didReaderBarData:(NSString*)barString;

@end

@interface ReaderCodeViewController : UIViewController
{
    
}
@property (nonatomic, weak) id <ReaderCodeDelegate> delegate;
@property (nonatomic, assign) int postion;

- (void) setDevicePosition:(int)pos;

- (void) resume;

@end
