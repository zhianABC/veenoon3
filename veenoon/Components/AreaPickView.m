//
//  AreaPickView.m
//  AreaPickDemo
//


#import "AreaPickView.h"

//当前tableview所处的状态
NS_ENUM(NSInteger,PickState) {
    ProvinceState,//选择省份状态
    CityState,//选择城市状态
    DistrictState//选择区、县状态
};

@interface AreaPickView ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedDis;
}

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation AreaPickView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        [self initData];
        [self setUI];
        //首先赋值为选择省份状态
        PickState = ProvinceState;
    }
    return self;
}
#pragma mark 读取plist城市数据文件
-(void)initData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    //取出省份数据
    _provinceArr = [[NSArray alloc] initWithArray: provinceTmp];
    
}

-(void)setUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _provinceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _provinceBtn.frame = CGRectMake(0, 10, self.frame.size.width/3, 30);
    [_provinceBtn addTarget:self action:@selector(provinceAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_provinceBtn];
    
    _cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cityBtn.frame = CGRectMake(self.frame.size.width/3, 10, self.frame.size.width/3, 30);
    [_cityBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cityBtn];

    _districtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _districtBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_districtBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _districtBtn.frame = CGRectMake(self.frame.size.width/3 * 2, 10, self.frame.size.width/3, 30);
    [_districtBtn addTarget:self action:@selector(districtAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_districtBtn];
    
    _selectLine = [[UIView alloc]initWithFrame:CGRectMake(10, 41, 1, 1)];
    _selectLine.backgroundColor = [UIColor blackColor];
    [self addSubview:_selectLine];
    _selectLine.hidden = YES;
    
}

-(void) provinceAction {
    _selectLine.hidden = NO;
    PickState = ProvinceState;
    [_tableView reloadData];
    
    CGFloat width = [self getBtnWidth:_provinceBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((self.frame.size.width/3-width)/2 , 41, width, 1);
    }];

}

-(void) cityAction {
    _selectLine.hidden = NO;
    PickState = CityState;
    [_tableView reloadData];
    CGFloat width = [self getBtnWidth:_cityBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((self.frame.size.width/3-width)/2 + self.frame.size.width/3, 41, width, 1);

    }];
    

}

-(void) districtAction {
    _selectLine.hidden = NO;
    PickState = DistrictState;
    [_tableView reloadData];
    CGFloat width = [self getBtnWidth:_districtBtn];
    
    [UIView animateWithDuration:0.4 animations:^{
        _selectLine.frame = CGRectMake((self.frame.size.width/3-width)/2  + self.frame.size.width * 2/3, 41, width, 1);

    }];

}

-(CGFloat)getBtnWidth:(UIButton *)btn {
    CGRect tmpRect = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
    CGFloat width = tmpRect.size.width;
    return width;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(PickState == ProvinceState) {
        
        return _provinceArr.count;
        
    }else if (PickState == CityState) {
        
        return _cityArr.count;
        
    }else {
        
        return _districtArr.count;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(PickState == ProvinceState) {
        cell.textLabel.text = _provinceArr[indexPath.row];

    }else if(PickState == CityState) {
        cell.textLabel.text = _cityArr[indexPath.row];
    }else {
        cell.textLabel.text = _districtArr[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectLine.hidden = NO;
    if(PickState == ProvinceState) {
        //当tableview所处为省份选择状态时，点击cell 进入城市选择状态
        PickState = CityState;
        selectedProvince = [_provinceArr objectAtIndex: indexPath.row];
        [_provinceBtn setTitle:selectedProvince forState:UIControlStateNormal];

        CGFloat width = [self getBtnWidth:_provinceBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((self.frame.size.width/3-width)/2, 41, width, 1);
        }];

        
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)indexPath.row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        //取出城市数据
        _cityArr = [[NSArray alloc] initWithArray: array];

    } else if (PickState == CityState) {
        PickState = DistrictState;
        [_cityBtn setTitle:_cityArr[indexPath.row] forState:UIControlStateNormal];
        
        CGFloat width = [self getBtnWidth:_cityBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((self.frame.size.width/3-width)/2 + self.frame.size.width/3, 41, width, 1);
            
        }];

        
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[_provinceArr indexOfObject:selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: indexPath.row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        //取出区、县数据
        _districtArr = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        
    } else {
        [_districtBtn setTitle:_districtArr[indexPath.row] forState:UIControlStateNormal];
        
        CGFloat width = [self getBtnWidth:_districtBtn];
        
        [UIView animateWithDuration:0.4 animations:^{
            _selectLine.frame = CGRectMake((self.frame.size.width/3-width)/2 + self.frame.size.width * 2/3, 41, width, 1);
            
        }];
        
        [self.delegate performSelector:@selector(updateAreaInfo) withObject:nil];
    }

    [_tableView reloadData];
}
@end

