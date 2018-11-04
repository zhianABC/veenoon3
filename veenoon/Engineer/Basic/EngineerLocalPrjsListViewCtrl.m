//
//  EngineerLocalPrjsListViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerLocalPrjsListViewCtrl.h"
#import "EngineerSysSelectViewCtrl.h"
#import "JCActionView.h"
#import "DataSync.h"
#import "AppDelegate.h"
#import "DataBase.h"
#import "Utilities.h"
#import "SBJson4.h"
#import "MeetingRoom.h"

#import "KVNProgress.h"
#import "DataCenter.h"
#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"
#endif

#import "UIImageView+WebCache.h"
#import "UserDefaultsKV.h"

#import "UIButton+Color.h"

#import "KVNProgress.h"
#import "EngineerScenarioSettingsViewCtrl.h"
#import "EngineerNewTeslariViewCtrl.h"
#import "UILabel+ContentSize.h"


@interface EngineerLocalPrjsListViewCtrl () {
    

    int _curEditIndex;
    
    UIButton *editBtn;
    
    UIScrollView *_offlineScroll;
    
    UIButton *_tab1;
   
    UIButton *_addBtn;
    UIImageView *_addIcon;
    
    BOOL _isEditing;
}


@property (nonatomic, strong) NSMutableArray *_offlineProjs;
@property (nonatomic, strong) NSMutableArray *_prjBtns;
@end

@implementation EngineerLocalPrjsListViewCtrl

@synthesize _offlineProjs;
@synthesize _prjBtns;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    int topSpace = StatusRect.size.height+60;

    int tabWidth = 200;
    int xx = SCREEN_WIDTH/2 - tabWidth/2;
    _tab1 = [[UIButton alloc] initWithFrame:CGRectMake(xx,
                                                      topSpace,
                                                      tabWidth,
                                                      44)];
    _tab1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_tab1 setTitle:@"离线配置" forState:UIControlStateNormal];
    [self.view addSubview:_tab1];
    [_tab1 setTitleColor:[UIColor whiteColor]
                forState:UIControlStateNormal];
  
    _offlineScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT-150)];
    _offlineScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_offlineScroll];
    
    

    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(SCREEN_WIDTH-20-160, StatusRect.size.height+20,160, 50);
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [editBtn addTarget:self action:@selector(editAction:)
      forControlEvents:UIControlEventTouchUpInside];
    

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, SCREEN_HEIGHT - 48, 42, 42);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backBtn addTarget:self
                action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];

    [self testOfflineMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshLocalPrjList:)
                                                 name:@"Notify_Refresh_Local_Prj_List"
                                               object:nil];
}

- (void) backAction:(id)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) editAction:(id)sender{
    
    _isEditing = !_isEditing;
    
    if(_isEditing)
    {
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        for(UIButton *btn in _prjBtns)
        {
            UIView *icon = [btn viewWithTag:110];
            if(icon)
            icon.hidden = NO;
        }
        
        _addBtn.hidden = YES;
        _addIcon.hidden = YES;
    }
    else
    {
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        [self loadLocalProjects];
    }
}


- (void) testOfflineMode{
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] UseLocalModel:^(BOOL result, NSError *error)
     {
         [KVNProgress dismiss];
         
         if(result)
         {
             [self loadLocalProjects];
         }
         else
         {
             [self downloadOfflineResources];
         }
     }];
}

- (void) refreshLocalPrjList:(NSNotification*)notify{
    
    [self performSelectorOnMainThread:@selector(loadLocalProjects)
                           withObject:nil
                        waitUntilDone:NO];
}

#pragma mark -- Local Mode ---

- (void) loadLocalProjects{
    
    self._offlineProjs = [NSMutableArray array];
    
    [[RegulusSDK sharedRegulusSDK] GetProjectsFromLocal:^(BOOL result, NSArray *names, NSError *error) {
        
        if(result)
        {
            if([names count])
            {
                [self._offlineProjs addObjectsFromArray:names];
                
            }
            
            [self layoutOfflineProjects];
        }
        
    }];
    
}

- (void) downloadOfflineResources{
    
    [KVNProgress showWithStatus:@"正在下载离线包"];
    [[RegulusSDK sharedRegulusSDK]RequestDownLocalResourceFiles:^(BOOL result, NSError *error) {
        if (!result) {
            [KVNProgress showErrorWithStatus:[error localizedDescription]];
        }
        else{
            [KVNProgress showSuccessWithStatus:@"下载完成"];
            
            [self loadLocalProjects];
        }
    }];
}

