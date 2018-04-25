//
//  ComSettingView.h
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComSettingViewDelegate <NSObject>

@optional
- (void) didChoosedComVal:(NSString*)val;

@end

@interface ComSettingView : UIView
{

}
@property (nonatomic, assign) BOOL _isAllowedClose;
@property (nonatomic, weak) id <ComSettingViewDelegate> delegate;

@end
