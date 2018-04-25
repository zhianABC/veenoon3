//
//  PlayerSettingsPannel.h
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTVSet.h"

@interface TVViewRightView : UIView {
    VTVSet *_currentObj;
}
@property (nonatomic, assign) BOOL _isAllowedClose;
@property (nonatomic,strong) VTVSet *_currentObj;

@end

