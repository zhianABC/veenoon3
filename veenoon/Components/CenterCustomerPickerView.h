//
//  PickerView.h
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

@protocol CenterCustomerPickerViewDelegate <NSObject>

@optional
- (void) didChangedPickerValue:(NSDictionary*)value;
- (void) didConfirmPickerValue:(NSString*) pickerValue;
- (void) didScrollPickerValue:(NSString*) pickerValue;
@end

typedef void(^CustomPickerSelectionBlock)(NSDictionary* values);


@interface CenterCustomerPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    CustomPickerSelectionBlock _selectionBlock;
}
@property (nonatomic, copy) CustomPickerSelectionBlock _selectionBlock;

@property (nonatomic, strong) NSArray *_pickerDataArray;
@property (nonatomic, strong) NSMutableArray *_pickerLabelArray;
@property (nonatomic, weak) id  <CenterCustomerPickerViewDelegate> delegate_;
@property (nonatomic) float fontSize;
@property (nonatomic, strong) NSString *_unitString;
@property (nonatomic, strong) UIColor *_selectColor;
@property (nonatomic, strong) UIColor *_rowNormalColor;
@property (nonatomic, strong) NSMutableDictionary *_values;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)removeArray;
@end

