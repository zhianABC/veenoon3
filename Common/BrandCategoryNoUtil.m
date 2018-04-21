//
//  BrandCategoryNoUtil.m
//  veenoon
//
//  Created by 安志良 on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "BrandCategoryNoUtil.h"

@implementation BrandCategoryNoUtil
+(NSString*) generatePickerValue:(NSString*)brand withCategory:(NSString*) category withNo:(NSString*)number {
    NSString *firstString = [brand stringByAppendingString:HENG_XIAN];
    NSString *secondString = [firstString stringByAppendingString:category];
    NSString *thirdString = [secondString stringByAppendingString:HENG_XIAN];
    NSString *fourthString = [thirdString stringByAppendingString:number];
    
    return fourthString;
}
@end
