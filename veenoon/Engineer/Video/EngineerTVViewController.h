//
//  EngineerTVViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VTVSet.h"

@interface EngineerTVViewController : BaseViewController {
    NSMutableArray *_videoTVArray;
    
    VTVSet *_currentObj;
}
@property (nonatomic,strong) NSArray *_videoTVArray;
@property (nonatomic,strong) VTVSet *_currentObj;
@end