- (void) layoutOfflineProjects{
    
    [[_offlineScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int top = 0;
    int leftRight = 75;
    int space = 0;
    
    int cellWidth = (SCREEN_WIDTH - leftRight*2)/5;
    int cellHeight = 120;
    int index = 0;
    
    NSMutableArray *cellData = [NSMutableArray array];
    [cellData addObjectsFromArray:_offlineProjs];
    [cellData addObject:@{@"p":@"1"}];
    
    self._prjBtns = [NSMutableArray array];
    
    for (int idx = 0; idx < [cellData count]; idx++) {
        
        id  prj = [cellData objectAtIndex:idx];
        
        int row = index/5;
        int col = index%5;
        
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *prjBtn = [UIButton buttonWithColor:[UIColor clearColor] selColor:nil];
        prjBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        prjBtn.layer.cornerRadius = 5;
        prjBtn.clipsToBounds = YES;
        
        if([prj isKindOfClass:[NSDictionary class]])
        {
            //plus +1
            UIImage *img = [UIImage imageNamed:@"offline_remove_icon.png"];
            _addIcon = [[UIImageView alloc] initWithImage:img];
            _addIcon.userInteractionEnabled=YES;
            _addIcon.contentMode = UIViewContentModeCenter;
            _addIcon.clipsToBounds=YES;
            _addIcon.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            [_offlineScroll addSubview:_addIcon];
            
            _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _addBtn.frame = _addIcon.frame;
            [_offlineScroll addSubview:_addBtn];
            [_addBtn addTarget:self
                    action:@selector(newLocalProject:)
          forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            
            [_offlineScroll addSubview:prjBtn];
            
            prjBtn.tag = idx;
            [_prjBtns addObject:prjBtn];
            
            prjBtn.tag = idx;
            [prjBtn addTarget:self
                       action:@selector(locationPrjBtnAction:)
             forControlEvents:UIControlEventTouchUpInside];
            
            UIImage *img = [UIImage imageNamed:@"project_icon.png"];
            UIImageView *iconView = [[UIImageView alloc] initWithImage:img];
            [prjBtn addSubview:iconView];
            iconView.center = CGPointMake(cellWidth/2, cellHeight*0.4);
            
            UIImageView *rmIcon = [[UIImageView alloc]
                                   initWithImage:[UIImage imageNamed:@"red_del_icon.png"]];
            [prjBtn addSubview:rmIcon];
            rmIcon.tag = 110;
            rmIcon.center = CGPointMake(cellWidth-30, 30);
            rmIcon.hidden = YES;
            
            UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(iconView.frame)+5, cellWidth-20, 40)];
            titleL.backgroundColor = [UIColor clearColor];
            [prjBtn addSubview:titleL];
            titleL.font = [UIFont boldSystemFontOfSize:16];
            titleL.textColor  = [UIColor whiteColor];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.text = prj;
            [titleL contentSize];
            CGRect rc  = titleL.frame;
            if(rc.size.height > 40)
            {
                rc.size.height = 40;
                titleL.frame = rc;
            }

        }
        
        
        index++;
    }
}

- (void) locationPrjBtnAction:(UIButton*)sender{
    
    if(_isEditing)
    {
        if(sender.tag < [_offlineProjs count])
        {
            id  prj = [_offlineProjs objectAtIndex:sender.tag];
            
            [[RegulusSDK sharedRegulusSDK] DelLocalProject:prj completion:^(BOOL result, NSError *error) {
                
                if(result)
                [sender removeFromSuperview];
            }];
            
        }
    }
    else
    {
        if(sender.tag < [_offlineProjs count])
        {
            id  prj = [_offlineProjs objectAtIndex:sender.tag];
            
            [[RegulusSDK sharedRegulusSDK] LoadLocalProject:prj completion:^(BOOL result, NSError *error) {
                
                if(result)
                {
                    [DataCenter defaultDataCenter]._isLocalPrj = YES;
                    [DataSync sharedDataSync]._currentReglusLogged = nil;
                    [DataCenter defaultDataCenter]._currentRoom = nil;
                    
                    EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
                    ctrl.localPrjName = prj;
                    [self.navigationController pushViewController:ctrl animated:YES];
                 }
                
            }];
        }
    }
   
    
}

- (void) newLocalProject:(id)sender{
    
    [KVNProgress show];
    [[RegulusSDK sharedRegulusSDK] NewLocalProject:@"TeslariaTmp"
                                          hardware:@"EOC500"
                                        completion:^(BOOL result, NSError *error) {
        if (result)
        {
            [DataCenter defaultDataCenter]._isLocalPrj = YES;
            [DataSync sharedDataSync]._currentReglusLogged = nil;
            [DataCenter defaultDataCenter]._currentRoom = nil;
            
            EngineerNewTeslariViewCtrl *lctrl = [[EngineerNewTeslariViewCtrl alloc] init];
            lctrl._isLocal = YES;
            [self.navigationController pushViewController:lctrl animated:YES];
            
//            EngineerSysSelectViewCtrl *lctrl = [[EngineerSysSelectViewCtrl alloc] init];
//            [self.navigationController pushViewController:lctrl animated:YES];
            
        }
        else{
            [KVNProgress showErrorWithStatus:[error localizedDescription]];
        }
                                            
      [KVNProgress dismiss];
                                            
    }];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

