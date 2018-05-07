//
//  AirConditionComIRView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePlugElement.h"

@interface DVDComIRView : UIView {
    BasePlugElement *_currentObj;
}
@property(nonatomic, assign) BOOL _isAllowedClose;
@property(nonatomic, strong) BasePlugElement *_currentObj;

-(void) refreshComIR:(BasePlugElement*) currentObj;
@end

