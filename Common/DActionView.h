//
//  DActionView.h
//  veenoon
//
//  Created by chen jack on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DActionViewCallbackBlock)(int tagIndex, id obj);


@interface DActionView : UIView
{
    DActionViewCallbackBlock _callback;
}
@property (nonatomic, assign) int _selectIndex;
@property (nonatomic, copy) DActionViewCallbackBlock _callback;

- (void) setSelectDatas:(NSArray*)datas;
- (void) dismissView;

@end
