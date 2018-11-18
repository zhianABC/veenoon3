//
//  EngineerWirlessYaoBaoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerHandtoHandViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "HandtoHandSettingsView.h"
#import "AudioEHand2Hand.h"
#import "PlugsCtrlTitleHeader.h"
#import "LightSliderButton.h"

@interface EngineerHandtoHandViewCtrl () <CustomPickerViewDelegate, EngineerSliderViewDelegate, LightSliderButtonDelegate> {
    
    EngineerSliderView *_zengyiSlider;
    
    NSMutableArray *_imageViewArray;
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    
    NSMutableArray *_selectedBtnArray;
    
    HandtoHandSettingsView *_rightSetView;
    
    NSMutableArray *_buttonLabelArray;
    
    BOOL isSettings;
    UIButton *okBtn;
    
    UIScrollView *_botomView;
    
    UIView *_proxysView;
}
@property (nonatomic,assign) int _number;
@property (nonatomic, strong) AudioEHand2Hand *_curH2H;

@end

@implementation EngineerHandtoHandViewCtrl
@synthesize _number;
@synthesize _handToHandSysArray;
@synthesize _curH2H;

- (void) inintData {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    _buttonLabelArray = [NSMutableArray array];
    
    _imageViewArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    [self inintData];
    
    if([_handToHandSysArray count])
        self._curH2H = [_handToHandSysArray objectAtIndex:0];
    
    [super setTitleAndImage:@"audio_corner_hunyin.png" withTitle:@"有线会议"];
    
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    

    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi_n.png"]
                     frame:CGRectZero];
    
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = 20;
    _zengyiSlider.minValue = -20;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(TESLARIA_SLIDER_X, TESLARIA_SLIDER_Y);
    [_zengyiSlider setScaleValue:_curH2H._dbVal];
    
    [self.view addSubview:_zengyiSlider];
    
    
    int niumber = [_curH2H channelsCount];
    
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
    
    [self refreshView:niumber];
}

- (void) handleTapGesture:(id)sender{
    
    if ([_rightSetView superview]) {
        
        CGRect rc = _rightSetView.frame;
        [UIView animateWithDuration:0.25
                         animations:^{
                             _rightSetView.frame = CGRectMake(SCREEN_WIDTH,
                                                           rc.origin.y,
                                                           rc.size.width,
                                                           rc.size.height);
                         } completion:^(BOOL finished) {
                             [_rightSetView removeFromSuperview];
                         }];
    }
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
}

- (void) createBtnLabel:(UIButton*)sender name:(NSString*) name{
   
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sender.frame.size.width, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [sender addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:11];
    titleL.textColor  = [UIColor whiteColor];
    
    titleL.text = name;
    
    [_buttonChannelArray addObject:titleL];
}

- (void) didSliderValueChanged:(float)value object:(id)object {
    
    _curH2H._dbVal = value;
}

-(void)scenarioAction:(id)sender {
    
    UIButton *button = (UIButton*) sender;
    int tag = (int) button.tag;
    
    UIButton *btn;
    for (UIButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        
        UIButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = YELLOW_COLOR;
        
        NSMutableDictionary *channel = [_curH2H channelAtIndex:tag];
        [channel setObject:@"ON" forKey:@"status"];
        
        [button setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = [UIColor whiteColor];
        
        [button setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
    
        NSMutableDictionary *channel = [_curH2H channelAtIndex:tag];
        [channel setObject:@"OFF" forKey:@"status"];
    }
}

- (void) sysSelectAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    if (!isSettings) {
        if (_rightSetView == nil) {
            _rightSetView = [[HandtoHandSettingsView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightSetView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                              64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        
        [self.view addSubview:_rightSetView];
        [okBtn setTitle:@"关闭" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightSetView) {
            [_rightSetView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
    
    _rightSetView.delegate_ = self;
}
- (void) refreshView:(int)number {
    int index = 0;
    int top = 74;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    if (_botomView) {
        for (UIView *view in [_botomView subviews]) {
            if (view) {
                [view removeFromSuperview];
            }
        }
    } else {
        _botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, top, SCREEN_WIDTH- ENGINEER_VIEW_LEFT*2, SCREEN_HEIGHT - top-50)];
        [self.view addSubview:_botomView];
        _botomView.backgroundColor = [UIColor clearColor];
    }
    
    int rowN = number / ENGINEER_VIEW_COLUMN_N;
    int ySpace = 15;
    int height = rowN * 120 + (rowN -1) * 10;
    
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH-ENGINEER_VIEW_LEFT*2, height);
    _botomView.scrollEnabled=YES;
    _botomView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < number; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space;
        int startY = row*cellHeight+ySpace*row+20;
        if (row>=1) {
            startY-=20;
        }
        
        
        LightSliderButton *btn = [[LightSliderButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        btn.tag = i;
        btn.delegate = self;
        [_botomView addSubview:btn];
        btn._grayBackgroundImage = [UIImage imageNamed:@"dianyuanshishiqi_n.png"];
        btn._lightBackgroundImage = [UIImage imageNamed:@"dianyuanshishiqi_s.png"];
        [btn hiddenProgress];
        [btn turnOnOff:NO];
        [btn enableValueSet:NO];
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-40, 0, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [@"CH " stringByAppendingString:[NSString stringWithFormat:@"0%d",i+1]];
        [_buttonLabelArray addObject:titleL];
        
        [_buttonArray addObject:btn];
        
        
        index++;
    }
}


- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    BOOL offOn = slbtn._isEnabel;
    if (offOn) {
        UILabel *numberL = [_buttonLabelArray objectAtIndex:slbtn.tag];
        numberL.textColor = [UIColor whiteColor];;
        
        [slbtn enableValueSet:NO];
    } else {
        UILabel *numberL = [_buttonLabelArray objectAtIndex:slbtn.tag];
        numberL.textColor = YELLOW_COLOR;
        
        [slbtn enableValueSet:YES];
    }
}

- (void) didEndEditCell:(int)number {
    [self refreshView:number];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
