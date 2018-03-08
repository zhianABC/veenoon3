//
//  YearDatePickerView.h
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//


typedef void(^YDPickerSelectionBlock)(NSDictionary* values);


@interface YearDatePickerView : UIView  {
    
    YDPickerSelectionBlock _selectionBlock;
}
@property (nonatomic, copy) YDPickerSelectionBlock _selectionBlock;

- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight;

@end
