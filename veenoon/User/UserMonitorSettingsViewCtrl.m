//
//  UserMonitorSettingsViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/3.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMonitorSettingsViewCtrl.h"
#import "UIButton+Color.h"

@interface UserMonitorSettingsViewCtrl() {
    NSMutableArray *_monitorRoomList;
}
@property (nonatomic, strong) NSMutableArray *_monitorRoomList;
@end

@implementation UserMonitorSettingsViewCtrl
@synthesize _monitorRoomList;

- (void) initData {
    if (_monitorRoomList) {
        [_monitorRoomList removeAllObjects];
    } else {
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
        self._monitorRoomList = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic7, nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
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
    
    
    int leftRight = 50;
    int rowGap = 5;
    int top = 10;
    int uiviewWidth = (SCREEN_WIDTH - leftRight*2 -rowGap*2)/3;
    int cellHeight = uiviewWidth -100;
    
    int rowNUmber = [_monitorRoomList count] / 3 + 1;
    
    UIScrollView *_botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight, 100, SCREEN_WIDTH-2*leftRight, SCREEN_HEIGHT - 200)];
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
        inputPannel.userInteractionEnabled=YES;
        [_botomView addSubview:inputPannel];
        
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
