//
//  YinPinProcessCodeUIView.h
//  veenoon
//
//  Created by 安志良 on 2018/3/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebClient.h"
#import "AudioEProcessor.h"

@interface YinPinProcessCodeUIView : UIView {
    WebClient *_autoClient;
    UILabel *_networkStatus;
    AudioEProcessor *_processor;
}
- (id)initWithFrame:(CGRect)frame withProxy:(AudioEProcessor*) processor;
@end
