//
//  LoginViewController.h
//  CMAForiPad
//
//  Created by jack on 12/7/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "BaseViewController.h"


@interface InvitationCodeViewCotroller : BaseViewController <UITextFieldDelegate> {
    
    UILabel *_networkStatus;
    
    WebClient *_autoClient;
}
@property (nonatomic, assign) BOOL showBack;

@end
