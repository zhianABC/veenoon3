//
//  EngineerVideoProcessViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VVideoProcessSet.h"

@interface EngineerVideoProcessViewCtrl : BaseViewController {
    NSMutableArray *_videoProcessInArray;
    NSMutableArray *_videoProcessOutArray;
    int _inNumber;
    int _outNumber;
    
    VVideoProcessSet *_currentObj;
    
    NSMutableArray *_videoProcessArray;
}
@property (nonatomic,strong) NSMutableArray *_videoProcessInArray;
@property (nonatomic,strong) NSMutableArray *_videoProcessOutArray;
@property (nonatomic,assign) int _inNumber;
@property (nonatomic,assign) int _outNumber;
@property (nonatomic,strong) VVideoProcessSet *_currentObj;
@property (nonatomic,strong) NSArray *_videoProcessArray;

- (void) updateProxyCommandValIsLoaded;


@end
