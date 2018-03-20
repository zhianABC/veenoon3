//
//  UserBaseViewControllor.h
//  veenoon
//
//  Created by 安志良 on 2018/3/20.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBaseViewControllor : UIViewController {
    UIImageView *titleIcon;
    UILabel *titleLabel;
    
    UIView *_topBar;
    
    UILabel *centerTitleLabel;
}
- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font; //根据字符串、字体计算长度
- (void) setTitleAndImage:(NSString*)imageName withTitle:(NSString*)title;
- (void) setCenterTitle:(NSString*)centerTitle;
@end
