//
//  AudioEHand2Hand.h
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"

//手拉手
@interface AudioEHand2Hand : BasePlugElement
{
    
}
@property (nonatomic, assign) int _dbVal;

- (void) initChannels:(int)num;
- (int) channelsCount;
- (NSMutableDictionary *)channelAtIndex:(int)index;

@end
