//
//  RuleView.h
//  Gemini
//
//  Created by jack on 1/29/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCShareViewDelegate <NSObject>

- (void) didTouchJCActionButtonIndex:(int)index;

@end
@interface JCShareView : UIView
{
    
}
@property (nonatomic, weak) id <JCShareViewDelegate> delegate_;

- (void) animatedShow;
- (void) flyAnimatedShow;

@end
