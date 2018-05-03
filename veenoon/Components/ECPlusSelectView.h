//
//  ECPlusSelectView.h
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ECPlusSelectViewDelegate <NSObject>

@optional
- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt;

@end

@interface ECPlusSelectView : UIView
{
    
}
@property (nonatomic, strong) NSArray *_data;
@property (nonatomic, weak) id <ECPlusSelectViewDelegate> delegate;

- (void) expandSection:(int)section;

- (void) reloadData;

@end
