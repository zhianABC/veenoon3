//
//  OutputScreenView.h
//  veenoon
//
//  Created by chen jack on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutputScreenView : UIView
{
    
    
}
@property (nonatomic, readonly) UILabel *_txtLabel;
@property (nonatomic, strong) NSDictionary *_input;
- (void) fillInputSource;
@end
