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

@interface UserWuXianHuaTongViewCtrl () {
    
}
@property (nonatomic, strong) NSMutableArray *wuxianhuatongArray;
@end

@implementation UserWuXianHuaTongViewCtrl
@synthesize wuxianhuatongArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    
    int cellWidth = 105;
    int rowGap = 15;
    int scrollHeight = 105*5 + rowGap*4;
    
    int left = (SCREEN_WIDTH - 105*6 - 5*rowGap)/2;
    
    UIScrollView *_botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(left, SCREEN_HEIGHT-scrollHeight-60 -60, SCREEN_WIDTH-2*left, scrollHeight)];
    int rowNumber = [wuxianhuatongArray count] / 6 + 1;
    int sizeHeight = rowNumber * (105 + rowGap);
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH-2*left, sizeHeight);
    _botomView.scrollEnabled=YES;
    _botomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_botomView];
    
    int index = 0;
    for (int i = 0; i < [wuxianhuatongArray count]; i++) {
        int row = index/6;
        int col = index%6;
        int startX = col*cellWidth+col*rowGap;
        int startY = row*cellWidth+rowGap*row;
        
        NSMutableDictionary *dic = [wuxianhuatongArray objectAtIndex:index];
        NSString *huatongType = [dic objectForKey:@"huatongType"];
        
        UIImage *image;
        if ([@"huatong" isEqualToString:huatongType]) {
            image = [UIImage imageNamed:@"wuxianhuatong.png"];
        } else {
            image = [UIImage imageNamed:@"wuxianhuabao.png"];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(startX, startY, cellWidth, cellWidth);
        
        [_botomView addSubview:imageView];
        
        BatteryView *batter = [[BatteryView alloc] initWithFrame:CGRectZero];
        batter.normalColor = SINGAL_COLOR;
        [imageView addSubview:batter];
        batter.center = CGPointMake(60, 18);
        
        NSString *dianliangStr = [dic objectForKey:@"dianliang"];
        int dianliang = [dianliangStr intValue];
        double dianliangDouble = 1.0f * dianliang / 100;
        [batter setBatteryValue:dianliangDouble];
        
        SignalView *signal = [[SignalView alloc] initWithFrameAndStep:CGRectMake(70, 50, 30, 20) step:2];
        [imageView addSubview:signal];
        [signal setLightColor:SINGAL_COLOR];//SINGAL_COLOR
        [signal setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
        NSString *sinalString = [dic objectForKey:@"signal"];
        int signalInt = [sinalString intValue];
        [signal setSignalValue:signalInt];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, cellWidth-30, cellWidth, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [imageView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = SINGAL_COLOR;
        titleL.text = [dic objectForKey:@"huatongName"];
        
        index++;
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
        
        NSString *huatongName = [name stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
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

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
