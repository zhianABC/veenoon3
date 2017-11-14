//
//  WSUser.h
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSUser.h"


@interface WSUser : SSUser
{
    
}
@property (nonatomic, strong) NSDictionary *_potentialDic;
@property (nonatomic, strong) NSDictionary *_company;
@property (nonatomic, strong) NSString *_companyId;
@property (nonatomic, strong) id _recId;

@property (nonatomic, strong) NSDictionary *_posterSum;
@property (nonatomic, strong) NSDictionary *_admTicket;

- (id) initWithDictionary:(NSDictionary*)data;
- (id) initWithWBDataDictionary:(NSDictionary*)data;
- (void) updateWithWBDataDictionary:(NSDictionary*)data;

- (void) postWorkNameCard:(UIImage*)cardImg;

- (void) addToPotentialExhibitor:(int)companyid;

@end
