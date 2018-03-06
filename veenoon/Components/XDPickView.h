//
//  XDPickView.h
//  HEAL
//
//  Created by 窦心东 on 2017/3/29.
//  Copyright © 2017年 窦心东. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XDPickerDelegate <NSObject>
@required
/**
 * 选择的选项的代理方法  必须实现
 */
- (void)PickerSelectorIndixString:(NSString *)str;

@end

@interface XDPickView : UIView

@property (nonatomic,assign)id<XDPickerDelegate>delegate;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *pickViewTextArray;

/** pickview的背景颜色 */
@property (nonatomic,strong) UIColor *backgroundColor;

/** 文字的颜色 */
@property (nonatomic,strong) UIColor *contentTextColor;

/** 列宽 */
@property (nonatomic,assign) CGFloat LieWidth;

//默认选择的哪一个
- (void)MoRenSelectedRowWithObject:(id)object;


@end
