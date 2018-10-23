//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMonitorSettingsViewCtrl.h"
#import "UIButton+Color.h"

@interface UserMonitorSettingsViewCtrl () {
    
    UIButton *_selectSysBtn;
    
    BOOL isSettings;
    UIButton *okBtn;
    
    NSMutableArray *cityBtnArray;
}
@end

@implementation UserMonitorSettingsViewCtrl
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
    
    [_monitorRoomList addObject:dic1];
    [_monitorRoomList addObject:dic2];
       
    [super setTitleAndImage:@"env_corner_jiankong.png" withTitle:@"监控"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int leftRight = 50;
    int rowGap = 5;
    int top = 10;
    int columnN = 2;
    int uiviewWidth = (SCREEN_WIDTH - leftRight*2 -rowGap*2)/columnN;
    int cellHeight = uiviewWidth -140;
    
    int rowNUmber = (int) [_monitorRoomList count] / 2 + 1;
    
    UIScrollView *_botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight, 80, SCREEN_WIDTH-2*leftRight, SCREEN_HEIGHT - 200)];
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH-2*leftRight, rowNUmber * (cellHeight + rowGap) +10);
    _botomView.scrollEnabled=YES;
    _botomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_botomView];

    
    int index = 0;
    for (NSMutableDictionary *dic in _monitorRoomList) {
        int row = index/columnN;
        int col = index%columnN;
        int startX = col*uiviewWidth+col*rowGap;
        int startY = row*cellHeight+rowGap*row+top;
        
        UIView *inputPannel = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, uiviewWidth, cellHeight)];
        inputPannel.tag = index;
        inputPannel.userInteractionEnabled=YES;
        [_botomView addSubview:inputPannel];
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [inputPannel addGestureRecognizer:longPress0];
        
        UIImage *roomImage = [dic objectForKey:@"image"];
        if (roomImage == nil) {
            roomImage = [UIImage imageNamed:@"user_monitor_default_n.png"];
        }
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = index;
        [inputPannel addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(0, 0, uiviewWidth, cellHeight);
        roomeImageView.userInteractionEnabled=YES;
        
        UIImageView *roomeBotomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_meeting_roome_b.png"]];
        [inputPannel addSubview:roomeBotomImageView];
        roomeBotomImageView.frame = CGRectMake(0, CGRectGetHeight(inputPannel.frame)-30, inputPannel.frame.size.width, 30);
        roomeBotomImageView.userInteractionEnabled=YES;
        
        UIButton *cityBtn = [UIButton buttonWithColor:[UIColor clearColor] selColor:[UIColor clearColor]];
        cityBtn.frame = CGRectMake(10, CGRectGetHeight(inputPannel.frame)-30, inputPannel.frame.size.width-10, 30);
        cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [cityBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [cityBtn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [inputPannel addSubview:cityBtn];
        cityBtn.tag = index;
        [cityBtnArray addObject:cityBtn];
        
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

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end










