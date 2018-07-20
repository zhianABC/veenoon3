//
//  UserMettingRoomConfig.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMeetingRoomConfig.h"
#import "UserScnarioConfigViewController.h"
#import "KVNProgress.h"
#import "RegulusSDK.h"
#import "DataCenter.h"
#import "DataSync.h"
#import "DataBase.h"
#import "Scenario.h"

@interface UserMeetingRoomConfig () {
    NSMutableDictionary *meetingRoomDic;
    
    UIButton *_trainingBtn;
    UIButton *_envirementControlBtn;
    UIButton *_guestBtn;
    UIButton *_envirementLightBtn;
    UIButton *_discussionBtn;
    UIButton *_leaveMeetingBtn;
    
    UIScrollView *_content;
}
@property (nonatomic, strong) NSMutableDictionary *_mapSelect;

@property (nonatomic, strong) NSString *_regulus_user_id;
@property (nonatomic, strong) NSString *_regulus_gateway_id;
@property (nonatomic, strong) NSMutableArray *_sceneDrivers;

@property (nonatomic, strong) UIImage *_nor_image;
@property (nonatomic, strong) UIImage *_sel_image;


@end

@implementation UserMeetingRoomConfig
@synthesize meetingRoomDic;
@synthesize _mapSelect;

@synthesize _regulus_user_id;
@synthesize _regulus_gateway_id;
@synthesize _sceneDrivers;

@synthesize _nor_image;
@synthesize _sel_image;


- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, SCREEN_HEIGHT -45, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [backBtn addTarget:self action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 200, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [meetingRoomDic objectForKey:@"roomname"];
    
    self._mapSelect = [NSMutableDictionary dictionary];
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-80-50)];
    [self.view addSubview:_content];
    _content.clipsToBounds = YES;
    
    
    self._nor_image = [UIImage imageNamed:@"user_training_n.png"];
    self._sel_image = [UIImage imageNamed:@"user_training_s.png"];
    
    self._regulus_gateway_id = [meetingRoomDic objectForKey:@"regulus_id"];
    self._regulus_user_id = [meetingRoomDic objectForKey:@"user_id"];
    
    self._sceneDrivers = [NSMutableArray array];
    
#if LOGIN_REGULUS
    [KVNProgress show];
    
    
    if([_regulus_gateway_id length]
       && [_regulus_user_id length])
    {
        [self loginCtrlDevice];
    }
    else
    {
        [self regCtrlDevice];
    }
    
#endif
    
   
}


- (void) regCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
    [KVNProgress showWithStatus:@"登录中..."];
    
    [[RegulusSDK sharedRegulusSDK] RequestJoinGateWay:_regulus_gateway_id
                                           completion:^(BOOL result,
                                                        NSString *client_id, NSError *error) {
                                               if (result) {
                                                   
                                                   block_self._regulus_user_id = client_id;
                                                   //NSLog(@"user_id:%@,gw:%@\n",user_id,_gw_id.text);
                                                   [[NSUserDefaults standardUserDefaults] setObject:@"RGS_EOC500_01" forKey:@"gateway_id"];
                                                   [[NSUserDefaults standardUserDefaults] setObject:client_id forKey:@"user_id"];
                                                   
                                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                                   
                                                   [block_self loginCtrlDevice];
                                               }
                                               else{
                                                   [KVNProgress showErrorWithStatus:[error description]];
                                                   
                                                   [DataSync sharedDataSync]._currentReglusLogged = nil;
                                               }
                                           }];

#endif
    
}

- (void) loginCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
    [[RegulusSDK sharedRegulusSDK] Login:self._regulus_user_id
                                   gw_id:_regulus_gateway_id
                                password:@"111111"
                                   level:1 completion:^(BOOL result, NSInteger level, NSError *error) {
                                       if (result) {
                                           [block_self update];
                                       }
                                       else
                                       {
                                           [DataSync sharedDataSync]._currentReglusLogged = nil;
                                           [KVNProgress showErrorWithStatus:[error description]];
                                       }
                                   }];
    
#endif
    
}

