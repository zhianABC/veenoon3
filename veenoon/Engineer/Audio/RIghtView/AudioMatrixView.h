//
//  AudioMatrixView.h
//  veenoon
//
//  Created by chen jack on 2018/3/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioMatrixViewDelegate <NSObject>
@optional
- (void) didSelectButton:(int)index view:(id)view;

@end

@interface AudioMatrixView : UIView
{
    
}
@property (nonatomic, weak) id <AudioMatrixViewDelegate> delegate;

- (void) changeValue:(float)value;

@end
