//
//  CustomPickerView.m
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

#import "CustomPickerView.h"
#import "UIButton+Color.h"


@interface CustomPickerView () {
    UIPickerView    *_myPickerView;
    
    
    
    BOOL            _isShowing;
    
    NSInteger       _comSelected;
    NSInteger       _rowSelected;
    
    UIImageView  *_background;
    
    UIColor *_selectColor;
    UIColor *_rowNormalColor;
    
    UIButton *btnSave;
    
    int _cellWidth;
}
@property (nonatomic, strong) NSMutableDictionary *_values;
@end

@implementation CustomPickerView
@synthesize _pickerDataArray;
@synthesize delegate_;
@synthesize _selectionBlock;
@synthesize _selectColor;
@synthesize _rowNormalColor;
@synthesize fontSize;
@synthesize _unitString;
@synthesize _values;

- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        //self.backgroundColor = [UIColor redColor];
        
        self._selectColor = RGB(230, 151, 50);
        self._rowNormalColor = SINGAL_COLOR;
    
        
        _cellWidth = frame.size.width;
        
        if(_cellWidth < 320)
        {
            _cellWidth = 320;
        }
        int xx = (frame.size.width - _cellWidth)/2.0;
        
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(xx, 0,
                                                                       _cellWidth,
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
        
          self._values = [[NSMutableDictionary alloc] init];
        
//        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnSave.frame = CGRectMake(frame.size.width-25, frame.size.height/2-13, 25, 25);
//        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_n.png"] forState:UIControlStateNormal];
//        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_s.png"] forState:UIControlStateHighlighted];
//        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btnSave setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
//        btnSave.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [btnSave addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnSave];
//
        
    }
    return self;
}

- (id)initWithConfirm:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self._selectColor = RGB(230, 151, 50);
        self._rowNormalColor = SINGAL_COLOR;
        
        _cellWidth = frame.size.width;
        
        if(_cellWidth < 320)
        {
            _cellWidth = 320;
        }
        int xx = (frame.size.width - _cellWidth)/2.0;
        
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(xx, 0,
                                                                       _cellWidth,
                                                                       frame.size.height-44)];
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
        
        self._values = [[NSMutableDictionary alloc] init];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(xx, frame.size.height-44, _cellWidth, 44);
        [btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnSave setTitle:@"确定" forState:UIControlStateNormal];
        btnSave.titleLabel.font = [UIFont systemFontOfSize:16];
        [btnSave addTarget:self
                    action:@selector(confirmAction:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSave];
        

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
    
    [self removeFromSuperview];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _comSelected = component;
    _rowSelected = row;
    
    [_myPickerView reloadComponent:0];
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    [_values setObject:[values objectAtIndex:row]
                forKey:[NSNumber numberWithInteger:component]];
    
    [_values setObject:[NSNumber numberWithInteger:row]
                forKey:@"row"];
    
    
    [_myPickerView selectRow:row inComponent:component animated:YES];
}

- (NSDictionary*) resultOfCurrentValue{
    
    return _values;
}


#pragma mark -
#pragma mark PickerView delegate methods
#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    NSDictionary *section = [_pickerDataArray objectAtIndex:component];
    NSArray *values = [section objectForKey:@"values"];
    
    [_values setObject:[values objectAtIndex:row]
                forKey:[NSNumber numberWithInteger:component]];
    
    [_values setObject:[NSNumber numberWithInteger:row]
                forKey:@"row"];
    
    _rowSelected = row;
    
    [pickerView reloadComponent:component];
    
    NSString *value = [values objectAtIndex:row];
    
    if ([self.delegate_ respondsToSelector:@selector(didScrollPickerValue:)]) {
        [self.delegate_ didScrollPickerValue:value];
    }
    
    if(_selectionBlock)
    {
        _selectionBlock(_values);
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
    return 44.0;
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
    
    
    NSArray *values = [section objectForKey:@"values"];
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, componentWidth-10, 30)];
    tL.backgroundColor = [UIColor clearColor];
    tL.textAlignment = NSTextAlignmentCenter;
    
    id valueRow = [values objectAtIndex:row];
    if([valueRow isKindOfClass:[NSString class]])
    {
        tL.text = valueRow;
    }
    else if([valueRow isKindOfClass:[NSDictionary class]])
    {
        tL.text = [valueRow objectForKey:@"title"];
    }
    
    //tL.textAlignment = NSTextAlignmentLeft;
    
    if (_rowSelected == row) {
        tL.textColor = _selectColor;
    } else {
        tL.textColor = _rowNormalColor;
    }
    if (fontSize > 1) {
        tL.font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        
    }
    
    _unitString = tL.text;
    
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
