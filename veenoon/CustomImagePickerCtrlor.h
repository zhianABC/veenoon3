//
//  CustomImagePickerCtrlor.h
//  Untitled
//
//  Created by mac on 10-5-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//PS: only can support the mask view for camera, about album, can not add mask on it.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@class CustomImagePickerCtrlor;
@protocol CustomImagePickerDelegate <NSObject>
@optional
- (void)customImagePickerController:(CustomImagePickerCtrlor *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)customImagePickerControllerDidCancel:(CustomImagePickerCtrlor *)picker;
@end


@interface CustomImagePickerCtrlor : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	

}

@property (assign) id cdelegate;


-(id)initWithSourceType:(UIImagePickerControllerSourceType)sType maskView:(UIView*)maskView delegate:(id)dele;                                //if no mask view, the default effect is no mask
-(id)initWithSourceType:(UIImagePickerControllerSourceType)sType maskImage:(UIImage*)maskImage maskOrigion:(CGPoint)origion delegate:(id)dele; //to use this interface, you should have maskImage


@end
