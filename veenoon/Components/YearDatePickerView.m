//
//  YearDatePickerView.m
//  iMokard
//
//  Created by steven on 1/5/10.
//  Copyright 2009 Steven Sun. All rights reserved.
//

#import "YearDatePickerView.h"
#import "UIButton+Color.h"


@interface YearDatePickerView () {
   
    UIDatePicker         *_myPickerView;
    UIDatePicker         *_myPickerView1;
    NSMutableDictionary *_values;

    UIImageView         *_background;
    
    UIButton *btnSave;
    int _cellWidth;
}

@end

@implementation YearDatePickerView
@synthesize _selectionBlock;


- (id)initWithFrame:(CGRect)frame withGrayOrLight:(NSString*)grayOrLight {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
       

        _background = [[UIImageView alloc] initWithFrame:self.bounds];
        _background.layer.contentsGravity = kCAGravityResize;
        _background.clipsToBounds = YES;
        if([grayOrLight isEqualToString:@"gray"])
            _background.image = [UIImage imageNamed:@"gray_slide_bg.png"];
        else
        {
            _background.image = [UIImage imageNamed:grayOrLight];
        }
        
        [self addSubview:_background];
        
        _cellWidth = frame.size.width-50;
        
        _myPickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,
                                                                       0,
                                                                       _cellWidth,
                                                                       frame.size.height)];
        _myPickerView.datePickerMode = UIDatePickerModeDateAndTime;
        [self addSubview:_myPickerView];
        [_myPickerView setValue:[UIColor whiteColor] forKey:@"textColor"];
        [_myPickerView setLocale:[NSLocale currentLocale]];

        
        _values = [[NSMutableDictionary alloc] init];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(frame.size.width-50, frame.size.height/2-25, 50, 50);
        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_n.png"]
                 forState:UIControlStateNormal];
        [btnSave setImage:[UIImage imageNamed:@"customer_view_confirm_s.png"] forState:UIControlStateHighlighted];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSave setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
        btnSave.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btnSave addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSave];
        
        
    }
    return self;
}


- (void) confirmAction:(id) sender {
    
    
    [_values setValue:[_myPickerView date] forKey:@"date"];
    if(_selectionBlock)
    {
        _selectionBlock(_values);
    }
    
   
    
}

- (void)dealloc {

}


@end
