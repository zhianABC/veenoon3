//
//  GroupsPickerView.m
//  Hint
//
//  Created by jack on 1/5/18.
//  Copyright 2018 jack chen. All rights reserved.
//

#import "GroupsPickerView.h"
#import "UIButton+Color.h"


@interface GroupsPickerView ()
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
    
    int colCount;
}
@property (nonatomic, strong) NSMutableDictionary *_mapRow;

@end

@implementation GroupsPickerView
@synthesize _gdatas;
@synthesize _selectionBlock;

@synthesize _selectColor;
@synthesize _rowNormalColor;

@synthesize delegate_;
@synthesize _mapRow;

- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight {
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
        _cellWidth = frame.size.width - 50;
        CGRect rc = self.bounds;
        rc.size.width = _cellWidth;
        
        colCount = 1;
        
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
        
        self._mapRow = [[NSMutableDictionary alloc] init];
        
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
    
    colCount = (int)[_gdatas count];
    
    
    if(component < [_gdatas count])
    {
        NSArray *arr = [_gdatas objectAtIndex:component];
        
        if(row < [arr count])
        {
            [_myPickerView selectRow:row inComponent:component animated:YES];
        
            [_values setObject:[arr objectAtIndex:row]
                    forKey:[NSNumber numberWithInteger:component]];
        }
    
    }
    
}


- (void) resetValues{
    
  
}

#pragma mark -
#pragma mark PickerView delegate methods
#pragma mark -
#pragma mark PickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component < [_gdatas count])
    {
        NSArray *arr = [_gdatas objectAtIndex:component];
        
        if(row < [arr count])
        {
            [_values setObject:[arr objectAtIndex:row]
                        forKey:[NSNumber numberWithInteger:component]];
            
            [_mapRow setObject:[NSNumber numberWithInt:(int)row]
                        forKey:[NSNumber numberWithInt:(int)component]];
            
            [_myPickerView reloadComponent:component];
        }
        
    }
   
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int width = _cellWidth/colCount;

    return width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component < [_gdatas count])
    {
        NSArray *arr = [_gdatas objectAtIndex:component];
     
        return [arr count];
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *tL  = nil;
    
    if(component < [_gdatas count])
    {
        NSArray *arr = [_gdatas objectAtIndex:component];
        
        CGFloat componentWidth = _cellWidth/colCount;
        tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, componentWidth, 50)];
        tL.backgroundColor = [UIColor clearColor];
        
        
        tL.textAlignment = NSTextAlignmentCenter;
        tL.textColor = [UIColor blackColor];
        tL.font = [UIFont boldSystemFontOfSize:16];
        tL.adjustsFontSizeToFitWidth = YES;
        
        id val = [arr objectAtIndex:row];
        if([val isKindOfClass:[NSString class]])
            tL.text = val;
        else
            tL.text = [val objectForKey:@"name"];
        
        int rowSel = [[_mapRow objectForKey:[NSNumber numberWithInt:(int)component]] intValue];
        if (rowSel == row) {
            tL.textColor = _selectColor;
        } else {
            tL.textColor = _rowNormalColor;
        }
    }
    
   
    
    return tL;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_gdatas count];
}

- (void)dealloc {
    
    
    
}


@end
