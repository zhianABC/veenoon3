//
//  WSUser.h
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

typedef void(^WSCodeBlock)(id object);


@interface WSCode : NSObject
{
    WSCodeBlock complete;
}
@property (nonatomic, copy) WSCodeBlock complete;

- (id) initWithDictionary:(NSDictionary*)data;

- (void) submit;

@end
