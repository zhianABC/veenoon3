//
//  CheckButton.h
//  hkeeping
//
//  Created by apple on 2/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CheckButtonCallbackBlock)(int tagIndex, id obj);

@protocol CheckButtonDelegate <NSObject>

@optional
- (void) didFinishEdit:(UITextField*)textFeild;

@end

@interface CheckButton : UIView
{
    UIImageView *_icon;
    
    
    UIButton    *_btn;
    
    UIImage *_normalImg;
    UIImage *_downImg;
    
    int _tagIndex;
    
    CheckButtonCallbackBlock checkbuttonClickedCallbackBlock;
}
@property (nonatomic, strong) UIImage *_normalImg;
@property (nonatomic, strong) UIImage *_downImg;
@property (nonatomic, weak) id <CheckButtonDelegate> delegate;
@property (nonatomic, readonly) UITextField *_title;

- (id) initWithIcon:(UIImage*)normal down:(UIImage*)down title:(NSString*)title frame:(CGRect)frame;
- (id) initWithEditTitleWithIcon:(UIImage*)normal down:(UIImage*)down title:(NSString*)title frame:(CGRect)frame;

- (void) setClickedCallbackBlock:(CheckButtonCallbackBlock)callback;

- (void) check;
- (void) uncheck;

- (void) setTextFiledCallbackDelegate:(id)object;

- (NSString*) getTextValue;

- (void) allowUnCheck:(BOOL)allowed;

- (BOOL) isChecked;

@end
