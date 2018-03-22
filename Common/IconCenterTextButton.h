//
//  IconTextButton.h
//  CMAForiPad
//
//  Created by jack on 2/28/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconCenterTextButton : UIButton
{
    UIImageView *_icon;
    UILabel     *_titleL;
}
@property (nonatomic, strong) UILabel *_titleL;
- (void) buttonWithIcon:(UIImage*)normalIcon selectedIcon:(UIImage*)sIcon text:(NSString*)text normalColor:(UIColor*) normalColor
               selColor:(UIColor*)selColor;
- (void) setBtnHighlited:(BOOL)isSel;
@end

