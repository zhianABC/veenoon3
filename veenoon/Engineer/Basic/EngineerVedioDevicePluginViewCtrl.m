//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerVedioDevicePluginViewCtrl.h"
#import "EngineerEnvDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"

@interface EngineerVedioDevicePluginViewCtrl ()<CenterCustomerPickerViewDelegate> {
    IconCenterTextButton *_dianyuanguanliBtn;
    IconCenterTextButton *_shipinbofangBtn;
    IconCenterTextButton *_shexiangjiBtn;
    IconCenterTextButton *_xinxiheBtn;
    IconCenterTextButton *_yuanchengshixunBtn;
    IconCenterTextButton *_shipinchuliBtn;
    IconCenterTextButton *_pinjiepingBtn;
    IconCenterTextButton *_yejingdianshiBtn;
    IconCenterTextButton *_lubojiBtn;
    IconCenterTextButton *_touyingjiBtn;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
    CenterCustomerPickerView *_numberPicker;
}
@end

@implementation EngineerVedioDevicePluginViewCtrl
@synthesize _meetingRoomDic;
@synthesize _selectedSysDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP+10, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"请配置您的视频管理系统";
    
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
    [okBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int left = 150;
    int rowGap = (SCREEN_WIDTH - left * 2)/5 - 10;
    int height = 200;
    
    _dianyuanguanliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left, height,80, 110)];
    [_dianyuanguanliBtn buttonWithIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_s.png"] text:@"电源管理" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_dianyuanguanliBtn addTarget:self action:@selector(dianyuanguanliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dianyuanguanliBtn];
    
    _shipinbofangBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap, height,80, 110)];
    [_shipinbofangBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_dvd_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_dvd_s.png"] text:@"视频播放" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shipinbofangBtn addTarget:self action:@selector(shipinbofangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shipinbofangBtn];
    
    
    _shexiangjiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*2, height,80, 110)];
    [_shexiangjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_shexiangji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_shexiangji_s.png"] text:@"摄像机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shexiangjiBtn addTarget:self action:@selector(shexiangjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shexiangjiBtn];
    
    _xinxiheBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*3, height,80, 110)];
    [_xinxiheBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_xinxihe_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_xinxihe_s.png"] text:@"信息盒" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_xinxiheBtn addTarget:self action:@selector(xinxiheAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xinxiheBtn];
    
    _yuanchengshixunBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*4, height,80, 110)];
    [_yuanchengshixunBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_yuanchengshixun_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_yuanchengshixun_s.png"] text:@"远程视讯" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yuanchengshixunBtn addTarget:self action:@selector(yuanchengshixunAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yuanchengshixunBtn];
    
    _shipinchuliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*5, height,80, 110)];
    [_shipinchuliBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_shipinchuli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_shipinchuli_s.png"] text:@"视频处理" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shipinchuliBtn addTarget:self action:@selector(shipinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shipinchuliBtn];
    
    _pinjiepingBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left, height+150,80, 110)];
    [_pinjiepingBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_pinjieping_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_pinjieping_s.png"] text:@"拼接屏" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_pinjiepingBtn addTarget:self action:@selector(pinjiepingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pinjiepingBtn];
    
    _yejingdianshiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap, height+150,80, 110)];
    [_yejingdianshiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_yejingdianshi_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_yejingdianshi_s.png"] text:@"液晶电视" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yejingdianshiBtn addTarget:self action:@selector(yejingdianshiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yejingdianshiBtn];
    
    _lubojiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*2, height+150,80, 110)];
    [_lubojiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_luboji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_luboji_s.png"] text:@"录播机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_lubojiBtn addTarget:self action:@selector(lubojiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lubojiBtn];
    
    _touyingjiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*3, height+150,80, 110)];
    [_touyingjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_touyingji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_touyingji_n.png"] text:@"投影机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_touyingjiBtn addTarget:self action:@selector(touyingjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_touyingjiBtn];
    
    int labelStartX = 170;
    int labelStartY = 500;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX-40, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"产品类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+30, 120, 150)];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.fontSize = 14;
    _productTypePikcer._pickerDataArray = @[@{@"values":@[@"电源管理",@"视频播放",@"摄像机",@"信息盒",@"远程视讯",@"视频处理",@"拼接屏",@"液晶电视",@"录播机",@"投影机"]}];
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
    
    _brandPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+200, labelStartY+30, 91, 150)];
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
    
    _productCategoryPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+400, labelStartY+30, 91, 150)];
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
    
    _numberPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+600, labelStartY+30, 91, 150)];
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
    signup.layer.borderColor = [UIColor clearColor].CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"确认" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [signup addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) confirmAction:(id)sender{
    NSString *productType = _productTypePikcer._unitString;
    NSString *brand = _brandPicker._unitString;
    NSString *productCategory = _productCategoryPicker._unitString;
    NSString *number = _numberPicker._unitString;
    
    NSMutableDictionary *audioDic = [[NSMutableDictionary alloc] init];
    [audioDic setObject:productType forKey:@"productType"];
    [audioDic setObject:brand forKey:@"brand"];
    [audioDic setObject:productCategory forKey:@"productCategory"];
    [audioDic setObject:number forKey:@"number"];
    
    NSMutableArray *audioArray = [self._selectedSysDic objectForKey:@"video"];
    if (audioArray == nil) {
        audioArray = [[NSMutableArray alloc] init];
        [self._selectedSysDic setObject:audioArray forKey:@"video"];
    }
    
    [audioArray addObject:audioDic];
}
- (void) touyingjiAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:YES];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}
- (void) lubojiAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:YES];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}
- (void) yejingdianshiAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:YES];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}
- (void) pinjiepingAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:YES];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

- (void) shipinchuliAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:YES];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

- (void) yuanchengshixunAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:YES];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

- (void) xinxiheAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:YES];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

- (void) shexiangjiAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:YES];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

- (void) shipinbofangAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:YES];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

- (void) dianyuanguanliAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:YES];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
}

-(void) didScrollPickerValue:(NSString*)brand {
    if ([@"电源管理" isEqualToString:brand]) {
        [self dianyuanguanliAction:_dianyuanguanliBtn];
    } else if ([@"视频播放" isEqualToString:brand]) {
        [self shipinbofangAction:_shipinbofangBtn];
    } else if ([@"摄像机" isEqualToString:brand]) {
        [self shexiangjiAction:_shexiangjiBtn];
    } else if ([@"信息盒" isEqualToString:brand]) {
        [self xinxiheAction:_xinxiheBtn];
    } else if ([@"远程视讯" isEqualToString:brand]) {
        [self yuanchengshixunAction:_yuanchengshixunBtn];
    } else if ([@"视频处理" isEqualToString:brand]) {
        [self shipinchuliAction:_shipinchuliBtn];
    } else if ([@"拼接屏" isEqualToString:brand]) {
        [self pinjiepingAction:_pinjiepingBtn];
    } else if ([@"液晶电视" isEqualToString:brand]) {
        [self yejingdianshiAction:_yejingdianshiBtn];
    }  else if ([@"录播机" isEqualToString:brand]) {
        [self lubojiAction:_lubojiBtn];
    } else {
        [self touyingjiAction:_touyingjiBtn];
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
    EngineerEnvDevicePluginViewCtrl *ctrl = [[EngineerEnvDevicePluginViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    ctrl._selectedSysDic = self._selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end



