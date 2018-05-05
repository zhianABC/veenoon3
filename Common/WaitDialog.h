//
//  WaitDialog.h
//  
//
//  Created by steven on 4/8/09.
//  Copyright 2009 steven. All rights reserved.
//


@interface WaitDialog : UIView {
    
   

}

+ (WaitDialog *)sharedDialog;
+ (WaitDialog *)sharedAlertDialog;
+ (WaitDialog *)sharedRoundImageDialog;

- (void) setTitle:(NSString *)title;

- (void) startLoading;
- (void) endLoading;

- (void) animateShow;

- (void) showRing;
- (void) endRing;

@end

