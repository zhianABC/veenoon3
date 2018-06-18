//
//  AudioMatrixSettingViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioMatrixSettingViewCtrl.h"
#import "UIButton+Color.h"
#import "AudioMatrixView.h"
#import "SlideButton.h"
#import "AudioEProcessor.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"

@interface AudioMatrixSettingViewCtrl () <AudioMatrixViewDelegate, UIScrollViewDelegate, SlideButtonDelegate>
{
    UIScrollView *_matrix;
    
    int long_press_tag;

    UIButton *_inBtn;
    UIButton *_outputBtn;
    UIButton *_muteBtn;
    
    UIView *_maskView;
    
    UILabel *_dbValue;
}
@property (nonatomic, strong) UIView* _selectedPage;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSMutableDictionary *_outpus;;

@end

@implementation AudioMatrixSettingViewCtrl
@synthesize _selectedPage;
@synthesize _processor;
@synthesize _map;
@synthesize _outpus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DARK_GRAY_COLOR;
    
    UIView* _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topBar.backgroundColor = DARK_GRAY_COLOR;
    [self.view addSubview:_topBar];
    
    UILabel* centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleLabel.textColor = [UIColor whiteColor];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_topBar addSubview:centerTitleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = TITLE_LINE_COLOR;
    [_topBar addSubview:line];
    
    centerTitleLabel.text = @"矩阵路由";
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    _matrix = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,
                                                             SCREEN_WIDTH,
                                                             SCREEN_HEIGHT-114)];
    [self.view addSubview:_matrix];
    
    self._map = [NSMutableDictionary dictionary];
    self._outpus = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(AudioMatrixSettingViewCtrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        [block_self showMatrix];
        
    });
    
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskView.backgroundColor = RGBA(0, 89, 118, 0.6);
    
    int cx = SCREEN_WIDTH/2;
    int cy = SCREEN_HEIGHT/2;
    
    SlideButton *dbbtn = [[SlideButton alloc] initWithFrame:CGRectMake(0, 140, 120, 120)];
    [_maskView addSubview:dbbtn];
    dbbtn.delegate = self;
    [dbbtn enableValueSet:YES];
    dbbtn.center = CGPointMake(cx, cy);
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(dbbtn.frame)-30, 120, 20)];
    tL.text = @"增益（db）";
    tL.textAlignment = NSTextAlignmentCenter;
    [_maskView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    tL.center = CGPointMake(cx, tL.center.y);
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(tL.frame)-30, 350, 20)];
    title.text = @"混音值";
    title.textAlignment = NSTextAlignmentCenter;
    [_maskView addSubview:title];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor whiteColor];
    
    title.center = CGPointMake(cx, title.center.y);
    
    

    _dbValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dbbtn.frame)+10, 120, 20)];
    _dbValue.text = @"0.0";
    _dbValue.textAlignment = NSTextAlignmentCenter;
    [_maskView addSubview:_dbValue];
    _dbValue.font = [UIFont systemFontOfSize:16];
    _dbValue.textColor = [UIColor whiteColor];
    _dbValue.layer.cornerRadius = 5;
    _dbValue.clipsToBounds = YES;
    _dbValue.backgroundColor = RGB(0x10, 0x2f, 0x3d);
    
    _dbValue.center = CGPointMake(cx, _dbValue.center.y);
    
    _muteBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _muteBtn.frame = CGRectMake(50, CGRectGetMaxY(_dbValue.frame)+10, 70, 30);
    _muteBtn.clipsToBounds = YES;
    _muteBtn.layer.cornerRadius = 8;
    _muteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_muteBtn setTitle:@"静音" forState:UIControlStateNormal];
    _muteBtn.userInteractionEnabled = NO;
    //[_inBtn setTitleColor: forState:UIControlStateNormal];
    [_maskView addSubview:_muteBtn];
    
    _muteBtn.center = CGPointMake(cx, _muteBtn.center.y);
    
    
    
}

