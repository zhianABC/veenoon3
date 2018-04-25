//
//  ComSettingView.h
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePlugElement.h"

@protocol ComSettingViewDelegate <NSObject>

@optional
- (void) didChoosedComVal:(NSString*)val;

@end

@interface ComSettingView : UIView
{
    BasePlugElement *_currentObj;
}
@property (nonatomic, assign) BOOL _isAllowedClose;
@property (nonatomic, weak) id <ComSettingViewDelegate> delegate;
@property (nonatomic, strong) BasePlugElement *_currentObj;

- (void) refreshCom:(NSArray*) comArray withCurrentCom:(NSString*) currentCom;
@end
