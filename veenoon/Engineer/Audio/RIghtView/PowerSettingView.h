//
//  PowerSettingView.h
//  veenoon
//
//  Created by chen jack on 2017/12/15.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APowerESet;

@interface PowerSettingView : UIView
{
    
}
@property (nonatomic, strong) APowerESet *_objSet;

- (void) show8Labs;
- (void) show16Labs;

@end
