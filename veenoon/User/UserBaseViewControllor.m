//
//  UserBaseViewControllor.m
//  veenoon
//
//  Created by 安志良 on 2018/3/20.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserBaseViewControllor.h"

@implementation UserBaseViewControllor

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = USER_GRAY_COLOR;
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63)];
    _topBar.backgroundColor = USER_GRAY_COLOR;
    [self.view addSubview:_topBar];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    titleIcon = [[UIImageView alloc] init];
    [_topBar addSubview:titleIcon];
    titleIcon.frame = CGRectMake(55, 35, 16, 19);
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 300, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_topBar addSubview:titleLabel];
    
    centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleLabel.textColor = [UIColor whiteColor];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_topBar addSubview:centerTitleLabel];
}

- (void) setCenterTitle:(NSString*)centerTitle {
    centerTitleLabel.text = centerTitle;
}

- (void) setTitleAndImage:(NSString*)imageName withTitle:(NSString*)title {
    UIImage *image = [UIImage imageNamed:imageName];
    titleIcon.image = image;
    
    titleLabel.text = title;
}

- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font //根据字符串、字体计算长度
{
    CGSize constraint = CGSizeMake(1000.0f, 20000.0f);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@
                                          {
                                          NSFontAttributeName:font
                                          }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
    
}

@end
