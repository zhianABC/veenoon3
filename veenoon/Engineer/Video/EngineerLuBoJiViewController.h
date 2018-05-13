//
//  EngineerLuBoJiViewController.h
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DragCellView.h"
#import "VLuBoJiSet.h"

@interface EngineerLuBoJiViewController< DragCellViewDelegate> : BaseViewController {
    NSMutableArray *_lubojiArray;
    
    VLuBoJiSet *_currentObj;
}
@property (nonatomic,strong) NSArray *_lubojiArray;
@property (nonatomic,strong) VLuBoJiSet *_currentObj;
@end