- (void) update{
    
    [DataCenter defaultDataCenter]._roomData = meetingRoomDic;
    [meetingRoomDic setObject:_regulus_user_id forKey:@"user_id"];
    
    [[DataBase sharedDatabaseInstance] saveMeetingRoom:meetingRoomDic];
    
    
    
    [DataSync sharedDataSync]._currentReglusLogged = @{@"gw_id":_regulus_gateway_id,
                                                       @"user_id":_regulus_user_id
                                                       };
    
    [self checkArea];
    
}

- (void) checkArea{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
    [[RegulusSDK sharedRegulusSDK] GetAreas:^(NSArray *RgsAreaObjs, NSError *error) {
        if (error) {
            
            [KVNProgress showErrorWithStatus:@"连接中控出错!"];
        }
        else
        {
            [block_self checkSceneData:RgsAreaObjs];
        }
    }];
    
#endif
    
}
- (void) checkSceneData:(NSArray*)RgsAreaObjs{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
    RgsAreaObj *areaObj = nil;
    for(RgsAreaObj *obj in RgsAreaObjs)
    {
        if([obj.name isEqualToString:VEENOON_AREA_NAME])
        {
            areaObj = obj;
            break;
        }
    }
    if(areaObj)
    {
        //获取Area添加的插件
        [DataSync sharedDataSync]._currentArea = areaObj;
        [[DataSync sharedDataSync] syncAreaHasDrivers];
        
        [[RegulusSDK sharedRegulusSDK] GetAreaScenes:areaObj.m_id
                                          completion:^(BOOL result, NSArray *scenes, NSError *error) {
                                              if (result) {
                                                  
                                                  [block_self checkSceneDriver:scenes];
                                              }
                                          }];
    }
    else
    {
        [KVNProgress dismiss];
    }
    
    
#endif
}

- (void) checkSceneDriver:(NSArray*)scenes{
    
    int room_id = [[meetingRoomDic objectForKey:@"room_id"] intValue];
    NSArray* savedScenarios = [[DataBase sharedDatabaseInstance] getSavedScenario:room_id];
    
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    for(NSMutableDictionary *senario in savedScenarios)
    {
        int s_driver_id = [[senario objectForKey:@"s_driver_id"] intValue];
        [map setObject:senario forKey:[NSNumber numberWithInt:s_driver_id]];
    }
    
    
    
    for(RgsSceneObj *dr in scenes)
    {
        id key = [NSNumber numberWithInt:(int)dr.m_id];
        
        if([map objectForKey:key])
        {
            Scenario *s = [[Scenario alloc] init];
            [s fillWithData:[map objectForKey:key]];
            s._rgsSceneObj = dr;
            
            
            [_sceneDrivers addObject:s];
        }
    }
    
    
    [KVNProgress dismiss];
    
    [self layoutScenarios];
}


