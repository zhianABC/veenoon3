//
//  XDPickView.m
//  HEAL
//
//  Created by 窦心东 on 2017/3/29.
//  Copyright © 2017年 窦心东. All rights reserved.
//

#import "XDPickView.h"

@interface XDPickView ()<UIPickerViewDataSource,UIPickerViewDelegate>
/** 数组 */
@property (nonatomic,strong) NSMutableArray *proTitleList;
/** // 选择框
 UIPickerView *pickerView  */
@property (nonatomic,strong) UIPickerView *pickerView ;


@end

@implementation XDPickView

-(NSMutableArray *)proTitleList{
    if (_proTitleList == nil) {
        _proTitleList = [NSMutableArray array];
        for (int i = 100; i<500; i++) {
            [_proTitleList addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _proTitleList;
}
-(UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    
    //初始化
    [self creatPickView];
}
//创建pickview
- (void)creatPickView{
    
    [self addSubview:self.pickerView];
    
}
//设置PickView的背景颜色
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    if (_backgroundColor) {
        self.pickerView.backgroundColor = _backgroundColor;
    } else {
        self.pickerView.backgroundColor = [UIColor redColor];
    }
    
}
#pragma mark - 设置字体颜色
-(void)setContentTextColor:(UIColor *)contentTextColor{

    _contentTextColor = contentTextColor;
    if (_contentTextColor == nil) {
        _contentTextColor = [UIColor whiteColor];
    }
}
#pragma mark - 设置数据源数组
-(void)setPickViewTextArray:(NSMutableArray *)pickViewTextArray{
    _pickViewTextArray = pickViewTextArray;
    if (_pickViewTextArray == nil) {
        _pickViewTextArray = self.proTitleList;
    }
}
-(void)setLieWidth:(CGFloat)LieWidth{

    _LieWidth = LieWidth;
    if (_LieWidth < 40) {
        _LieWidth = 180;
    }
}
#pragma mark - 默认选中的是
- (void)MoRenSelectedRowWithObject:(id)object{
    if (object == nil) {
        return;
    }
    NSInteger row = [_pickViewTextArray indexOfObject:object];
    [self.pickerView selectRow:row inComponent:0 animated:YES];
}
#pragma mark - 改变分割线的颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor clearColor];//取消分割线
        }
    }
    //设置文字的属性
    UILabel *Label = [UILabel new];
    Label.textAlignment = NSTextAlignmentCenter;
    Label.text = _pickViewTextArray[row];
    Label.textColor = _contentTextColor?_contentTextColor:[UIColor whiteColor];
    
    return Label;
}
#pragma mark - UIPickerViewDataSource 相关代理
#pragma Mark -- 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
#pragma mark - pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _pickViewTextArray.count;
}
#pragma mark - UIPickerViewDelegate 相关代理方法
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return _LieWidth?_LieWidth:180;
}
#pragma mark - 返回当前行cell的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return _pickViewTextArray[row];
    
}
#pragma mark - 返回选中的行didSelectRow
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString  *selectRowString = _pickViewTextArray[row];
    NSLog(@"选中的是====%@",selectRowString);
    if ([self.delegate respondsToSelector:@selector(PickerSelectorIndixString:)]) {
        //如果我的代理响应这个方法的话 就去调用这个代理方法
        [self.delegate PickerSelectorIndixString:selectRowString];
    }
    
}
- (void)dealloc{
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
