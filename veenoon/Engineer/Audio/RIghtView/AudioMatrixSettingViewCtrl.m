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
    
    [super setTitleAndImage:@"audio_corner_yinpinchuli.png" withTitle:@"音频处理器"];
    
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
//    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
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
    _maskView.backgroundColor = RGBA(48, 48, 48, 0.8);
    
    int cx = SCREEN_WIDTH/2;
    int cy = SCREEN_HEIGHT/2;
    
    dbbtn = [[SlideButton alloc] initWithFrame:CGRectMake(0, 140, 120, 120)];
    [_maskView addSubview:dbbtn];
    dbbtn.delegate = self;
    [dbbtn enableValueSet:YES];
    dbbtn.center = CGPointMake(cx, cy);
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(dbbtn.frame)-30, 120, 20)];
    tL.text = @"增益（dB）";
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
    

    _dbValue = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dbbtn.frame)+10, 60, 24)];
    _dbValue.text = @"0.0";
    _dbValue.textAlignment = NSTextAlignmentCenter;
    [_maskView addSubview:_dbValue];
    _dbValue.font = [UIFont systemFontOfSize:13];
    _dbValue.textColor = [UIColor whiteColor];
    _dbValue.layer.cornerRadius = 5;
    _dbValue.clipsToBounds = YES;
    _dbValue.backgroundColor = NEW_ER_BUTTON_GRAY_COLOR2;
    _dbValue.center = CGPointMake(cx, _dbValue.center.y);
    
    UIButton* btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_maskView addSubview:btnEdit];
    btnEdit.frame = CGRectMake(0, CGRectGetMaxY(dbbtn.frame)+10, 60, 24);
    btnEdit.center = CGPointMake(cx, _dbValue.center.y);
    [btnEdit addTarget:self
                action:@selector(editHighFilterFreqAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    _muteBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    _muteBtn.frame = CGRectMake(50, CGRectGetMaxY(_dbValue.frame)+10, 70, 30);
    _muteBtn.clipsToBounds = YES;
    _muteBtn.layer.cornerRadius = 3;
    _muteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_muteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_muteBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [_muteBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_maskView addSubview:_muteBtn];
    [_muteBtn addTarget:self
                 action:@selector(clearAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _muteBtn.center = CGPointMake(cx-40, _muteBtn.center.y);
    
    UIButton *doneBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    doneBtn.frame = CGRectMake(50, CGRectGetMaxY(_dbValue.frame)+10, 70, 30);
    doneBtn.clipsToBounds = YES;
    doneBtn.layer.cornerRadius = 3;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [_maskView addSubview:doneBtn];
    [doneBtn addTarget:self
                 action:@selector(doneAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    doneBtn.center = CGPointMake(cx+40, _muteBtn.center.y);
    
    
}

- (void) editHighFilterFreqAction:(id)sender{
    
    NSString *alert = @"混音值，范围[-70 ~ 12]";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alert preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"混音值";
        textField.text = _dbValue.text;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    IMP_BLOCK_SELF(AudioMatrixSettingViewCtrl);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *alValTxt = alertController.textFields.firstObject;
        
        _dbValue.text = alValTxt.text;
        
        float dbValue = [_dbValue.text floatValue];
        
        float highMax = (maxDb - minDb);
        
        
        if(highMax)
        {
            float f = (dbValue - minDb)/highMax;
            f = fabsf(f);
            [dbbtn setCircleValue:f];
        }
        
    }]];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void) showMatrix{
    

    NSMutableArray *audio_ins = _processor._inAudioProxys;
    NSMutableArray *audio_outs = _processor._outAudioProxys;
    

    int maxOut = (int)[audio_outs count];
    int maxIn = (int)[audio_ins count];
    
    
    int w = 50;
    int h = 36;
    
    
    int left = (SCREEN_WIDTH - (maxIn * w))/2;
    int top = 50;
    
    int x = 0;
    int y = 0;
    
    NSMutableArray *proxyids = [NSMutableArray array];
    
    for(int i = 0; i < maxOut; i++)
    {
         y = top + i*h;
        VAProcessorProxys *output = [audio_outs objectAtIndex:i];
        
        NSString *showName = nil;
        if (i==maxOut-1) {
            showName = @"Output";
        } else {
            showName = [NSString stringWithFormat:@"%02d", i+1];
        }
        
        output._valName = [NSString stringWithFormat:@"Out%d", i+1];
        
        UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left-w, y, w, h)];
        tL.text = showName;
        tL.textAlignment = NSTextAlignmentCenter;
        [_matrix addSubview:tL];
        tL.font = [UIFont systemFontOfSize:13];
        tL.textColor = [UIColor whiteColor];

        for(int j = 0; j < maxIn; j++)
        {
            x = left + j*w;
            
            VAProcessorProxys *vap = [audio_ins objectAtIndex:j];
            vap._valName = [NSString stringWithFormat:@"In%d", j+1];
            
            if(i == 0)
            {
                showName = nil;
                if (j==0) {
                    showName = @"Input";
                } else {
                     showName = [NSString stringWithFormat:@"%02d", j+1];
                }
               
                UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, y-20, w, 20)];
                tL.text = showName;
                tL.textAlignment = NSTextAlignmentCenter;
                [_matrix addSubview:tL];
                tL.font = [UIFont systemFontOfSize:13];
                tL.textColor = [UIColor whiteColor];
            }
            
            UIButton *btn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR
                                             selColor:NEW_ER_BUTTON_BL_COLOR];
            btn.frame = CGRectMake(x-2, y+2, w-4, h-4);
            [_matrix addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            btn.tag = i*1000+j;
            [btn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            
            
            NSString *key = vap._valName;
            NSDictionary* val =  [output._setMixSrc objectForKey:key];
            if([[val objectForKey:@"ENABLE"] isEqualToString:@"True"])
            {
                [self changeButtonState:btn ctrl:NO];
            }
            
            UILongPressGestureRecognizer *longPressBtn = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedAction:)];
            [btn addGestureRecognizer:longPressBtn];
            
        }
    }

    IMP_BLOCK_SELF(AudioMatrixSettingViewCtrl);
    
    if([audio_outs count])
    {
        //只读取一个，因为所有的out的commands相同
        VAProcessorProxys *vap = [audio_outs objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInteger:vap._rgsProxyObj.m_id]];
        
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
    float dbValue = [_dbValue.text floatValue];
    
    float highMax = (maxDb - minDb);
    
    
    if(highMax)
    {
        float f = (dbValue - minDb)/highMax;
        f = fabsf(f);
        [self processSlideButtonValue:f];
    }
    
    self._selectBtn = nil;
    
    
    [_maskView removeFromSuperview];
    
}

