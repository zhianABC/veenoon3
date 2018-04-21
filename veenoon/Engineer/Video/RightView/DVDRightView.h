//
//  DVDRightView.h
//  veenoon
//
//  Created by 安志良 on 2018/2/19.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDVDPlayerSet.h"
@interface DVDRightView : UIView {
    VDVDPlayerSet *_currentObj;
}
@property(nonatomic, strong) VDVDPlayerSet *_currentObj;

-(void) refreshView:(VDVDPlayerSet*) dvdPlayerSet;
@end
