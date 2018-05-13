//
//  EngineerElectonicSysConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerElectronicSysConfigViewCtrl.h"
#import "UIButton+Color.h"
#import "PowerSettingView.h"
#import "CustomPickerView.h"
#import "APowerESet.h"

@interface EngineerElectronicSysConfigViewCtrl () {
    PowerSettingView *_psv;
    
    CustomPickerView *_customPicker;
    
    UIButton *okBtn;
    
    BOOL isSettings;
    
    NSMutableArray *lableArray;
    NSMutableArray *_selectedBtnArray;
    NSMutableArray *_allBtnArray;
    
    UIView *_proxysView;
}

@property (nonatomic, strong) APowerESet *_objSetCur;

@end

@implementation EngineerElectronicSysConfigViewCtrl
@synthesize _electronicSysArray;
@synthesize _number;

@synthesize _objSetCur;

- (void)viewDidLoad {
    [super viewDidLoad];
    isSettings = NO;
    
    lableArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    _allBtnArray = [[NSMutableArray alloc] init];
    
    [super setTitleAndImage:@"audio_corner_dianyuanguanli.png" withTitle:@"电源实时器"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
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

    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP*3;
    
    
    if([_electronicSysArray count])
    {
        self._objSetCur = [_electronicSysArray objectAtIndex:0];
    }
    
    if(_objSetCur == nil){
        self._objSetCur = [[APowerESet alloc] init];
        [_objSetCur initLabs:_number];
    }
    
    
    for (int i = 0; i < self._number; i++) {
        
        NSDictionary *dic = [_objSetCur getLabValueWithIndex:i];
        
        int row = i/colNumber;
        int col = i%colNumber;
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
        
        [_allBtnArray addObject:scenarioBtn];
    }
    
    int height = 150;
    
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           height-5,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-height-60)];
    [self.view addSubview:_proxysView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [_proxysView addGestureRecognizer:tapGesture];
}

- (void) handleTapGesture:(id)sender{
    
    if ([_psv superview]) {
        
        CGRect rc = _psv.frame;
        [UIView animateWithDuration:0.25
                         animations:^{
                             _psv.frame = CGRectMake(SCREEN_WIDTH,
                                                           rc.origin.y,
                                                           rc.size.width,
                                                           rc.size.height);
                         } completion:^(BOOL finished) {
                             [_psv removeFromSuperview];
                         }];
    }
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
}

- (void) createBtnLabel:(UIButton*)sender dataDic:(NSDictionary*) dataDic{
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sender.frame.size.width, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [sender addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:11];
    titleL.textColor  = [UIColor whiteColor];

    titleL.text = [dataDic objectForKey:@"name"];
    
    [lableArray addObject:titleL];
}

- (void) scenarioAction:(id)sender{
    UIButton *btn = (UIButton*) sender;
    int index = (int) btn.tag;
    
    UILabel *titleL = [lableArray objectAtIndex:index];
    
    UIButton *selctedBtn = nil;
    
    for(UIButton *btn in _selectedBtnArray) {
        if (index == (int) btn.tag) {
            selctedBtn = btn;
            break;
        }
    }
    
    if (selctedBtn != nil) {
        
        [selctedBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
        [titleL setTextColor:[UIColor whiteColor]];
        
        [_selectedBtnArray removeObject:selctedBtn];
        
        [_objSetCur setLabValue:NO withIndex:index];
        
    } else {
        
        selctedBtn = [_allBtnArray objectAtIndex:index];
        
        [selctedBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
        [titleL setTextColor:YELLOW_COLOR];
        
        [_selectedBtnArray addObject:selctedBtn];
        
        [_objSetCur setLabValue:YES withIndex:index];
    }
}

- (void) okAction:(id)sender{
    if (!isSettings) {
        
        if(_psv == nil)
        {
        _psv = [[PowerSettingView alloc]
                initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                         64, 300, SCREEN_HEIGHT-114)];
        } else {
            [UIView beginAnimations:nil context:nil];
            _psv.frame  = CGRectMake(SCREEN_WIDTH-300,
                                           64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        [self.view addSubview:_psv];
        
        _psv._objSet = _objSetCur;
        
        int cc = (int)[_objSetCur._lines count];
        if (cc == 8) {
            [_psv show8Labs];
        } else {
            [_psv show16Labs];
        }
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_psv) {
            [_psv removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
