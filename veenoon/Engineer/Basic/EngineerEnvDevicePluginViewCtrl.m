//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerEnvDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "EngineerScenarioListViewCtrl.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"

@interface EngineerEnvDevicePluginViewCtrl () <CenterCustomerPickerViewDelegate> {
    IconCenterTextButton *_zhaomingBtn;
    IconCenterTextButton *_kongtiaoBtn;
    IconCenterTextButton *_diandongmadaBtn;
    IconCenterTextButton *_xinfengBtn;
    IconCenterTextButton *_dinuanBtn;
    IconCenterTextButton *_kongqijinghuaBtn;
    IconCenterTextButton *_jingshuiBtn;
    IconCenterTextButton *_jiashiqiBtn;
    IconCenterTextButton *_menjinBtn;
    IconCenterTextButton *_jiankongBtn;
    IconCenterTextButton *_nenghaotongjiBtn;
    
    UIButton *_confirmButton;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
    CenterCustomerPickerView *_numberPicker;
}
@end

@implementation EngineerEnvDevicePluginViewCtrl
@synthesize _meetingRoomDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP+10, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"请配置您的环境管理系统";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"选择您所需要设置的设备类型> 品牌 > 型号> 数量";
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"< 上一步" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"完成配置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int left = 150;
    int rowGap = (SCREEN_WIDTH - left * 2)/5 -10;
    int height = 200;
    
    _zhaomingBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left, height, 80, 110)];
    [_zhaomingBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_zhaoming_s.png"] text:@"照明" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_zhaomingBtn addTarget:self action:@selector(zhaomingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zhaomingBtn];
    
    
    _kongtiaoBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height, 80, 110)];
    [_kongtiaoBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_kongtiao_s.png"] text:@"空调" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_kongtiaoBtn addTarget:self action:@selector(kongtiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kongtiaoBtn];
    
    
    
    _diandongmadaBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*2, height, 80, 110)];
    [_diandongmadaBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_diandongmada_s.png"] text:@"电动马达" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_diandongmadaBtn addTarget:self action:@selector(diandongmadaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_diandongmadaBtn];
    
    
    _xinfengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*3, height, 80, 110)];
    [_xinfengBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_xinfeng_s.png"] text:@"新风" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_xinfengBtn addTarget:self action:@selector(xinfengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xinfengBtn];
    
    
    _dinuanBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*4, height, 80, 110)];
    [_dinuanBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_dire_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_dire_s.png"] text:@"地暖" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_dinuanBtn addTarget:self action:@selector(dinuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dinuanBtn];
    
    _kongqijinghuaBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*5, height, 80, 110)];
    [_kongqijinghuaBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_kongqijignhua_s.png"] text:@"空气净化" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_kongqijinghuaBtn addTarget:self action:@selector(kongqijinghuaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kongqijinghuaBtn];
    
    
    _jiashiqiBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left, height+130, 80, 110)];
    [_jiashiqiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_jiashi_s.png"] text:@"加湿器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_jiashiqiBtn addTarget:self action:@selector(jiashiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jiashiqiBtn];
    
    _jiankongBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height+130, 80, 110)];
    [_jiankongBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_jiankong_s.png"] text:@"监控" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_jiankongBtn addTarget:self action:@selector(jiankongAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jiankongBtn];
    
    _nenghaotongjiBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*2, height+130, 80, 110)];
    [_nenghaotongjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_nenghao_s.png"] text:@"能耗统计" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_nenghaotongjiBtn addTarget:self action:@selector(nenghaotongjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nenghaotongjiBtn];
    
    int labelStartX = 170;
    int labelStartY = 500;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX-40, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"产品类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+30, 120, 150) withGrayOrLight:@"light"];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.fontSize=14;
    _productTypePikcer._pickerDataArray = @[@{@"values":@[@"照明",@"空调",@"电动马达",@"新风",@"地暖",@"空气净化",@"净水",@"加湿器",@"门禁",@"监控",@"能耗统计"]}];
    [_productTypePikcer selectRow:0 inComponent:0];
    _productTypePikcer._selectColor = RGB(253, 180, 0);
    _productTypePikcer._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_productTypePikcer];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+145, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"品牌";
    
    _brandPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+200, labelStartY+30, 91, 150) withGrayOrLight:@"light"];
    [_brandPicker removeArray];
    _brandPicker._pickerDataArray = @[@{@"values":@[@"f",@"e",@"a"]}];
    [_brandPicker selectRow:0 inComponent:0];
    _brandPicker._selectColor = RGB(253, 180, 0);
    _brandPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_brandPicker];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+345, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"型号";
    
    _productCategoryPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+400, labelStartY+30, 91, 150) withGrayOrLight:@"light"];
    [_productCategoryPicker removeArray];
    _productCategoryPicker._pickerDataArray = @[@{@"values":@[@"c",@"v",@"b"]}];
    [_productCategoryPicker selectRow:0 inComponent:0];
    _productCategoryPicker._selectColor = RGB(253, 180, 0);
    _productCategoryPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_productCategoryPicker];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+595, labelStartY, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"数量";
    
    _numberPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+600, labelStartY+30, 91, 150) withGrayOrLight:@"light"];
    [_numberPicker removeArray];
    _numberPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [_numberPicker selectRow:0 inComponent:0];
    _numberPicker._selectColor = RGB(253, 180, 0);
    _numberPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_numberPicker];
    
    UIButton *signup = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:YELLOW_COLOR];
    signup.frame = CGRectMake(SCREEN_WIDTH/2-50, labelStartY+120+25, 100, 40);
    signup.layer.cornerRadius = 5;
    signup.layer.borderWidth = 2;
    signup.layer.borderColor = RGB(0, 89, 118).CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"确认" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
}
- (void) zhaomingAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_s.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) kongtiaoAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_s.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) diandongmadaAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_s.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) xinfengAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_s.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) dinuanAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_s.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) kongqijinghuaAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_s.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) jingshuiAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_s.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) jiashiAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_s.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) menjinAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_s.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) jiankongAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_s.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
- (void) nenghaotongjiAction:(id)sender{
    [_zhaomingBtn setImage:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] forState:UIControlStateNormal];
    [_zhaomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [_kongtiaoBtn setImage:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] forState:UIControlStateNormal];
    [_kongtiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_diandongmadaBtn setImage:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] forState:UIControlStateNormal];
    [_diandongmadaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_xinfengBtn setImage:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] forState:UIControlStateNormal];
    [_xinfengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_dinuanBtn setImage:[UIImage imageNamed:@"engineer_env_dire_n.png"] forState:UIControlStateNormal];
    [_dinuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_kongqijinghuaBtn setImage:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] forState:UIControlStateNormal];
    [_kongqijinghuaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jingshuiBtn setImage:[UIImage imageNamed:@"engineer_env_jingshui_n.png"] forState:UIControlStateNormal];
    [_jingshuiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiashiqiBtn setImage:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] forState:UIControlStateNormal];
    [_jiashiqiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_menjinBtn setImage:[UIImage imageNamed:@"engineer_env_menjin_n.png"] forState:UIControlStateNormal];
    [_menjinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_jiankongBtn setImage:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] forState:UIControlStateNormal];
    [_jiankongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_nenghaotongjiBtn setImage:[UIImage imageNamed:@"engineer_env_nenghao_s.png"] forState:UIControlStateNormal];
    [_nenghaotongjiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
-(void) didScrollPickerValue:(NSString*)brand {
    if ([@"照明" isEqualToString:brand]) {
        [self zhaomingAction:_zhaomingBtn];
    } else if ([@"空调" isEqualToString:brand]) {
        [self kongtiaoAction:_kongtiaoBtn];
    } else if ([@"电动马达" isEqualToString:brand]) {
        [self diandongmadaAction:_diandongmadaBtn];
    } else if ([@"新风" isEqualToString:brand]) {
        [self xinfengAction:_xinfengBtn];
    } else if ([@"地暖" isEqualToString:brand]) {
        [self dinuanAction:_dinuanBtn];
    } else if ([@"空气净化" isEqualToString:brand]) {
        [self kongqijinghuaAction:_kongqijinghuaBtn];
    } else if ([@"净水" isEqualToString:brand]) {
        [self jingshuiAction:_jingshuiBtn];
    } else if ([@"加湿器" isEqualToString:brand]) {
        [self jiashiAction:_jiashiqiBtn];
    } else if ([@"门禁" isEqualToString:brand]) {
        [self menjinAction:_menjinBtn];
    } else if ([@"监控" isEqualToString:brand]) {
        [self jiankongAction:_jiankongBtn];
    } else {
        [self nenghaotongjiAction:_nenghaotongjiBtn];
    }
}

-(void) setBrandValue:(NSString*)brand {
    if (brand == nil) {
        return;
    }
    NSArray *array = _productTypePikcer._pickerDataArray;
    int index = 0;
    for (NSDictionary *dic in array) {
        NSArray *valueArray = [dic objectForKey:@"values"];
        for (NSString * str in valueArray) {
            if ([str isEqualToString:brand]) {
                break;
            }
            index++;
        }
    }
    [_productTypePikcer selectRow:index inComponent:0];
}
- (void) okAction:(id)sender{
    
    EngineerScenarioListViewCtrl *ctrl = [[EngineerScenarioListViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}
- (void) confirmAction:(id)sender{
    EngineerScenarioListViewCtrl *ctrl = [[EngineerScenarioListViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}
- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end




