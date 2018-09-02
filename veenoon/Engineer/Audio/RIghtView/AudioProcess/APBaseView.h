//
//  APBaseView.h
//  veenoon
//
//  Created by chen jack on 2018/3/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APBaseView : UIView
{
    UIView   *contentView;
    NSMutableArray *_channelBtns;
}
@property (nonatomic, strong) NSMutableArray *_channelBtns;
@property (nonatomic, strong) NSArray *_proxys;

- (void) layoutChannelBtns:(int)num selectedIndex:(int)selectedIndex;

@end
