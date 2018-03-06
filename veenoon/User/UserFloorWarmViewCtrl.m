//
//  UserFloorWarmViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserFloorWarmViewCtrl.h"
#import "UIButton+Color.h"
#import "MapMarkerLayer.h"

@interface UserFloorWarmViewCtrl <MapMarkerLayerDelegate>() {
    NSMutableArray *_floorwarmRoomList;
    NSMutableArray *_floorBtnList;
    MapMarkerLayer *markerLayer;
}
    @property (nonatomic, strong) NSMutableArray *_floorwarmRoomList;
    @end

@implementation UserFloorWarmViewCtrl
    @synthesize _floorwarmRoomList;
    
- (void) initData {
    if (_floorwarmRoomList) {
        [_floorwarmRoomList removeAllObjects];
    } else {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"小会议室", @"name",
                                     nil];
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        self._floorwarmRoomList = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic7, nil];
    }
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    if (_floorBtnList) {
        [_floorBtnList removeAllObjects];
    } else {
        _floorBtnList = [[NSMutableArray alloc] init];
    }
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
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
    
    int leftGap = 165;
    int scrollHeight = 600;
    int cellWidth = 100;
    int rowGap = 40;
    int number = [self._floorwarmRoomList count];
    int contentWidth = number * 100 + (number-1) * rowGap-30;
    UIScrollView *airCondtionView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftGap, SCREEN_HEIGHT-scrollHeight, SCREEN_WIDTH - leftGap*2, cellWidth+10)];
    airCondtionView.contentSize =  CGSizeMake(contentWidth, cellWidth+10);
    airCondtionView.scrollEnabled=YES;
    airCondtionView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:airCondtionView];
    
    int index = 0;
    for (id dic in _floorwarmRoomList) {
        int startX = index*cellWidth+index*rowGap+10;
        int startY = 5;
        
        UIButton *airConditionBtn = [UIButton buttonWithColor:nil selColor:nil];
        airConditionBtn.tag = index;
        airConditionBtn.frame = CGRectMake(startX, startY, cellWidth, cellWidth);
        [airConditionBtn setImage:[UIImage imageNamed:@"user_floorwarm_n.png"] forState:UIControlStateNormal];
        [airConditionBtn setImage:[UIImage imageNamed:@"user_floorwarm_s.png"] forState:UIControlStateHighlighted];
        [airConditionBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [airConditionBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
        [airConditionBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
        airConditionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [airConditionBtn setTitleEdgeInsets:UIEdgeInsetsMake(airConditionBtn.imageView.frame.size.height+10,-90,-20,20)];
        [airConditionBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,-15,airConditionBtn.titleLabel.bounds.size.height, 0)];
        [airConditionBtn addTarget:self action:@selector(airConditionAction:) forControlEvents:UIControlEventTouchUpInside];
        [airCondtionView addSubview:airConditionBtn];
        
        index++;
        
        [_floorBtnList addObject:airConditionBtn];
    }
    
    int btnLeftRight = 200;
    
    
    markerLayer = [[MapMarkerLayer alloc] initWithFrame:CGRectMake(btnLeftRight+280, SCREEN_HEIGHT-350, 100, 100)];
    markerLayer.isFill = YES;
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"50", @"LX",
                                 @"50", @"LY",
                                 nil];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"50", @"LX",
                                 @"50", @"LY",
                                 nil];
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"50", @"LX",
                                 @"100", @"LY",
                                 nil];
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"100", @"LY",
                                 nil];
    NSMutableDictionary *dic9 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"LX",
                                 @"0", @"LY",
                                 nil];
    
    
    NSMutableDictionary *dic11 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100", @"LX",
                                  @"0", @"LY",
                                  nil];
    NSMutableDictionary *dic12 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100", @"LX",
                                  @"100", @"LY",
                                  nil];
    NSMutableDictionary *dic13 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"50", @"LX",
                                  @"100", @"LY",
                                  nil];
    NSMutableDictionary *dic14 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"50", @"LX",
                                  @"50", @"LY",
                                  nil];
    NSMutableDictionary *dic15 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"100", @"LX",
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
    imageView.frame = CGRectMake(41, 19, 18, 12);
    [markerLayer addSubview:imageView];
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"+";
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(20, 50, 20, 20);
    [markerLayer addSubview:addLabel];
    
    UILabel *minusLabel = [[UILabel alloc] init];
    minusLabel.text = @"-";
    minusLabel.textColor = [UIColor whiteColor];
    minusLabel.frame = CGRectMake(70, 50, 20, 20);
    [markerLayer addSubview:minusLabel];
    
    [self.view addSubview:markerLayer];
    markerLayer.delegate_ = self;
}
    
- (void) didSelectView:(int) path {
    markerLayer.isSelected = path;
    [markerLayer setNeedsDisplay];
}
- (void) didUnSelectView:(int) path {
    markerLayer.isSelected = 0;
    [markerLayer setNeedsDisplay];
}
- (void) airConditionAction:(id)sender{
    UIButton *selectBtn = (UIButton*) sender;
    int selectTag = selectBtn.tag;
    
    for (UIButton *btn in _floorBtnList) {
        if (btn.tag == selectTag) {
            [btn setImage:[UIImage imageNamed:@"user_floorwarm_s.png"] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"user_floorwarm_n.png"] forState:UIControlStateNormal];
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
