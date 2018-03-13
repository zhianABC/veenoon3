//
//  EngineerWirlessYaoBaoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerCleanWaterViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "SlideButton.h"
#import "BatteryView.h"
#import "SignalView.h"
#import "CleanWaterRightView.h"


@interface EngineerCleanWaterViewCtrl()<CustomPickerViewDelegate> {
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    NSMutableArray *_imageViewArray;
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *_buttonNumberArray;
    
    NSMutableArray *_selectedBtnArray;
    
    NSMutableArray *_nameLabelArray;
    NSMutableArray *_channelArray;
    
    CleanWaterRightView *_rightView;
    BOOL isSettings;
    UIButton *okBtn;
}
@end

@implementation EngineerCleanWaterViewCtrl
@synthesize _cleanWaterSysArray;
@synthesize _number;
- (void) inintData {
    if (_cleanWaterSysArray) {
        [_cleanWaterSysArray removeAllObjects];
    } else {
        _cleanWaterSysArray = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *wuxianDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"huangliurong", @"name",
                                       @"off", @"status",
                                       @"1", @"singnal",
                                       @"huatong", @"type",
                                       @"100", @"dianliang", nil];
    NSMutableDictionary *wuxianDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"huangliurong2", @"name",
                                       @"off", @"status",
                                       @"1", @"singnal",
                                       @"yaobao", @"type",
                                       @"100", @"dianliang", nil];
    NSMutableDictionary *wuxianDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"huangliurong3", @"name",
                                       @"off", @"status",
                                       @"1", @"singnal",
                                       @"huatong", @"type",
                                       @"90", @"dianliang", nil];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:wuxianDic1, wuxianDic2, wuxianDic3, nil];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"001", @"name",
                                 array1, @"value", nil];
    [_cleanWaterSysArray addObject:dic1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings=NO;
    
    _imageViewArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    _nameLabelArray = [[NSMutableArray alloc] init];
    _channelArray = [[NSMutableArray alloc] init];
    
    [self inintData];
    
    [super setTitleAndImage:@"env_corner_airclean.png" withTitle:@"净水"];
    
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
    
    int index = 0;
    int top = 250;
    
    int leftRight = 100;
    
    int cellWidth = 100;
    int cellHeight = 100;
    int colNumber = 6;
    int space = 25;
    
    NSMutableDictionary *dataDic = [_cleanWaterSysArray objectAtIndex:0];
    NSMutableArray *dataArray = [dataDic objectForKey:@"value"];
    
    if ([dataArray count] == 0) {
        for (int i = 0; i < self._number; i++) {
            
        }
    } else {
        for (int i = 0; i < [dataArray count]; i++) {
            NSMutableDictionary *dic = [dataArray objectAtIndex:i];
            
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top;
            
            UIButton *scenarioBtn = [UIButton buttonWithColor:nil selColor:RGB(0, 89, 118)];
            scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            scenarioBtn.clipsToBounds = YES;
            scenarioBtn.layer.cornerRadius = 5;
            scenarioBtn.layer.borderWidth = 2;
            scenarioBtn.layer.borderColor = [UIColor clearColor].CGColor;
            NSString *status = [dic objectForKey:@"status"];
            
            [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
            [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateHighlighted];
            
            if ([status isEqualToString:@"ON"]) {
                [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
            }
            scenarioBtn.tag = i;
            [self.view addSubview:scenarioBtn];
            
            [scenarioBtn addTarget:self
                            action:@selector(scenarioAction:)
                  forControlEvents:UIControlEventTouchUpInside];
            [self createBtnLabel:scenarioBtn dataDic:dic];
            
            UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed2:)];
            
            [scenarioBtn addGestureRecognizer:longPress2];
            
            
            UIImage *image;
            NSString *huatongType = [dataDic objectForKey:@"type"];
            if ([@"huatong" isEqualToString:huatongType]) {
                image = [UIImage imageNamed:@"huatong_yellow_n.png"];
            } else {
                image = [UIImage imageNamed:@"yaobao_yellow_n.png"];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.backgroundColor = DARK_BLUE_COLOR;
            imageView.frame = CGRectMake(scenarioBtn.frame.origin.x+10, scenarioBtn.frame.origin.y+10, 100, 100);
            imageView.tag = index;
            imageView.userInteractionEnabled=YES;
            imageView.layer.contentsGravity = kCAGravityCenter;
            [self.view addSubview:imageView];
            
            BatteryView *batter = [[BatteryView alloc] initWithFrame:CGRectZero];
            batter.normalColor = YELLOW_COLOR;
            [imageView addSubview:batter];
            batter.center = CGPointMake(60, 18);
            
            NSString *dianliangStr = [dataDic objectForKey:@"dianliang"];
            int dianliang = [dianliangStr intValue];
            double dianliangDouble = 1.0f * dianliang / 100;
            [batter setBatteryValue:dianliangDouble];
            
            SignalView *signal = [[SignalView alloc] initWithFrameAndStep:CGRectMake(70, 50, 30, 20) step:2];
            [imageView addSubview:signal];
            [signal setLightColor:YELLOW_COLOR];//SINGAL_COLOR
            [signal setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
            NSString *sinalString = [dataDic objectForKey:@"signal"];
            int signalInt = [sinalString intValue];
            [signal setSignalValue:signalInt];
            
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, scenarioBtn.frame.size.width-40, scenarioBtn.frame.size.width-10, 20)];
            titleL.backgroundColor = [UIColor clearColor];
            [imageView addSubview:titleL];
            titleL.font = [UIFont boldSystemFontOfSize:12];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.textColor  = YELLOW_COLOR;
            titleL.text = [dataDic objectForKey:@"name"];
            imageView.hidden = YES;
            
            UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed3:)];
            [imageView addGestureRecognizer:longPress3];
            
            [_imageViewArray addObject:imageView];
            [_buttonArray addObject:scenarioBtn];
            
            index++;
        }
    }
}
- (void) scenarioAction:(id)sender{
    UIButton *btn = (UIButton*) sender;
    int index = (int) btn.tag;
    NSMutableDictionary *dataDic = [_cleanWaterSysArray objectAtIndex:0];
    NSMutableArray *dataArray = [dataDic objectForKey:@"value"];
    NSMutableDictionary *dic = [dataArray objectAtIndex:index];
    
    NSString *status = [dic objectForKey:@"status"];
    
    UILabel *nameLabel = [_nameLabelArray objectAtIndex:index];
    UILabel *channelLabel = [_channelArray objectAtIndex:index];
    if ([status isEqualToString:@"ON"]) {
        [btn setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
        [dic setObject:@"OFF" forKey:@"status"];
        nameLabel.textColor  = [UIColor whiteColor];
        channelLabel.textColor  = [UIColor whiteColor];
    } else {
        [btn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
        [dic setObject:@"ON" forKey:@"status"];
        nameLabel.textColor  = RGB(230, 151, 50);
        channelLabel.textColor  = RGB(230, 151, 50);
    }
}

- (void) createBtnLabel:(UIButton*)sender dataDic:(NSMutableDictionary*) dataDic{
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(sender.frame.size.width - 20, 0, 20, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [sender addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:11];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dataDic objectForKey:@"name"];
    [_nameLabelArray addObject:titleL];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(sender.frame.size.width/2 -40, sender.frame.size.height - 20, 80, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [sender addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:12];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"Channel";
    [_channelArray addObject:titleL];
}

- (void) longPressed3:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        int index = (int) press.view.tag;
        UIButton *button = [_buttonArray objectAtIndex:index];
        UIImageView *imageView = [_imageViewArray objectAtIndex:index];
        if (button.isHidden) {
            button.hidden = NO;
            imageView.hidden = YES;
        } else {
            button.hidden = YES;
            imageView.hidden = NO;
        }
    }
}

- (void) longPressed2:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        int index = (int) press.view.tag;
        UIButton *button = [_buttonArray objectAtIndex:index];
        UIImageView *imageView = [_imageViewArray objectAtIndex:index];
        if (button.isHidden) {
            button.hidden = NO;
            imageView.hidden = YES;
        } else {
            button.hidden = YES;
            imageView.hidden = NO;
        }
    }
}

- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 100) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 2; i++)
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
        _rightView = [[CleanWaterRightView alloc]
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