- (void) layoutScenarios{
    
//    self.scens = @[@{@"icon_nor":@"user_training_n.png",@"icon_sel":@"user_training_s.png",
//                     @"title":@"专业培训",@"title_en":@"Training"},
//                   @{@"icon_nor":@"envirement_control_n.png",@"icon_sel":@"envirement_control_s.png",
//                     @"title":@"环境控制",@"title_en":@"Environmental control"},
//                   @{@"icon_nor":@"guest_reception_n.png",@"icon_sel":@"guest_reception_s.png",
//                     @"title":@"宾客接待",@"title_en":@"Guests reception"},
//                   @{@"icon_nor":@"envirement_light_n.png",@"icon_sel":@"envirement_light_s.png",
//                     @"title":@"环境照明",@"title_en":@"Ambient lighting"},
//                   @{@"icon_nor":@"meeting_discuss_n.png",@"icon_sel":@"meeting_discuss_s.png",
//                     @"title":@"讨论会议",@"title_en":@"Meeting"},
//                   @{@"icon_nor":@"close_system_n.png",@"icon_sel":@"close_system_s.png",
//                     @"title":@"离开会场",@"title_en":@"Close system"}];
//
    
    
    int ox = (SCREEN_WIDTH - 420*2 - 20)/2 - 20;
    int y = 0;
    int x = ox;
    for(int i = 0; i < [_sceneDrivers count]; i++)
    {
        
        if(i%2==0 && i > 0){
            y+=200;
            y+=5;
            x = ox;
        }
        if(i%2 != 0 ){
            x = ox+420;
            x+=10;
        }
        
        Scenario *scen = [_sceneDrivers objectAtIndex:i];
        
        NSDictionary *sDic = [scen senarioData];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, 481, 250);
        [btn setImage:_nor_image
             forState:UIControlStateNormal];
        [btn setImage:_sel_image
             forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(userTrainingAction:) forControlEvents:UIControlEventTouchUpInside];
        [_content addSubview:btn];
        btn.tag = i;
        
        NSString *iconUser = [sDic objectForKey:@"icon_user"];
        UIImage *img = [UIImage imageNamed:iconUser];
        if(img)
        {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:img];
            [btn addSubview:iconView];
            iconView.contentMode = UIViewContentModeCenter;
            
            iconView.center = CGPointMake(120, 125);
        }
        
        NSString *name = [sDic objectForKey:@"name"];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 200, 40)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:22];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = name;
        titleL.tag = 102;
        titleL.textAlignment = NSTextAlignmentLeft;
        titleL.center = CGPointMake(titleL.center.x, 110);
        
        NSString *en_name = [sDic objectForKey:@"en_name"];
        if(en_name == nil)
        {
            en_name = @"";
        }
        
        UILabel* titleEnL = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 300, 40)];
        titleEnL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleEnL];
        titleEnL.font = [UIFont systemFontOfSize:22];
        titleEnL.textColor  = [UIColor whiteColor];
        titleEnL.text = en_name;
        titleEnL.tag = 103;
        titleEnL.textAlignment = NSTextAlignmentLeft;
        titleEnL.center = CGPointMake(titleEnL.center.x, 140);
        
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [btn addGestureRecognizer:longPress0];
    }
    
    _content.contentSize = CGSizeMake(_content.frame.size.width,
                                      y+260);
    
}

- (void) longPressed0:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
        int index = (int)viewRecognizer.view.tag;
        
        Scenario *scen = [_sceneDrivers objectAtIndex:index];
        
        UserScnarioConfigViewController *invitation = [[UserScnarioConfigViewController alloc] init];
        invitation._data = scen;
        [self.navigationController pushViewController:invitation animated:YES];
    }
}

- (void) userTrainingAction:(UIButton*)sender{
    
    id key = [NSNumber numberWithInteger:sender.tag];
    Scenario *scen = [_sceneDrivers objectAtIndex:[key intValue]];

    if([_mapSelect objectForKey:key])
    {
        //取消
        [sender setImage:_nor_image forState:UIControlStateNormal];
        [sender setImage:_sel_image forState:UIControlStateHighlighted];

        [_mapSelect removeObjectForKey:key];
    }
    else
    {
        
        UIButton *btn = [_mapSelect objectForKey:@"selected_btn"];
        if(btn)
        {
            id oldkey = [NSNumber numberWithInteger:btn.tag];
            
            [btn setImage:_nor_image forState:UIControlStateNormal];
            [btn setImage:_sel_image forState:UIControlStateHighlighted];
            
            [_mapSelect removeObjectForKey:oldkey];
        }
        
        //选中
        [sender setImage:_sel_image forState:UIControlStateNormal];
        [sender setImage:_sel_image forState:UIControlStateHighlighted];

        [KVNProgress show];
        
        RgsSceneObj * scene_obj = scen._rgsSceneObj;
        if(scene_obj && [scene_obj isKindOfClass:[RgsSceneObj class]])
        {
            [[RegulusSDK sharedRegulusSDK] ExecScene:scene_obj.m_id
                                          completion:^(BOOL result, NSError *error) {
                if (result) {
                    [KVNProgress showSuccess];
                }
                else{
                    [KVNProgress showErrorWithStatus:@"执行失败！"];
                }
            }];
        }
        
        [_mapSelect setObject:scen forKey:key];
        [_mapSelect setObject:sender forKey:@"selected_btn"];
    }
    
}



- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
