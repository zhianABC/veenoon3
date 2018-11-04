//
//  SelPickerView.m
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

#import "SelPickerView.h"
#import "UIButton+Color.h"


@interface SelPickerView ()
{
    UIPickerView    *_myPickerView;
    UIView          *_pickerContainer;
    
    NSMutableDictionary *_values;
    
    BOOL            _isShowing;
    
    NSInteger       _comSelected;
    NSInteger       _rowSelected;
}

@end

@implementation SelPickerView
@synthesize _pickerDataArray;
@synthesize delegate_;
@synthesize _selectionBlock;

@synthesize _unitString;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        UIView *main = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:main];
        
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedAction:)];
        tapped.cancelsTouchesInView = NO;
        tapped.numberOfTapsRequired = 1;
        [main addGestureRecognizer:tapped];
        
        _pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height,
                                                                    frame.size.width, 260)];
        _pickerContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerContainer];
        
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(frame.size.width/2.0-160, 0, 320, 210)];
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
         _myPickerView.showsSelectionIndicator = YES;
        [_pickerContainer addSubview:_myPickerView];
        
        
        UIButton *btnOK = [UIButton buttonWithColor:THEME_RED_COLOR selColor:nil];
        btnOK.frame = CGRectMake(15, 210+5, SCREEN_WIDTH-30, 40);
        [_pickerContainer addSubview:btnOK];
        btnOK.layer.cornerRadius = 3;
        btnOK.clipsToBounds = YES;
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btnOK addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _values = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void) tappedAction:(id)sender{
    
    [self cancelButtonAction:nil];
}


- (void) doneAction:(id)sender{
    
    _isShowing = NO;
    
    if(_selectionBlock)
    {
        _selectionBlock(_values);
    }
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         _pickerContainer.frame = CGRectMake(0.0, self.frame.size.height,
                                                             self.frame.size.width, 260);
                         
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}

- (void)cancelButtonAction:(id)sender
{
    _isShowing = NO;
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         _pickerContainer.frame = CGRectMake(0.0, self.frame.size.height,
                                                             self.frame.size.width, 260);
                         
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];

}
- (void) showInView:(UIView*)view{
    
    _isShowing = !_isShowing;
    
    if(_isShowing)
    {
        [view addSubview:self];
        
        [UIView animateWithDuration:0.35
                         animations:^{
                             
                             _pickerContainer.frame = CGRectMake(0.0, self.frame.size.height-260,
                                                                 self.frame.size.width, 260);
                             
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                             
                             
                         } completion:^(BOOL finished) {
                             
                             
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.35
                         animations:^{
                             
                             _pickerContainer.frame = CGRectMake(0.0, self.frame.size.height,
                                                                 self.frame.size.width, 260);
                             
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                             
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                         }];
    }
    
    
}




- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component {
	
    _comSelected = component;
    _rowSelected = row;
    
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    [_values setObject:[values objectAtIndex:row]
                forKey:[NSNumber numberWithInteger:component]];
    
    [_myPickerView selectRow:row inComponent:component animated:YES];
}


#pragma mark -
#pragma mark PickerView delegate methods
#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _rowSelected = row;
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    [_values setObject:[values objectAtIndex:row]
                forKey:[NSNumber numberWithInteger:component]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    
    float width = [[section objectForKey:@"width"] floatValue];
    if(width <= 0)
    {
        width = pickerView.frame.size.width;
    }
    
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    return [values count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    
    CGFloat componentWidth = [[section objectForKey:@"width"] floatValue];
    if(componentWidth <= 0)
        componentWidth = 320;
    NSArray *values = [section objectForKey:@"values"];

    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, componentWidth, 50)];
    tL.backgroundColor = [UIColor clearColor];
    
    id valueRow = [values objectAtIndex:row];
    if([valueRow isKindOfClass:[NSString class]])
    {
        tL.text = valueRow;
    }
    else if([valueRow isKindOfClass:[NSDictionary class]])
    {
        if([valueRow objectForKey:@"title"])
            tL.text = [valueRow objectForKey:@"title"];
        else if([valueRow objectForKey:@"name"])
            tL.text = [valueRow objectForKey:@"name"];
    }
    
    tL.textAlignment = NSTextAlignmentCenter;
    tL.textColor = [UIColor blackColor];
    tL.font = [UIFont boldSystemFontOfSize:20];
    
    return tL;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_pickerDataArray count];
}

- (void)dealloc {
  
    
   
}


@end