- (void) clearAction:(UIButton*)sender{
    self._selectBtn = nil;
    [_maskView removeFromSuperview];
    
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
    
    [self changeButtonState:sender ctrl:YES];
}

- (void) changeButtonState:(UIButton*)sender ctrl:(BOOL)ctrl{
    
    id key = [NSNumber numberWithInteger:sender.tag];
    
    int index = (int)sender.tag;
    int output_idx = index/1000;
    int input_idx = index%1000;
    
    if(![_map objectForKey:key])
    {
        [_map setObject:@"1" forKey:key];
        
        [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        [sender setTitle:@"0.0" forState:UIControlStateNormal];
        
        if(output_idx < [_processor._outAudioProxys count])
        {
            VAProcessorProxys *outproxy = [_processor._outAudioProxys objectAtIndex:output_idx];
            id okey = [NSNumber numberWithInt:(int)outproxy._rgsProxyObj.m_id];
            NSMutableArray *arr = [_outpus objectForKey:okey];
            if(arr == nil){
                
                arr = [NSMutableArray array];
                [_outpus setObject:arr forKey:okey];
            }
            
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            VAProcessorProxys *inproxy = [_processor._inAudioProxys objectAtIndex:input_idx];
            [mdic setObject:inproxy forKey:@"proxy"];
            
            [arr addObject:mdic];
            
            NSString *key = inproxy._valName;
            NSDictionary* val =  [outproxy._setMixValue objectForKey:key];
            
            if([val objectForKey:@"value"]){
                [mdic setObject:[val objectForKey:@"value"] forKey:@"TH"];
                [sender setTitle:[val objectForKey:@"value"]
                        forState:UIControlStateNormal];
            }
            else
                [mdic setObject:@"0.0" forKey:@"TH"];
            
            if(ctrl)
            {
            [outproxy checkRgsProxyCommandLoad];
            [outproxy controlMatrixSrc:inproxy selected:YES];
            }
        }
        
    }
    else
    {
        [_map removeObjectForKey:key];
        
        [sender changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
        
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
                        
                        if(ctrl)
                        {
                            [outproxy controlMatrixSrc:inproxy selected:NO];
                        }
                        
                        break;
                    }
                }
            }
        }
        
    }
}


- (void) processSlideButtonValue:(float)value{
    
    if(_selectBtn)
    {
        int index = (int)_selectBtn.tag;
        int output_idx = index/1000;
        int input_idx = index%1000;
        
        float th = value * (maxDb - minDb) + minDb;
        
        _dbValue.text = [NSString stringWithFormat:@"%0.0f", th];
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
                    [mdic setObject:[NSString stringWithFormat:@"%0.0f",th]
                             forKey:@"TH"];
                    
                    [proxy controlMatrixSrcValue:inproxy th:th];
                    break;
                }
            }
        }
    }
}

- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
   
    [self processSlideButtonValue:value];
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    IMP_BLOCK_SELF(AudioMatrixSettingViewCtrl);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(200.0 * NSEC_PER_MSEC)),
                   dispatch_get_main_queue(), ^{
                       
                       [block_self processSlideButtonValue:value];
                   });
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
