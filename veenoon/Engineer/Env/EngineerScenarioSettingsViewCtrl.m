//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerScenarioSettingsViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "EngineerPresetScenarioViewCtrl.h"

@interface EngineerScenarioSettingsViewCtrl () <CustomPickerViewDelegate>{
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    NSMutableArray *_scenarioLabelArray;
}
@end

@implementation EngineerScenarioSettingsViewCtrl
@synthesize _scenarioArray;

- (void) initDat {
    if (_scenarioArray == nil) {
        _scenarioArray = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"场景",@"scenario_name", nil];
    [_scenarioArray addObject:dic];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDat];
    _scenarioLabelArray = [[NSMutableArray alloc] init];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"修改" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(okAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    int startX=80;
    int startY = 120;
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"设置场景";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(portDNSLabel.frame)+15, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"在场景内，可选择您所需要配置的设备";
    
    
    int scenarioSize = (int)[_scenarioArray count] + 1;
    
    int col = 10;
    int leftRightSpace = 100;
    int colGap = 10;
    
    int rowNumber = scenarioSize/col + 1;
    
    int cellWidth = 100;
    int cellHeight = 100;
    int top = 5;
    
    UIScrollView *scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-260)];
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    
    int scrollHeight = rowNumber*cellHeight + (rowNumber-1)*colGap+10;
    
    scroolView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollHeight);
    
    int index = 0;
    for (int i = 0; i < scenarioSize; i++) {
        int rowN = index/col;
        int colN = index%col;
        int startX = colN*cellWidth+colN*colGap+leftRightSpace;
        int startY = rowN*cellHeight+colGap*rowN+top;
        
        UIView *scenarioView = [[UIView alloc] init];
        [scroolView addSubview:scenarioView];
        
        scenarioView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioView.userInteractionEnabled=YES;
        scenarioView.backgroundColor = DARK_BLUE_COLOR;
        scenarioView.layer.cornerRadius = 5;
        scenarioView.layer.borderWidth = 2;
        scenarioView.layer.borderColor = [UIColor clearColor].CGColor;;
        scenarioView.clipsToBounds = YES;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = index;
        [scenarioView addGestureRecognizer:tapGesture];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, scenarioView.frame.size.height/2-15, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [scenarioView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        if ([_scenarioArray count] == index) {
            titleL.text = @"+";
            titleL.textColor  = DARK_BLUE_COLOR;
            
            scenarioView.backgroundColor = [UIColor clearColor];
            scenarioView.layer.cornerRadius = 5;
            scenarioView.layer.borderWidth = 2;
            scenarioView.layer.borderColor = DARK_BLUE_COLOR.CGColor;;
            scenarioView.clipsToBounds = YES;
        } else {
            UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
            longPress0.view.tag = index;
            [scenarioView addGestureRecognizer:longPress0];
            
            NSMutableDictionary *scenarioDic = [self._scenarioArray objectAtIndex:index];
            titleL.text = [scenarioDic objectForKey:@"scenario_name"];
            titleL.textColor  = [UIColor whiteColor];
        }
        
        [_scenarioLabelArray addObject:titleL];
        
        index++;
    }
}
- (void) longPressed0:(id)sender {
    UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
    int index = (int)viewRecognizer.view.tag;
    if (index == [self._scenarioArray count]) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入场景名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"场景名称";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSString *scenarioName = envirnmentNameTextField.text;
        if (scenarioName && [scenarioName length] > 0) {
            NSMutableDictionary *scenarioDic = [self._scenarioArray objectAtIndex:index];
            UILabel *scenarioLabel = [_scenarioLabelArray objectAtIndex:index];
            
            [scenarioDic setObject:scenarioName forKey:@"scenario_name"];
            scenarioLabel.text =scenarioName;
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    UIViewController *target = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[EngineerPresetScenarioViewCtrl class]]) {
            target = vc;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES];
    }
}
- (void) okAction:(id)sender{
    
}
@end










