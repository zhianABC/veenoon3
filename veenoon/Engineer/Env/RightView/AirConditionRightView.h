//
//  AirConditionRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AirConditionProxy;

@interface AirConditionRightView : UIView
{
    
}
@property (nonatomic, strong) AirConditionProxy *_proxy;

@property (nonatomic, strong) NSArray *_models;
@property (nonatomic, strong) NSArray *_degress;
@property (nonatomic, strong) NSArray *_winds;

- (void) reloadData;

@end
