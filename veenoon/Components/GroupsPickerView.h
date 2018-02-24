//
//  GroupsPickerView.h
//  Hint
//
//  Created by jack on 1/5/18.
//  Copyright 2018 jack chen. All rights reserved.
//


typedef void(^GroupsPickerSelectionBlock)(NSDictionary* values);

@protocol GroupsPickerViewDelegate <NSObject>

@optional
- (void) didConfirmPickerValue:(NSString*) pickerValue;


@end

@interface GroupsPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    GroupsPickerSelectionBlock _selectionBlock;
}
@property (nonatomic, copy) GroupsPickerSelectionBlock _selectionBlock;

@property (nonatomic, strong) NSArray *_gdatas;

@property (nonatomic, strong) UIColor *_selectColor;
@property (nonatomic, strong) UIColor *_rowNormalColor;

@property (nonatomic, weak) id  <GroupsPickerViewDelegate> delegate_;

- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;


@end
