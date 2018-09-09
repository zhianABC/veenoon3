//
//  UserDeviceStateView.h
//  veenoon
//
//  Created by 安志良 on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDeviceStateView : UIView {
    NSMutableArray *_dataArray;
    
    
}
@property (nonatomic, strong) NSMutableArray *_dataArray;

- (id)initWithFrame:(CGRect)frame withData:(NSMutableArray*) dataArray;
@end
