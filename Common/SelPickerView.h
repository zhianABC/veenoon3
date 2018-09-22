//
//  SelPickerView.h
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

@protocol SelPickerViewDelegate <NSObject>



@end

typedef void(^SelPickerSelectionBlock)(NSDictionary* values);


@interface SelPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    SelPickerSelectionBlock _selectionBlock;
}
@property (nonatomic, copy) SelPickerSelectionBlock _selectionBlock;

@property (nonatomic, strong) NSArray *_pickerDataArray;
@property (nonatomic, weak) id  <SelPickerViewDelegate> delegate_;

@property (nonatomic, strong) NSString *_unitString;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void) showInView:(UIView*)view;

@end
