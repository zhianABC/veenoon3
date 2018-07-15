//
//  UserAirConditionViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserAirConditionViewCtrl.h"
#import "UIButton+Color.h"
#import "MapMarkerLayer.h"
#import "Scenario.h"
#import "AirConditionPlug.h"
#import "RegulusSDK.h"

@interface UserAirConditionViewCtrl () {
    NSMutableArray *_conditionRoomList;
    NSMutableArray *_conditionBtnList;
    MapMarkerLayer *markerLayer;
    
    UIButton *zhilengBtn;
    UIButton *zhireBtn;
    UIButton *aireWindBtn;
    UIButton *aireFireBtn;
    
    UILabel *wenduL;
}
@property (nonatomic, strong) NSMutableArray *_conditionRoomList;
@end

@implementation UserAirConditionViewCtrl
@synthesize _conditionRoomList;
@synthesize _scenario;


- (void) initData {
    
    
    self._conditionRoomList = [NSMutableArray array];
    
    for(BasePlugElement *plug in _scenario._envDevices)
    {
        if([plug isKindOfClass:[AirConditionPlug class]])
        {
            [self._conditionRoomList addObject:plug];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleAndImage:@"env_corner_kongtiao.png" withTitle:@"空调"];
    
    [self initData];
    
    _conditionBtnList = [[NSMutableArray alloc] init];
    
    
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
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int leftGap = 160;
    int scrollHeight = 600;
    int cellWidth = 100;
    int rowGap = 20;
    int number = (int) [self._conditionRoomList count];
    int contentWidth = number * 100 + (number-1) * rowGap;
    UIScrollView *airCondtionView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftGap, SCREEN_HEIGHT-scrollHeight, SCREEN_WIDTH - leftGap*2, cellWidth+10)];
    airCondtionView.contentSize =  CGSizeMake(contentWidth, cellWidth+10);
    airCondtionView.scrollEnabled=YES;
    airCondtionView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:airCondtionView];
    
    int index = 0;
    for (AirConditionPlug *plug in _conditionRoomList) {
        
        RgsDriverObj *driver = plug._driver;
        
        int startX = index*cellWidth+index*rowGap+20;
        int startY = 5;
        
        UIButton *airConditionBtn = [UIButton buttonWithColor:nil selColor:nil];
        airConditionBtn.tag = index;
        airConditionBtn.frame = CGRectMake(startX, startY, cellWidth, cellWidth);
        [airConditionBtn setImage:[UIImage imageNamed:@"user_aircondition_n.png"] forState:UIControlStateNormal];
        [airConditionBtn setImage:[UIImage imageNamed:@"user_aircondition_s.png"] forState:UIControlStateHighlighted];
        [airConditionBtn setTitle:[NSString stringWithFormat:@"%d",
                                   (int)driver.m_id] forState:UIControlStateNormal];
        
        [airConditionBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
        airConditionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [airConditionBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
        airConditionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [airConditionBtn setTitleEdgeInsets:UIEdgeInsetsMake(airConditionBtn.imageView.frame.size.height+10,-105,-20,20)];
        [airConditionBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,-15,airConditionBtn.titleLabel.bounds.size.height, 0)];
        [airConditionBtn addTarget:self action:@selector(airConditionAction:) forControlEvents:UIControlEventTouchUpInside];
        [airCondtionView addSubview:airConditionBtn];
        
        index++;
        
        [_conditionBtnList addObject:airConditionBtn];
    }
    int rowGap2 = 40;
    int btnLeftRight = SCREEN_WIDTH/2-160-60;
    
    zhilengBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    zhilengBtn.frame = CGRectMake(btnLeftRight, SCREEN_HEIGHT-400, 80, 80);
    zhilengBtn.layer.cornerRadius = 5;
    zhilengBtn.layer.borderWidth = 2;
    zhilengBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zhilengBtn.clipsToBounds = YES;
    [zhilengBtn setImage:[UIImage imageNamed:@"user_aircon_cold_n.png"] forState:UIControlStateNormal];
    [zhilengBtn setImage:[UIImage imageNamed:@"user_aircon_cold_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zhilengBtn];
    [zhilengBtn addTarget:self action:@selector(zhilengAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    zhireBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    zhireBtn.frame = CGRectMake(btnLeftRight+rowGap2 +80, SCREEN_HEIGHT-400, 80, 80);
    zhireBtn.layer.cornerRadius = 5;
    zhireBtn.layer.borderWidth = 2;
    zhireBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zhireBtn.clipsToBounds = YES;
    [zhireBtn setImage:[UIImage imageNamed:@"user_aircon_hot_n.png"] forState:UIControlStateNormal];
    [zhireBtn setImage:[UIImage imageNamed:@"user_aircon_hot_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zhireBtn];
    [zhireBtn addTarget:self action:@selector(zhireAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    markerLayer = [[MapMarkerLayer alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT-230, 80, 80)];
    markerLayer.isFill = YES;
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"80", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"40", @"LX",
                                 @"40", @"LY",
                                 nil];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"40", @"LX",
                                 @"40", @"LY",
                                 nil];
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"40", @"LX",
                                 @"80", @"LY",
                                 nil];
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"80", @"LY",
                                 nil];
    NSMutableDictionary *dic9 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    
    
    NSMutableDictionary *dic11 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"80", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic12 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"80", @"LX",
                                 @"80", @"LY",
                                 nil];
    NSMutableDictionary *dic13 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"40", @"LX",
                                 @"80", @"LY",
                                 nil];
    NSMutableDictionary *dic14 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"40", @"LX",
                                 @"40", @"LY",
                                 nil];
    NSMutableDictionary *dic15 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"80", @"LX",
                                  @"0", @"LY",
                                  nil];
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:dic1, dic2, dic3,dic4, nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:dic5, dic6, dic7,dic8, dic9,nil];
    NSMutableArray *array3 = [NSMutableArray arrayWithObjects:dic11, dic12, dic13, dic14, dic15,nil];
    markerLayer.points1 = array1;
    markerLayer.points2 = array2;
    markerLayer.points3 = array3;
    
    markerLayer.selectedColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_airecon_wendu_n.png"] ];
    imageView.frame = CGRectMake(48, 9, 9, 6);
    [markerLayer addSubview:imageView];
    
    wenduL = [[UILabel alloc] init];
    wenduL.text = @"26";
    wenduL.font = [UIFont systemFontOfSize:12];
    wenduL.textColor = [UIColor whiteColor];
    wenduL.frame = CGRectMake(33, 10, 30, 12);
    [markerLayer addSubview:wenduL];
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"+";
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(15, 40, 20, 20);
    [markerLayer addSubview:addLabel];
    
    UILabel *minusLabel = [[UILabel alloc] init];
    minusLabel.text = @"-";
    minusLabel.textColor = [UIColor whiteColor];
    minusLabel.frame = CGRectMake(60, 40, 20, 20);
    [markerLayer addSubview:minusLabel];
    
    [self.view addSubview:markerLayer];
    markerLayer.delegate_ = self;
    
    aireWindBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    aireWindBtn.frame = CGRectMake(btnLeftRight+rowGap2*2 +80*2, SCREEN_HEIGHT-400, 80, 80);
    aireWindBtn.layer.cornerRadius = 5;
    aireWindBtn.layer.borderWidth = 2;
    aireWindBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    aireWindBtn.clipsToBounds = YES;
    [aireWindBtn setImage:[UIImage imageNamed:@"user_aircon_wind_n.png"] forState:UIControlStateNormal];
    [aireWindBtn setImage:[UIImage imageNamed:@"user_aircon_wind_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:aireWindBtn];
    [aireWindBtn addTarget:self action:@selector(airWindAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    aireFireBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    aireFireBtn.frame = CGRectMake(btnLeftRight+rowGap2*3 +80*3, SCREEN_HEIGHT-400, 80, 80);
    aireFireBtn.layer.cornerRadius = 5;
    aireFireBtn.layer.borderWidth = 2;
    aireFireBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    aireFireBtn.clipsToBounds = YES;
    [aireFireBtn setImage:[UIImage imageNamed:@"user_aircon_fire_n.png"] forState:UIControlStateNormal];
    [aireFireBtn setImage:[UIImage imageNamed:@"user_aircon_fire_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:aireFireBtn];
    [aireFireBtn addTarget:self action:@selector(airFireAction:)
       forControlEvents:UIControlEventTouchUpInside];
}

- (void) didSelectView:(int) path {
    markerLayer.isSelected = path;
    [markerLayer setNeedsDisplay];
    
    if (path == 2) {
        NSString *wenduStr = wenduL.text;
        int value = [wenduStr intValue];
        value++;
        
        NSString *wenduStr2 = [NSString stringWithFormat:@"%d", value];
        wenduL.text = wenduStr2;
    } else if (path == 3) {
        NSString *wenduStr = wenduL.text;
        int value = [wenduStr intValue];
        value--;
        
        NSString *wenduStr2 = [NSString stringWithFormat:@"%d", value];
        wenduL.text = wenduStr2;
    }
}
- (void) didUnSelectView:(int) path {
    markerLayer.isSelected = 0;
    [markerLayer setNeedsDisplay];
}
- (void) airFireAction:(id)sender{
    [aireFireBtn setSelected:YES];
    [aireWindBtn setSelected:NO];
    [zhireBtn setSelected:NO];
    [zhilengBtn setSelected:NO];
}
- (void) airWindAction:(id)sender{
    [aireFireBtn setSelected:NO];
    [aireWindBtn setSelected:YES];
    [zhireBtn setSelected:NO];
    [zhilengBtn setSelected:NO];
}
- (void) zhireAction:(id)sender{
    [aireFireBtn setSelected:NO];
    [aireWindBtn setSelected:NO];
    [zhireBtn setSelected:YES];
    [zhilengBtn setSelected:NO];
}
- (void) zhilengAction:(id)sender{
    [aireFireBtn setSelected:NO];
    [aireWindBtn setSelected:NO];
    [zhireBtn setSelected:NO];
    [zhilengBtn setSelected:YES];
}
- (void) airConditionAction:(id)sender{
    UIButton *selectBtn = (UIButton*) sender;
    int selectTag = selectBtn.tag;
    
    for (UIButton *btn in _conditionBtnList) {
        if (btn.tag == selectTag) {
            [btn setImage:[UIImage imageNamed:@"user_aircondition_s.png"] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"user_aircondition_n.png"] forState:UIControlStateNormal];
            [btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
        }
    }
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
