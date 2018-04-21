//
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioEWirlessMike;
@interface WirlessYaoBaoViewSettingsView : UIView
{
    
}
@property (nonatomic, assign) int _numOfChannel;
@property (nonatomic, strong) AudioEWirlessMike *_audioMike;
- (void) layoutFooter;
- (void) showData;
@end
