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
#import "KVNProgress.h"

@interface AudioMatrixSettingViewCtrl () <AudioMatrixViewDelegate, UIScrollViewDelegate, SlideButtonDelegate>
{
    UIScrollView *_matrix;
    
    int long_press_tag;

    UIButton *_inBtn;
    UIButton *_outputBtn;
    UIButton *_muteBtn;
    
    UIView *_maskView;
    
    UILabel *_dbValue;
    
    int maxDb;
    int minDb;
    
    SlideButton *dbbtn;
}
@property (nonatomic, strong) UIView* _selectedPage;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSMutableDictionary *_outpus;

@property (nonatomic, strong) UIButton *_selectBtn;

@end

@implementation AudioMatrixSettingViewCtrl
@synthesize _selectedPage;
@synthesize _processor;
@synthesize _map;
@synthesize _outpus;

@synthesize _selectBtn;

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
    
    dbbtn = [[SlideButton alloc] initWithFrame:CGRectMake(0, 140, 120, 120)];
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
    
    

    _dbValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dbbtn.frame)+10, 120, 24)];
    _dbValue.text = @"0.0";
    _dbValue.textAlignment = NSTextAlignmentCenter;
    [_maskView addSubview:_dbValue];
    _dbValue.font = [UIFont systemFontOfSize:13];
    _dbValue.textColor = [UIColor whiteColor];
    _dbValue.layer.cornerRadius = 5;
    _dbValue.clipsToBounds = YES;
    _dbValue.backgroundColor = RGB(0x10, 0x2f, 0x3d);
    
    _dbValue.center = CGPointMake(cx, _dbValue.center.y);
    
    _muteBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _muteBtn.frame = CGRectMake(50, CGRectGetMaxY(_dbValue.frame)+10, 70, 30);
    _muteBtn.clipsToBounds = YES;
    _muteBtn.layer.cornerRadius = 3;
    _muteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_muteBtn setTitle:@"复位" forState:UIControlStateNormal];
    [_maskView addSubview:_muteBtn];
    [_muteBtn addTarget:self
                 action:@selector(clearAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _muteBtn.center = CGPointMake(cx-40, _muteBtn.center.y);
    
    UIButton *doneBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    doneBtn.frame = CGRectMake(50, CGRectGetMaxY(_dbValue.frame)+10, 70, 30);
    doneBtn.clipsToBounds = YES;
    doneBtn.layer.cornerRadius = 3;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_maskView addSubview:doneBtn];
    [doneBtn addTarget:self
                 action:@selector(doneAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    doneBtn.center = CGPointMake(cx+40, _muteBtn.center.y);
    
    
}

- (void) showMatrix{
    

    NSMutableArray *audio_ins = _processor._inAudioProxys;
    NSMutableArray *audio_outs = _processor._outAudioProxys;
    

    int maxOut = (int)[audio_outs count];
    int maxIn = (int)[audio_ins count];
    
    
    int w = 50;
    int h = 36;
    
    
    int left = (SCREEN_WIDTH - (maxIn * w))/2;
    int top = 40;
    
    int x = 0;
    int y = 0;
    
    NSMutableArray *proxyids = [NSMutableArray array];
    
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
        
        //[vap checkRgsProxyCommandLoad];
        
        
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

    IMP_BLOCK_SELF(AudioMatrixSettingViewCtrl);
    
    if([audio_outs count])
    {
        //只读取一个，因为所有的out的commands相同
        VAProcessorProxys *vap = [audio_outs objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:vap._rgsProxyObj.m_id]];
        
        if(![vap haveProxyCommandLoaded])
        {
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadAllCommands:commd_dict];
                                                    
                                                }];
        }
    }
    
    
}


- (void) loadAllCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_outs = _processor._outAudioProxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(VAProcessorProxys *vap in audio_outs)
        {
            [vap prepareLoadCommand:cmds];
        }
    }
    
    [KVNProgress dismiss];
}


- (void) doneAction:(id)sender{
    
    self._selectBtn = nil;
    [_maskView removeFromSuperview];
    
}

- (void) clearAction:(id)sender{
    
    
}

