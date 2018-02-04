//
//  JCActionView
//  Gemini
//
//  Created by jack on 1/29/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCActionViewDelegate <NSObject>

@optional
- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView;

@end
@interface JCActionView : UIView
{
    
}
@property (nonatomic, strong) NSString *_clickeTxt;

@property (nonatomic, weak) id <JCActionViewDelegate> delegate_;

- (id)initWithTitles:(NSArray*)titles frame:(CGRect)frame;
- (id)initWithTils:(NSArray*)tils frame:(CGRect)frame title:(NSString *)title;

- (void) animatedShow;
- (void) flyAnimatedShow;

@end
