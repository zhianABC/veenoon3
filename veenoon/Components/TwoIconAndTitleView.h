//
//  TwoIconAndTitleView.h
//  veenoon
//
//  Created by chen jack on 2018/4/3.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwoIconAndTitleViewDelegate <NSObject>

@optional
- (void) didBeginTouchedTIA:(id)tia;
- (void) didCancelTouchedTIA:(id)tia;

@end

@interface TwoIconAndTitleView : UIView
{
    
}
@property (nonatomic, weak) id <TwoIconAndTitleViewDelegate> delegate;

- (void) fillData:(NSDictionary*)data;
- (void) fillRelatedData:(NSDictionary*)data;
- (void) setTitle:(NSString *)title;
- (BOOL) testIsInDevice;

- (void) unselected;

- (NSDictionary *)getMyData;

@end