- (void) longPressedAction:(UIGestureRecognizer*)sender{
    
    UIButton *btn = (UIButton*)sender.view;
    
    if([btn isKindOfClass:[UIButton class]])
    {
        id key = [NSNumber numberWithInteger:btn.tag];
        
        long_press_tag = (int)btn.tag;
        
        self._selectBtn = btn;
        
        if([_map objectForKey:key])
        {
            
            [self.view addSubview:_maskView];
            
            int output_idx = long_press_tag/1000;
            VAProcessorProxys *outproxy = [_processor._outAudioProxys objectAtIndex:output_idx];
            NSDictionary *dic = [outproxy getMatrixCmdSettings];
            
            maxDb = [[dic objectForKey:@"max"] intValue];
            minDb = [[dic objectForKey:@"min"] intValue];
            
            int max = (maxDb - minDb);
            float v = [_selectBtn.titleLabel.text floatValue];
            if(max)
            {
                float f = (v - minDb)/max;
                _dbValue.text = _selectBtn.titleLabel.text;
                
                [dbbtn setCircleValue:f];
            }
            
            
        }
    }
}

- (void) buttonAction:(UIButton*)sender{
    
    id key = [NSNumber numberWithInteger:sender.tag];
    
    int index = (int)sender.tag;
    int output_idx = index/1000;
    int input_idx = index%1000;
    
    if(![_map objectForKey:key])
    {
        [_map setObject:@"1" forKey:key];
        
        [sender changeNormalColor:RGB(0x10, 0x2f, 0x3d)];
        
        [sender setTitle:@"0.0" forState:UIControlStateNormal];
        
        if(output_idx < [_processor._outAudioProxys count])
        {
            VAProcessorProxys *outproxy = [_processor._outAudioProxys objectAtIndex:output_idx];
            id okey = [NSNumber numberWithInt:(int)outproxy._rgsProxyObj.m_id];
            NSMutableArray *arr = [_outpus objectForKey:okey];
            if(arr == nil){
                
                arr = [NSMutableArray array];
                outproxy._setMixSrc = arr;
                
                [_outpus setObject:arr forKey:okey];
            }
           
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            VAProcessorProxys *inproxy = [_processor._inAudioProxys objectAtIndex:input_idx];
            [mdic setObject:inproxy forKey:@"proxy"];
            [mdic setObject:@"0.0" forKey:@"TH"];
            [arr addObject:mdic];
        
            [outproxy checkRgsProxyCommandLoad];
            
            [outproxy controlMatrixSrc:inproxy selected:YES];
        }
        
    }
    else
    {
        [_map removeObjectForKey:key];
        
        [sender changeNormalColor:RGB(75, 163, 202)];
        
        [sender setTitle:@"" forState:UIControlStateNormal];
        
        if(output_idx < [_processor._outAudioProxys count])
        {
            VAProcessorProxys *outproxy = [_processor._outAudioProxys objectAtIndex:output_idx];
            id okey = [NSNumber numberWithInt:(int)outproxy._rgsProxyObj.m_id];
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
                        [outproxy controlMatrixSrc:inproxy selected:NO];
                        break;
                    }
                }
            }
        }
        
    }
}



- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
   
    if(_selectBtn)
    {
        int index = (int)_selectBtn.tag;
        int output_idx = index/1000;
        int input_idx = index%1000;
        
        float th = value * (maxDb - minDb) + minDb;
        
        _dbValue.text = [NSString stringWithFormat:@"%0.1f", th];
        [_selectBtn setTitle:_dbValue.text forState:UIControlStateNormal];
        
        VAProcessorProxys *proxy = [_processor._outAudioProxys objectAtIndex:output_idx];
        id okey = [NSNumber numberWithInt:(int)proxy._rgsProxyObj.m_id];
        NSMutableArray *arr = [_outpus objectForKey:okey];
        if(arr)
        {
            VAProcessorProxys *inSelrPoxy = [_processor._inAudioProxys objectAtIndex:input_idx];
            for(NSMutableDictionary *mdic in arr)
            {
                VAProcessorProxys *inproxy = [mdic objectForKey:@"proxy"];
                if(inproxy._rgsProxyObj.m_id == inSelrPoxy._rgsProxyObj.m_id)
                {
                    [mdic setObject:[NSString stringWithFormat:@"%0.1f",th]
                             forKey:@"TH"];
                    
                    [proxy controlMatrixSrcValue:inproxy th:th];
                    break;
                }
            }
        }
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
