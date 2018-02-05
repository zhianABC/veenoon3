//
//  Groups2PickerView.m
//  Hint
//
//  Created by jack on 1/5/18.
//  Copyright 2018 jack chen. All rights reserved.
//

#import "Groups2PickerView.h"
#import "UIButton+Color.h"


@interface Groups2PickerView ()
{
    UIPickerView    *_myPickerView;
    UIView          *_pickerContainer;
    
    NSMutableDictionary *_values;
    
    BOOL            _isShowing;
    
    NSInteger       _comSelected;
    NSInteger       _rowAndCom1Selected;
    NSInteger       _rowAndCom2Selected;
    
    UIImageView  *_background;
    
    int          _cellWidth;
    int          _spacex;
    
    UIButton *btnSave;
}

@end

@implementation Groups2PickerView
@synthesize _datas;
@synthesize _selectionBlock;

@synthesize _selectColor;
@synthesize _rowNormalColor;

@synthesize delegate_;

- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight {
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
        _cellWidth = frame.size.width - 50;
        CGRect rc = self.bounds;
        rc.size.width = _cellWidth;
        
        _background = [[UIImageView alloc] initWithFrame:rc];
        _background.layer.contentsGravity = kCAGravityResize;
        _background.clipsToBounds = YES;
        if([grayOrLight isEqualToString:@"gray"])
            _background.image = [UIImage imageNamed:@"gray_slide_bg.png"];
        else
        {
            _background.image = [UIImage imageNamed:grayOrLight];
        }
        
        [self addSubview:_background];
    
        _myPickerView = [[UIPickerView alloc] initWithFrame:rc];
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
        _myPickerView.showsSelectionIndicator = YES;
        [self addSubview:_myPickerView];
        
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(frame.size.width-50, frame.size.height/2-25, 50, 50);
        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_n.png"] forState:UIControlStateNormal];
        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_s.png"] forState:UIControlStateHighlighted];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSave setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
        btnSave.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btnSave addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSave];
        
        
//        UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnOK.frame = CGRectMake(frame.size.width - 60, 10, 60, 40);
//        [_pickerContainer addSubview:btnOK];
//        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
//        [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btnOK.titleLabel.font = [UIFont systemFontOfSize:16];
//        [btnOK addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnCancel.frame = CGRectMake(0, 10, 60, 40);
//        [_pickerContainer addSubview:btnCancel];
//        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
//        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        [btnCancel addTarget:self action:@selector(tappedAction:) forControlEvents:UIControlEventTouchUpInside];

        
        _values = [[NSMutableDictionary alloc] init];
        
        
        self._selectColor = RGB(230, 151, 50);
        self._rowNormalColor = SINGAL_COLOR;
        
    }
    return self;
}

- (void) confirmAction:(id) sender {
    
    
    if(_selectionBlock)
    {
        _selectionBlock(_values);
    }
    
    NSString *_unitString = nil;
    
    NSDictionary *v1 = [_values objectForKey:[NSNumber numberWithInteger:0]];
    NSDictionary *v2 = [_values objectForKey:[NSNumber numberWithInteger:1]];
    
    if(v1 && v2)
    {
        _unitString = [NSString stringWithFormat:@"%@ - %@",
                       [v1 objectForKey:@"name"],
                       [v2 objectForKey:@"name"]];
    }
    
    if([delegate_ respondsToSelector:@selector(didConfirmPickerValue:)]){
        [delegate_ didConfirmPickerValue:_unitString];
    }
    
    
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
    
}

- (void)cancelButtonAction:(id)sender
{
    _isShowing = NO;
    
    
}




- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    [_myPickerView selectRow:0 inComponent:0 animated:YES];
    [_myPickerView selectRow:0 inComponent:1 animated:YES];
    
    if(row < [_datas count])
    {
        [_values setObject:[_datas objectAtIndex:row]
                    forKey:[NSNumber numberWithInteger:component]];
        
        NSDictionary *pro = [_datas objectAtIndex:row];
        NSArray *values = [pro objectForKey:@"subs"];
        
        if([values count])
        {
            NSDictionary *city = [values objectAtIndex:0];
            [_values setObject:city
                        forKey:[NSNumber numberWithInteger:1]];
        }
    }
    
}


- (void) resetValues{
    
    _rowAndCom2Selected = 0;
    
    NSDictionary *pro = [_datas objectAtIndex:_rowAndCom1Selected];
    NSArray *values = [pro objectForKey:@"subs"];
    
    if([values count])
    {
        NSDictionary *city = [values objectAtIndex:0];
        [_values setObject:city
                    forKey:[NSNumber numberWithInteger:1]];
        
    }
}

#pragma mark -
#pragma mark PickerView delegate methods
#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if(component == 0)
    {
        _rowAndCom1Selected = row;
        
        [_values setObject:[_datas objectAtIndex:row]
                    forKey:[NSNumber numberWithInteger:component]];
        
        [self resetValues];
        
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        
    }
    else if(component == 1)
    {
        _rowAndCom2Selected = row;
        
        NSDictionary *pro = [_datas objectAtIndex:_rowAndCom1Selected];
        NSArray *values = [pro objectForKey:@"subs"];
        
        [_values setObject:[values objectAtIndex:row]
                    forKey:[NSNumber numberWithInteger:component]];
        
        [pickerView reloadComponent:1];
    }
   
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int width = _cellWidth/2;

    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        return [_datas count];
    }
    else if(component == 1)
    {
        NSDictionary *pro = [_datas objectAtIndex:_rowAndCom1Selected];
        NSArray *values = [pro objectForKey:@"subs"];
        
        return [values count];
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *tL  = nil;
    if(component == 0)
    {
        CGFloat componentWidth = _cellWidth/2;
        tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, componentWidth, 50)];
        tL.backgroundColor = [UIColor clearColor];
        
        
        tL.textAlignment = NSTextAlignmentCenter;
        tL.textColor = [UIColor blackColor];
        tL.font = [UIFont boldSystemFontOfSize:16];
        tL.adjustsFontSizeToFitWidth = YES;
        
        NSDictionary *pro = [_datas objectAtIndex:row];
        tL.text = [pro objectForKey:@"name"];
        
        if (_rowAndCom1Selected == row) {
            tL.textColor = _selectColor;
        } else {
            tL.textColor = _rowNormalColor;
        }
    }
    else if(component == 1)
    {
        CGFloat componentWidth = _cellWidth/2;
        tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, componentWidth, 50)];
        tL.backgroundColor = [UIColor clearColor];
        
        
        
        
        tL.textAlignment = NSTextAlignmentCenter;
        tL.textColor = [UIColor blackColor];
        tL.font = [UIFont boldSystemFontOfSize:16];
        tL.adjustsFontSizeToFitWidth = YES;
        
        NSDictionary *pro = [_datas objectAtIndex:_rowAndCom1Selected];
        NSArray *values = [pro objectForKey:@"subs"];
        
        NSDictionary *city = [values objectAtIndex:row];
        tL.text = [city objectForKey:@"name"];
        
        if (_rowAndCom2Selected == row) {
            tL.textColor = _selectColor;
        } else {
            tL.textColor = _rowNormalColor;
        }
    }
    
    
    return tL;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (void)dealloc {
    
    
    
}


@end
