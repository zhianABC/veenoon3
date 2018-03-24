//
//  Groups2PickerView.h
//  Hint
//
//  Created by jack on 1/5/18.
//  Copyright 2018 jack chen. All rights reserved.
//


typedef void(^Groups2PickerSelectionBlock)(NSDictionary* values);

@protocol Groups2PickerViewDelegate <NSObject>

@optional
- (void) didConfirmPickerValue:(NSString*) pickerValue;
- (void) didValueChangedWithGroups2Picker:(NSDictionary*)value;

@end

@interface Groups2PickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    Groups2PickerSelectionBlock _selectionBlock;
}
@property (nonatomic, copy) Groups2PickerSelectionBlock _selectionBlock;

@property (nonatomic, strong) NSArray *_datas;

@property (nonatomic, strong) UIColor *_selectColor;
@property (nonatomic, strong) UIColor *_rowNormalColor;

@property (nonatomic, weak) id  <Groups2PickerViewDelegate> delegate_;

- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)selectRows:(NSArray*)rows;

@end
