//
//  EngineerPVExpendViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/20.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPVExpendViewCtrl.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "SlideButton.h"


@interface EngineerPVExpendViewCtrl () <EngineerSliderViewDelegate, SlideButtonDelegate, CustomPickerViewDelegate>{
    
    EngineerSliderView *_zengyiSlider;
    
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_selectedBtnArray;
    
    NSMutableArray *_imageViewArray;
    BOOL isSettings;
    UIButton *okBtn;
}

@end

@implementation EngineerPVExpendViewCtrl
@synthesize _number;
@synthesize _pvExpendArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    isSettings = NO;
    
    _buttonArray = [[NSMutableArray alloc] init];
    
    _selectedBtnArray = [[NSMutableArray alloc] init];
    _imageViewArray = [[NSMutableArray alloc] init];
    
    [super setTitleAndImage:@"audio_corner_gongfang.png" withTitle:@"功率"];
    
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
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi3.png"]
                     frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = 0;
    _zengyiSlider.minValue = -70;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT/2);
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 240;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    for (int i = 0; i < _number; i++) {
        NSMutableDictionary *dataDic;
        if (_pvExpendArray && [_pvExpendArray count] > 0) {
            dataDic = [_pvExpendArray objectAtIndex:i];
        }
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIView *conmponentView = [[UIView alloc] init];
        conmponentView.userInteractionEnabled = YES;
        conmponentView.frame = CGRectMake(startX, startY, 120, 200);
        [self.view addSubview:conmponentView];
        
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, startY, 92, 120)];
        btn.delegate = self;
        btn.tag = i;
        [self.view addSubview:btn];
        
        btn._titleLabel.text = [NSString stringWithFormat:@"Channel %02d",i+1];
        
            
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(0, 120, 120, 100);
        titleView.alpha = 0.8;
        titleView.userInteractionEnabled = YES;
        [conmponentView addSubview:titleView];
        
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -40, btn.frame.size.height - 110, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [titleView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:14];
        titleL.textColor  = YELLOW_COLOR;
        titleL.textAlignment = NSTextAlignmentCenter;
        NSString *temp = @"38C";
        if (dataDic != nil) {
            temp = [dataDic objectForKey:@"temp"];
        }
        titleL.text = [@"温度： " stringByAppendingString:temp];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -40, btn.frame.size.height-80, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [titleView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:14];
        titleL.textColor  = YELLOW_COLOR;
        titleL.textAlignment = NSTextAlignmentCenter;
        NSString *dianya = @"36V";
        if (dataDic != nil) {
            dianya = [dataDic objectForKey:@"dianya"];
        }
        titleL.text = [@"电压： " stringByAppendingString:dianya];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -40, btn.frame.size.height -50, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [titleView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:14];
        titleL.textColor  = YELLOW_COLOR;
        titleL.textAlignment = NSTextAlignmentCenter;
        NSString *dianliu = @"36A";
        if (dataDic != nil) {
            dianliu = [dataDic objectForKey:@"dianliu"];
        }
        titleL.text = [@"电流： " stringByAppendingString:dianliu];
        
        [_imageViewArray addObject:titleView];
        [_buttonArray addObject:btn];
        
        index++;
    }
}
- (void) didSliderValueChanged:(float)value object:(id)object {
    float circleValue = value;
    for (SlideButton *button in _selectedBtnArray) {
        
        button._valueLabel.text = [NSString stringWithFormat:@"%0.1f db", circleValue];
        [button setCircleValue:fabs((value+70)/82.0)];
    }
}
//value = 0....1
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float circleValue = -70 + (value * 82);
    slbtn._valueLabel.text = [NSString stringWithFormat:@"%0.1f db", circleValue];
}


- (void) didTappedMSelf:(SlideButton*)slbtn{
    
    int tag = (int)slbtn.tag;
    
    SlideButton *btn = nil;
    for (SlideButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    
    UIView *titleView = [_imageViewArray objectAtIndex:tag];
    // want to choose it
    if (btn == nil) {
        SlideButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        
        [button enableValueSet:YES];
        
         titleView.alpha = 1.0;
        
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        
        [btn enableValueSet:NO];
        
        titleView.alpha = 0.8;
    }
}


- (void) scenarioAction:(id)sender{
    
}


- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
