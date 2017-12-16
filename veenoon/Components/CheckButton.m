//
//  CheckButton.m
//  hkeeping
//
//  Created by apple on 2/22/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "CheckButton.h"
#import "UIButton+Color.h"

@interface CheckButton () <UITextFieldDelegate>
{
    UITextField     *_title;
    
    UIImageView     *_bg;
    
    BOOL            _isAllowed;
}
@end

@implementation CheckButton
@synthesize _normalImg;
@synthesize _downImg;
@synthesize delegate;
@synthesize _title;

- (id) initWithIcon:(UIImage*)normal down:(UIImage*)down title:(NSString*)title frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //self.backgroundColor = [UIColor redColor];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self addSubview:_icon];
        _icon.image = normal;
        _icon.layer.contentsGravity = kCAGravityCenter;
        
        _title = [[UITextField alloc] initWithFrame:CGRectMake(40-5, 0, frame.size.width-40, 40)];
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        _title.textColor = COLOR_TEXT_A;
        _title.userInteractionEnabled = NO;
        _title.font = [UIFont systemFontOfSize:13];
        
        self._normalImg = normal;
        self._downImg = down;
        
        _title.text = title;
        
        _btn = [UIButton buttonWithColor:nil selColor:nil];
        _btn.frame = self.bounds;
        [_btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _tagIndex = 0;
        
    }
    return self;
}

- (id) initWithEditTitleWithIcon:(UIImage*)normal down:(UIImage*)down title:(NSString*)title frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        int h = frame.size.height;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, h, h)];
        [self addSubview:_icon];
        _icon.image = normal;
        _icon.layer.contentsGravity = kCAGravityCenter;
        
        _title = [[UITextField alloc] initWithFrame:CGRectMake(60, 1, frame.size.width-80, h-2)];
        _title.backgroundColor = [UIColor clearColor];
        _title.delegate = self;
        _title.textColor = COLOR_TEXT_A;
        _title.font = [UIFont systemFontOfSize:15];
        _title.returnKeyType = UIReturnKeyDone;
        _title.userInteractionEnabled = NO;
        
        _bg = [[UIImageView alloc] initWithFrame:CGRectMake(60-5, 1, CGRectGetWidth(_title.frame)+10, h-2)];
        _bg.backgroundColor = RGB(200, 200, 200);
        _bg.layer.cornerRadius = 2;
        _bg.clipsToBounds = YES;
        _bg.hidden = YES;
        [self addSubview:_bg];
        
        [self addSubview:_title];

        self._normalImg = normal;
        self._downImg = down;
        
        _title.text = title;
        
        _btn = [UIButton buttonWithColor:nil selColor:nil];
        _btn.frame = CGRectMake(0, 0, frame.size.width, h);
        [_btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _tagIndex = 0;
        
    }
    return self;
}

- (void) allowUnCheck:(BOOL)allowed{
    
    _isAllowed = allowed;
}


- (void) setTextFiledCallbackDelegate:(id)object{
    
    //_title.delegate  = object;
    self.delegate = object;
    
    if(object == nil)
    {
        _title.userInteractionEnabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _bg.hidden = NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _bg.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(delegate && [delegate respondsToSelector:@selector(didFinishEdit:)])
    {
        [delegate didFinishEdit:textField];
    }
    
    return YES;
}

- (void) setClickedCallbackBlock:(CheckButtonCallbackBlock)callback
{
	checkbuttonClickedCallbackBlock = [callback copy];
}

- (void) check{
    
    _tagIndex = 1;
    _icon.image = _downImg;
    //_bg.hidden = NO;
}

- (void) uncheck{
    
    _tagIndex = 0;
    _icon.image = _normalImg;
    //_bg.hidden = YES;
    
}
- (void) buttonAction:(id)sender{
    
    if(!_isAllowed)
    {
        if(_tagIndex == 1)
            return;
    }
    
    if(_tagIndex == 0)
    {
        _tagIndex = 1;
        _icon.image = _downImg;
        //_bg.hidden = NO;
    }
    else
    {
        _tagIndex = 0;
        _icon.image = _normalImg;
        //_bg.hidden = YES;
    }
    
    if(checkbuttonClickedCallbackBlock)
    {
        checkbuttonClickedCallbackBlock(_tagIndex, self);
    }
}

- (NSString*) getTextValue{
    
    return _title.text;
}

- (BOOL) isChecked{
    
    if(_tagIndex)
        return YES;
    
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
