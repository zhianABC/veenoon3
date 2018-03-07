//
//  PickerView.h
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

@protocol CustomPickerViewDelegate <NSObject>

@optional
- (void) didChangedPickerValue:(NSDictionary*)value;
- (void) didConfirmPickerValue:(NSString*) pickerValue;
- (void) didScrollPickerValue:(NSString*) pickerValue;
@end

typedef void(^CustomPickerSelectionBlock)(NSDictionary* values);


@interface CustomPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    CustomPickerSelectionBlock _selectionBlock;
}
@property (nonatomic, copy) CustomPickerSelectionBlock _selectionBlock;

@property (nonatomic, strong) NSArray *_pickerDataArray;
@property (nonatomic, strong) NSMutableArray *_pickerLabelArray;
@property (nonatomic, weak) id  <CustomPickerViewDelegate> delegate_;
@property (nonatomic) float fontSize;
@property (nonatomic, strong) NSString *_unitString;
@property (nonatomic, strong) UIColor *_selectColor;
@property (nonatomic, strong) UIColor *_rowNormalColor;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;
- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight;
- (void)removeArray;
@end
