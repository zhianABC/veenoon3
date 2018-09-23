//
//  DevicePlugButton.m
//  veenoon
//
//  Created by chen jack on 2018/5/6.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DevicePlugButton.h"
#import "BasePlugElement.h"
#import "RegulusSDK.h"

@implementation DevicePlugButton

@synthesize _mydata;
@synthesize _isEdited;
@synthesize _plug;
@synthesize _deviceType;
@synthesize _deviceTypeName;
@synthesize _drNameLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) addMyObserver{
    
    if(_mydata && [_mydata objectForKey:@"class"])
    {
        id key = [NSString stringWithFormat:@"%d-%@",
                  [[_mydata objectForKey:@"id"] intValue],
                  [_mydata objectForKey:@"class"]];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(revNotifyChangedMyBg:)
                                                 name:key
                                               object:nil];
        
    }
}

- (void) revNotifyChangedMyBg:(NSNotification*)sender{
    
    NSDictionary *obj = sender.object;
    if(obj)
    {
        self._drNameLabel.text = [obj objectForKey:@"name"];
        
    }
    else
    {
        [self setEditChanged];
    }
}

- (void) setEditChanged{
    
    if(_mydata && [_mydata objectForKey:@"icon_sel"])
    {
        UIImage *image = [UIImage imageNamed:[_mydata objectForKey:@"icon_sel"]];
        
        if(image)
            [self setBackgroundImage:image
                            forState:UIControlStateNormal];
        self._drNameLabel.textColor = NEW_ER_BUTTON_SD_COLOR;
        
    }
    
    _isEdited = YES;
    _plug._isSelected = YES;
}

- (void) refreshPlugName{
    
    if(_plug.config && _plug._driver == nil)
    {
        int driver_id = [[_plug.config objectForKey:@"driver_id"] intValue];
        [[RegulusSDK sharedRegulusSDK] GetRgsObjectByID:driver_id completion:^(BOOL result, id RgsObject, NSError *error) {
            
            RgsDriverObj * ndr = RgsObject;
            _plug._name = ndr.name;
            _drNameLabel.text = ndr.name;
            
        }];
    }
}

- (void) removeMyObserver{
    
    self._plug = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
