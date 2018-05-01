//
//  VVideoProcessSet.h
//  veenoon
//
//  Created by 安志良 on 2018/4/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePlugElement.h"
@interface VVideoProcessSet : BasePlugElement {
    NSMutableArray *_inputArray;
    NSMutableArray *_outputArray;
}
@property (nonatomic,strong) NSMutableArray *_inputArray;
@property (nonatomic,strong) NSMutableArray *_outputArray;
@end