- (void) showMatrix{
    
    NSMutableArray *audio_ins = _processor._inAudioProxys;
    NSMutableArray *audio_outs = _processor._outAudioProxys;
    
    int maxOut = [audio_outs count];
    int maxIn = [audio_ins count];
    
    
    int w = 50;
    int h = 36;
    
    
    int left = (SCREEN_WIDTH - (maxIn * w))/2;
    int top = 40;
    
    int x = 0;
    int y = 0;
    for(int i = 0; i < maxOut; i++)
    {
         y = top + i*h;
        VAProcessorProxys *vap = [audio_outs objectAtIndex:i];
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left-w, y, w, h)];
        tL.text = vap._rgsProxyObj.name;
        tL.textAlignment = NSTextAlignmentCenter;
        [_matrix addSubview:tL];
        tL.font = [UIFont systemFontOfSize:13];
        tL.textColor = [UIColor whiteColor];
        
        [vap checkRgsProxyCommandLoad];
        
        for(int j = 0; j < maxIn; j++)
        {
            x = left + j*w;
            
            if(i == 0)
            {
                VAProcessorProxys *vap = [audio_ins objectAtIndex:j];
                UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y-20, w, 20)];
                tL.text = vap._rgsProxyObj.name;
                tL.textAlignment = NSTextAlignmentCenter;
                [_matrix addSubview:tL];
                tL.font = [UIFont systemFontOfSize:13];
                tL.textColor = [UIColor whiteColor];
            }
            
            UIButton *btn = [UIButton buttonWithColor:RGB(75, 163, 202)
                                             selColor:nil];
            btn.frame = CGRectMake(x-2, y+2, w-4, h-4);
            [_matrix addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            btn.tag = i*1000+j;
            [btn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            UILongPressGestureRecognizer *longPressBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedAction:)];
            [btn addGestureRecognizer:longPressBtn];
            
        }
    }
    
}

- (void) longPressedAction:(UIGestureRecognizer*)sender{
    
    UIView *view = sender.view;
    id key = [NSNumber numberWithInteger:view.tag];
    
    long_press_tag = view.tag;
    
    if([_map objectForKey:key])
    {
        
        [self.view addSubview:_maskView];
        
    }
}

- (void) buttonAction:(UIButton*)sender{
    
    id key = [NSNumber numberWithInteger:sender.tag];
    
    int index = sender.tag;
    int output_idx = index/1000;
    int input_idx = index%1000;
    
    if(![_map objectForKey:key])
    {
        [_map setObject:@"1" forKey:key];
        
        [sender changeNormalColor:RGB(0x10, 0x2f, 0x3d)];
        
        [sender setTitle:@"0.0" forState:UIControlStateNormal];
        
        if(output_idx < [_processor._outAudioProxys count])
        {
            VAProcessorProxys *proxy = [_processor._outAudioProxys objectAtIndex:output_idx];
            id okey = [NSNumber numberWithInt:proxy._rgsProxyObj.m_id];
            NSMutableArray *arr = [_outpus objectForKey:okey];
            if(arr == nil){
                arr = [NSMutableArray array];
                [_outpus setObject:arr forKey:okey];
            }
           
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            VAProcessorProxys *inproxy = [_processor._inAudioProxys objectAtIndex:input_idx];
            [mdic setObject:inproxy forKey:@"proxy"];
            [mdic setObject:@"0.0" forKey:@"TH"];
            
            [arr addObject:mdic];
        }
        
    }
    else
    {
        [_map removeObjectForKey:key];
        
        [sender changeNormalColor:RGB(75, 163, 202)];
        
        [sender setTitle:@"" forState:UIControlStateNormal];
        
        if(output_idx < [_processor._outAudioProxys count])
        {
            VAProcessorProxys *proxy = [_processor._outAudioProxys objectAtIndex:output_idx];
            id okey = [NSNumber numberWithInt:proxy._rgsProxyObj.m_id];
            NSMutableArray *arr = [_outpus objectForKey:okey];
            if(arr)
            {
                VAProcessorProxys *inSelrPoxy = [_processor._inAudioProxys objectAtIndex:input_idx];
                for(NSDictionary *dic in arr)
                {
                    VAProcessorProxys *inproxy = [dic objectForKey:@"proxy"];
                    
                    if(inproxy._rgsProxyObj.m_id == inSelrPoxy._rgsProxyObj.m_id)
                    {
                        [arr removeObject:dic];
                        break;
                    }
                }
            }
        }
        
    }
}

- (void) didSlideButtonValueChanged:(float)value{
    
    float fv = (value * 10.0);
    if([self._selectedPage isKindOfClass:[AudioMatrixView class]])
    {
        [((AudioMatrixView*)_selectedPage) changeValue:fv];
    }
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
