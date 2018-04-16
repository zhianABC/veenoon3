//
//  SystemIRSet.h
//  veenoon
//
//  Created by 安志良 on 2018/4/16.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemIRSet : NSObject
@property (nonatomic, strong) NSString *_port;
@property (nonatomic, strong) NSString *_brand;
@property (nonatomic, strong) NSString *_category;
@property (nonatomic, strong) NSMutableDictionary *_studyDic;
@end
