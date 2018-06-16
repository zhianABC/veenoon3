//
//  UserWuXianHuaTongViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserWuXianHuaTongViewCtrl.h"
#import "BatteryView.h"
#import "SignalView.h"
#import "SlideButton.h"

@interface UserWuXianHuaTongViewCtrl () {
    NSMutableArray *_buttonNumberArray;
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *signalArray;
    NSMutableArray *_imageViewArray;
    NSMutableArray *_buttonArray;
    NSMutableArray *_selectedBtnArray;
}

@property (nonatomic, strong) NSMutableArray *wuxianhuatongArray;
@end

@implementation UserWuXianHuaTongViewCtrl
@synthesize wuxianhuatongArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"user_corner_huatong.png" withTitle:@"无线手持话筒"];
    
    [self initData];
    
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    signalArray = [[NSMutableArray alloc] init];
    _imageViewArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
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
    
    int index = 0;
    int top = 15;
    
    int leftRight = ENGINEER_VIEW_LEFT-20;
    
    int cellWidth = 105;
    int cellHeight = 220;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    int scrollHeight = SCREEN_HEIGHT - 250;
    
    UIScrollView *_botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRight, SCREEN_HEIGHT-scrollHeight-60 -60, SCREEN_WIDTH-2*leftRight, scrollHeight)];
    int rowNumber = (int) [wuxianhuatongArray count] / colNumber + 1;
    int sizeHeight = rowNumber * (220 + space);
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH-2*leftRight, sizeHeight);
    _botomView.scrollEnabled=YES;
    [self.view addSubview:_botomView];
    
    for (int i = 0; i < [wuxianhuatongArray count]; i++) {
        NSMutableDictionary *dataDic = [wuxianhuatongArray objectAtIndex:i];
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, cellWidth, 240)];
        view.userInteractionEnabled = YES;
        view.backgroundColor = [UIColor clearColor];
        [_botomView addSubview:view];
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 120)];
        [view addSubview:btn];
        
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = i;
        [btn addGestureRecognizer:tapGesture];
        
        btn.tag = i;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 - 30, 0, 60, 20)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor clearColor];
        [view addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [NSString stringWithFormat:@"0%d",i+1];
        [_buttonNumberArray addObject:titleL];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -50, btn.frame.size.height - 20, 100, 20)];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor clearColor];
        [view addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"Channel";
        [_buttonChannelArray addObject:titleL];
        
        UIView *signalView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, cellWidth, 120)];
        [view addSubview:signalView];
        signalView.alpha=0.8;
        [signalArray addObject:signalView];
        
        UIImage *image;
        NSString *huatongType = [dataDic objectForKey:@"type"];
        if ([@"huatong" isEqualToString:huatongType]) {
            image = [UIImage imageNamed:@"huatong_yellow_n.png"];
        } else {
            image = [UIImage imageNamed:@"yaobao_yellow_n.png"];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(40, 40);
        [signalView addSubview:imageView];
        
        
        BatteryView *batter = [[BatteryView alloc] initWithFrame:CGRectZero];
        batter.normalColor = [UIColor whiteColor];
        [signalView addSubview:batter];
        batter.center = CGPointMake(60, 20);
        
        NSString *dianliangStr = [dataDic objectForKey:@"dianliang"];
        int dianliang = [dianliangStr intValue];
        double dianliangDouble = 1.0f * dianliang / 100;
        [batter setBatteryValue:dianliangDouble];
        
        SignalView *signal = [[SignalView alloc] initWithFrameAndStep:CGRectMake(70, 40, 30, 20) step:2];
        [signalView addSubview:signal];
        [signal setLightColor:[UIColor whiteColor]];//
        [signal setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
        NSString *sinalString = [dataDic objectForKey:@"signal"];
        int signalInt = [sinalString intValue];
        [signal setSignalValue:signalInt];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, 20, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [signalView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        NSString *title = @"优";
        if (3 <= signalInt < 5) {
            title = @"良";
        } else if (signalInt < 3) {
            title = @"差";
        }
        
        titleL.text = title;
        
        [_imageViewArray addObject:imageView];
        [_buttonArray addObject:btn];
        
        index++;
    }
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    int tag = (int) gestureRecognizer.view.tag;
    
    SlideButton *btn;
    for (SlideButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        SlideButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        [button enableValueSet:YES];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = YELLOW_COLOR;
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = YELLOW_COLOR;
        
        UIView *signalView = [signalArray objectAtIndex:tag];
        [signalView setAlpha:1];
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        [btn enableValueSet:NO];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = [UIColor whiteColor];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = [UIColor whiteColor];
        
        UIView *signalView = [signalArray objectAtIndex:tag];
        [signalView setAlpha:0.8];
    }
}

- (void) initData {
    if (wuxianhuatongArray) {
        [wuxianhuatongArray removeAllObjects];
    } else {
        wuxianhuatongArray = [[NSMutableArray alloc] init];
    }
    
    NSString *name = @"jack";
    int signal = 1;
    int dianliang = 20;
    for (int i = 0 ;i < 31;i++) {
        
        NSString *huatongType = @"huatong";
        if (i % 2 == 0) {
            huatongType = @"huabao";
        }
        NSString *huatongName =@"";
        if (name) {
            huatongName = [name stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
        }
        
        NSString *dianliangStr = [NSString stringWithFormat:@"%d",dianliang];
        NSString *signalStr = [NSString stringWithFormat:@"%d",signal];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    huatongName, @"huatongName",
                                    signalStr, @"signal",
                                    dianliangStr, @"dianliang",
                                    huatongType, @"huatongType",
                                     nil];
        dianliang++;
        signal++;
        if (signal > 5) {
            signal = 0;
        }
        
        [wuxianhuatongArray addObject:dic];
    }
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"huatongType" ascending:NO]];
    [wuxianhuatongArray sortUsingDescriptors:sortDescriptors];
    
}
- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
