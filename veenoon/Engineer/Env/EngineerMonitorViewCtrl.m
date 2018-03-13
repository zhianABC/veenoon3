//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerMonitorViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "MonitorRightView.h"

@interface EngineerMonitorViewCtrl () <CustomPickerViewDelegate>{
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    BOOL isSettings;
    MonitorRightView *_rightView;
    UIButton *okBtn;
    
    NSMutableArray *cityBtnArray;
}
@end

@implementation EngineerMonitorViewCtrl
@synthesize _monitorRoomList;
@synthesize _number;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    if (_monitorRoomList) {
        [_monitorRoomList removeAllObjects];
    } else {
        _monitorRoomList = [[NSMutableArray alloc] init];
    }
    
    cityBtnArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"北京", @"name",
                                 nil];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"上海", @"name",
                                 nil];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"乌鲁木齐", @"name",
                                 nil];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"齐齐哈尔", @"name",
                                 nil];
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"广州", @"name",
                                 nil];
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大连", @"name",
                                 nil];
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"深圳", @"name",
                                 nil];
    
    [_monitorRoomList addObject:dic1];
    [_monitorRoomList addObject:dic2];
    [_monitorRoomList addObject:dic3];
    [_monitorRoomList addObject:dic4];
    [_monitorRoomList addObject:dic5];
    [_monitorRoomList addObject:dic6];
    [_monitorRoomList addObject:dic7];
    
    [super setTitleAndImage:@"info_day_s.png" withTitle:@"监控"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _selectSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSysBtn.frame = CGRectMake(50, 100, 80, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"001" forState:UIControlStateNormal];
    _selectSysBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,_selectSysBtn.imageView.bounds.size.width)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width+35,0,0)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    int leftRight = 50;
    int rowGap = 5;
    int top = 10;
    int uiviewWidth = (SCREEN_WIDTH - leftRight*2 -rowGap*2)/3;
    int cellHeight = uiviewWidth -100;
    
    int rowNUmber = (int) [_monitorRoomList count] / 3 + 1;
    
    UIScrollView *_botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight, 150, SCREEN_WIDTH-2*leftRight, SCREEN_HEIGHT - 200)];
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH-2*leftRight, rowNUmber * (cellHeight + rowGap) +10);
    _botomView.scrollEnabled=YES;
    _botomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_botomView];
    
    int index = 0;
    for (NSMutableDictionary *dic in _monitorRoomList) {
        int row = index/3;
        int col = index%3;
        int startX = col*uiviewWidth+col*rowGap;
        int startY = row*cellHeight+rowGap*row+top;
        
        UIView *inputPannel = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, uiviewWidth, cellHeight)];
        inputPannel.tag = index;
        inputPannel.userInteractionEnabled=YES;
        [_botomView addSubview:inputPannel];
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [inputPannel addGestureRecognizer:longPress0];
        
        UIButton *cityBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
        cityBtn.frame = CGRectMake(0, 5, 100, 35);
        cityBtn.layer.cornerRadius = 5;
        cityBtn.layer.borderWidth = 2;
        cityBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        cityBtn.clipsToBounds = YES;
        [cityBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [inputPannel addSubview:cityBtn];
        cityBtn.tag = index;
        [cityBtn addTarget:self action:@selector(cityBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
        [cityBtnArray addObject:cityBtn];
        
        UIImage *roomImage = [dic objectForKey:@"image"];
        if (roomImage == nil) {
            roomImage = [UIImage imageNamed:@"user_monitor_default_n.png"];
        }
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = index;
        [inputPannel addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(0, 45, uiviewWidth, cellHeight-40);
        roomeImageView.userInteractionEnabled=YES;
        
        UIButton *zoomoutBtn = [UIButton buttonWithColor:nil selColor:nil];
        zoomoutBtn.tag = index;
        zoomoutBtn.frame = CGRectMake(uiviewWidth - 50, cellHeight-30, 50, 30);
        [zoomoutBtn setImage:[UIImage imageNamed:@"user_monitor_zoomout_n.png"] forState:UIControlStateNormal];
        [zoomoutBtn setImage:[UIImage imageNamed:@"user_monitor_zoomout_s.png"] forState:UIControlStateHighlighted];
        zoomoutBtn.tag = index;
        [zoomoutBtn addTarget:self action:@selector(zoomoutAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [inputPannel addSubview:zoomoutBtn];
        
        index++;
    }
}

- (void) longPressed0:(id)sender {
    UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
    int index = (int)viewRecognizer.view.tag;
    if (index == [self._monitorRoomList count]) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入监控地名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"监控地名称";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSString *scenarioName = envirnmentNameTextField.text;
        if (scenarioName && [scenarioName length] > 0) {
            NSMutableDictionary *scenarioDic = [self._monitorRoomList objectAtIndex:index];
            UIButton *scenarioLabel = [cityBtnArray objectAtIndex:index];
            
            [scenarioDic setObject:scenarioName forKey:@"name"];
            [scenarioLabel setTitle:scenarioName forState:UIControlStateNormal];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void) zoomoutAction:(id)sender{
    
}
- (void) cityBtnAction:(id)sender{
    
}

- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 100) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 7; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"00%d", i]];
    }
    
    _customPicker._pickerDataArray = @[@{@"values":arr}];
    
    
    _customPicker._selectColor = [UIColor orangeColor];
    _customPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_customPicker];
    _customPicker.delegate_ = self;
}

- (void) didConfirmPickerValue:(NSString*) pickerValue {
    if (_customPicker) {
        [_customPicker removeFromSuperview];
    }
    NSString *title =  [@"" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}
- (void) okAction:(id)sender{
    if (!isSettings) {
        _rightView = [[MonitorRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        [self.view addSubview:_rightView];
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end









