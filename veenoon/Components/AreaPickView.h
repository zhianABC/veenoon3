//
//  AreaPickView.h
//  AreaPickDemo
//


#import <UIKit/UIKit.h>

@protocol  AreaPickViewDelegate <NSObject>
- (void) updateAreaInfo;
@end

@interface AreaPickView : UIView

@property(nonatomic, weak) id<AreaPickViewDelegate> delegate;

//数据字典
@property (nonatomic, strong)NSDictionary *areaDic;
//省级数组
@property (nonatomic, strong)NSArray *provinceArr;
//城市数组
@property (nonatomic, strong)NSArray *cityArr;
//区、县数组
@property (nonatomic, strong)NSArray *districtArr;

//省份选择Button
@property (nonatomic, strong)UIButton *provinceBtn;
//城市选择Button
@property (nonatomic, strong)UIButton *cityBtn;
//区、县选择Button
@property (nonatomic, strong)UIButton *districtBtn;
//滑动线条
@property (nonatomic, strong)UIView *selectLine;

@end
