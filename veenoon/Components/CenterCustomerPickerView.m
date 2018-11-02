//
//  CustomPickerView.m
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"


@interface CenterCustomerPickerView () {
    UIPickerView    *_myPickerView;
    
    BOOL            _isShowing;
    
    UIImageView  *_background;
    
    UIColor *_selectColor;
    UIColor *_rowNormalColor;
    
    UIButton *btnSave;
    
    int _cellWidth;
    
    int _rowSelected;
}

@end

@implementation CenterCustomerPickerView
@synthesize _pickerDataArray;
@synthesize delegate_;
@synthesize _selectionBlock;
@synthesize _selectColor;
@synthesize _rowNormalColor;
@synthesize fontSize;
@synthesize _unitString;
@synthesize _values;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        //self.backgroundColor = [UIColor redColor];
        
        self._selectColor = RGB(230, 151, 50);
        self._rowNormalColor = SINGAL_COLOR;
        
        
        _cellWidth = frame.size.width;
        
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0,
                                                                       frame.size.width,
                                                                       frame.size.height)];
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
        _myPickerView.showsSelectionIndicator = YES;
        
        [self addSubview:_myPickerView];
        
        
        for(UIView *speartorView in _myPickerView.subviews)
        {
            if (speartorView.frame.size.height < 2)//取出分割线view
            {
                speartorView.backgroundColor = [UIColor redColor];//隐藏分割线
            }
        }
        
        _values = [[NSMutableDictionary alloc] init];
        
//        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnSave.frame = CGRectMake(frame.size.width-50, frame.size.height/2-25, 50, 50);
//        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_n.png"] forState:UIControlStateNormal];
//        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_s.png"] forState:UIControlStateHighlighted];
//        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btnSave setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
//        btnSave.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [btnSave addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnSave];
        
        
    }
    return self;
}


- (void) confirmAction:(id) sender {
    
    
    if(_selectionBlock)
    {
        _selectionBlock(_values);
    }
    
    if([delegate_ respondsToSelector:@selector(didConfirmPickerValue:)]){
        [delegate_ didConfirmPickerValue:_unitString];
    }
    
    
}


- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _rowSelected = (int) row;
    
    [_myPickerView reloadComponent:0];

    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    if(row < [values count])
    {
        NSString *value = [values objectAtIndex:row];
        
        [_values setObject:@{@"value":value, @"index":[NSNumber numberWithInteger:row]}
                    forKey:[NSNumber numberWithInteger:component]];
        
        self._unitString = value;
    }
    
    [_myPickerView selectRow:row inComponent:component animated:YES];
}


#pragma mark -
#pragma mark PickerView delegate methods
#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    _rowSelected = (int)row;
    
    if(row < [values count])
    {
        NSString *value = [values objectAtIndex:row];
        [_values setObject:@{@"value":value, @"index":[NSNumber numberWithInteger:row]}
                    forKey:[NSNumber numberWithInteger:component]];
        
        self._unitString = value;
        
        [pickerView reloadComponent:component];
        
        if ([self.delegate_ respondsToSelector:@selector(didChangedPickerValue:)]) {
            [self.delegate_ didChangedPickerValue:_values];
        }
        
        
        if ([self.delegate_ respondsToSelector:@selector(didScrollPickerValue:obj:)]) {
            [self.delegate_ didScrollPickerValue:value obj:self];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    
    float width = [[section objectForKey:@"width"] floatValue];
    if(width <= 0)
    {
        width = _cellWidth;
    }
    
    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
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
    {
        componentWidth = _cellWidth;
    }
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, componentWidth, 30)];
    tL.backgroundColor = [UIColor clearColor];
    tL.textAlignment = NSTextAlignmentCenter;
    
    NSArray *values = [section objectForKey:@"values"];
    if(row < [values count])
    {
        
        
        id valueRow = [values objectAtIndex:row];
        if([valueRow isKindOfClass:[NSString class]])
        {
            tL.text = valueRow;
        }
        else if([valueRow isKindOfClass:[NSDictionary class]])
        {
            tL.text = [valueRow objectForKey:@"title"];
        }
        
        if (_rowSelected == row) {
            tL.textColor = _selectColor;
        } else {
            tL.textColor = _rowNormalColor;
        }
        if (fontSize > 1) {
            tL.font = [UIFont boldSystemFontOfSize:fontSize];
        } else {
            
        }
    }
    
    //_unitString = tL.text;
    
    return tL;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_pickerDataArray count];
}

- (void)removeArray {
    btnSave.hidden = YES;
}
- (void)changeFontSize:(float)fontSize {
    
}

- (void)dealloc {
    
    
    
}


@end

