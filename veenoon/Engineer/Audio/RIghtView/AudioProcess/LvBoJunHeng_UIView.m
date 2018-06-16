//
//  LvBoJunHeng_UIView.m
//  veenoon
//
//  Created by 安志良 on 2018/2/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "LvBoJunHeng_UIView.h"
#import "veenoon-Swift.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "VAProcessorProxys.h"
#import "RegulusSDK.h"
#import "LvBoJunHeng_Chooser.h"


@interface LvBoJunHeng_UIView() <SlideButtonDelegate, VAProcessorProxysDelegate>{
    
    SlideButton *gaotongFeqSlider;
    SlideButton *ditongXielvSlider;
    
    SlideButton *boduanPinLvSlider;
    SlideButton *boduanZengyiSlider;
    SlideButton *boduanQSlider;
    
    UILabel *gaotongFeqL;
    UILabel *ditongXielvL;
    UILabel *boduanPinlvL;
    UILabel *boduanQL;
    UILabel *boduanZengyiL;
    
    FilterGraphView *fglm;
    
    int _channelSelIndex;
    
    UIButton *gaotongTypeBtn;
    
    UIPopoverController *_deviceSelector;
    
    UIButton *ditongTypeBtn;
    
    UIButton *gaotongXielvBtn;
    
    UIButton *boduanleixingBtn;
    
    UIButton *ditongxielvBtn;
    
    UIButton *gaotongStartBtn;
    UIButton *buduanStartBtn;
    UIButton *ditongStartBtn;
}

@property (nonatomic, strong) NSMutableArray *_boduanChannelBtns;
@property (nonatomic, strong) VAProcessorProxys *_curProxy;

@end

@implementation LvBoJunHeng_UIView
@synthesize _boduanChannelBtns;
@synthesize _curProxy;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) dealloc
{
    _curProxy.delegate = nil;
}

- (id)initWithFrameProxys:(CGRect)frame withProxys:(NSArray*) proxys {
    self._proxys = proxys;
    
    if (self = [super initWithFrame:frame]) {
        
        if (self._curProxy == nil) {
            if (self._proxys) {
                self._curProxy = [self._proxys objectAtIndex:0];
            }
        }
        
        CGRect rc = CGRectMake(0, 10, frame.size.width, 280);
        UIView *bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        rc = CGRectMake(0, 300, frame.size.width/4 -10, 200);
        bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        [self createGaoTong:bgv];
        
        rc = CGRectMake(frame.size.width/4, 300, frame.size.width/2, 200);
        bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        [self createBoDuan:bgv];
        
        rc = CGRectMake(frame.size.width/4 *3 +10, 300, frame.size.width/4-10, 200);
        bgv = [[UIView alloc] initWithFrame:rc];
        [self addSubview:bgv];
        bgv.layer.cornerRadius = 5;
        bgv.clipsToBounds = YES;
        bgv.backgroundColor = RGB(0, 89, 118);
        
        [self createDiTong:bgv];
        
        
        rc = CGRectMake(10, 20, frame.size.width-20, 260);
        fglm = [[FilterGraphView alloc] initWithFrame:rc];
        fglm.backgroundColor = [UIColor clearColor];
        [self addSubview:fglm];
        
    }
    
    return self;
}

- (void) createGaoTong:(UIView*)view {
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"高通";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize: 15];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(0, 5, view.frame.size.width, 25);
    [view addSubview:addLabel];
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"类型";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(10, 35, view.frame.size.width, 25);
    [view addSubview:addLabel2];
    
    int btnStartX = 10;
    int btnY = 50;
    gaotongTypeBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    gaotongTypeBtn.frame = CGRectMake(btnStartX+60, btnY-20, 100, 30);
    gaotongTypeBtn.layer.cornerRadius = 5;
    gaotongTypeBtn.layer.borderWidth = 2;
    gaotongTypeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    gaotongTypeBtn.clipsToBounds = YES;
    gaotongTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    gaotongTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(gaotongTypeBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [gaotongTypeBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [gaotongTypeBtn addTarget:self
                action:@selector(leixingBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gaotongTypeBtn];
    
    
    UILabel *addLabel3 = [[UILabel alloc] init];
    addLabel3.text = @"频率 (HZ)";
    addLabel3.font = [UIFont systemFontOfSize: 13];
    addLabel3.textColor = [UIColor whiteColor];
    addLabel3.frame = CGRectMake(CGRectGetMaxX(gaotongTypeBtn.frame)-35, btnY+20, 75, 25);
    [view addSubview:addLabel3];
    
    btnY+=35;
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"斜率";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(10, btnY, view.frame.size.width, 25);
    [view addSubview:addLabel22];
    
    btnY+=30;
    gaotongXielvBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    gaotongXielvBtn.frame = CGRectMake(btnStartX, btnY, 100, 30);
    gaotongXielvBtn.layer.cornerRadius = 5;
    gaotongXielvBtn.layer.borderWidth = 2;
    gaotongXielvBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    gaotongXielvBtn.clipsToBounds = YES;
    gaotongXielvBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    gaotongXielvBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon2 = [[UIImageView alloc]
                         initWithFrame:CGRectMake(gaotongXielvBtn.frame.size.width - 20, 10, 10, 10)];
    icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
    [gaotongXielvBtn addSubview:icon2];
    icon2.alpha = 0.8;
    icon2.layer.contentsGravity = kCAGravityResizeAspect;
    [gaotongXielvBtn addTarget:self
                   action:@selector(gaotongxielvAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gaotongXielvBtn];
    
    gaotongFeqSlider = [[SlideButton alloc] initWithFrame:CGRectMake(100, 70, 120, 120)];
    gaotongFeqSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    gaotongFeqSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [gaotongFeqSlider enableValueSet:YES];
    gaotongFeqSlider.delegate = self;
    gaotongFeqSlider.tag = 1;
    [view addSubview:gaotongFeqSlider];

    gaotongFeqL = [[UILabel alloc] initWithFrame:CGRectMake(100, 180, 120, 20)];
    gaotongFeqL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:gaotongFeqL];
    gaotongFeqL.font = [UIFont systemFontOfSize:13];
    gaotongFeqL.textColor = YELLOW_COLOR;
    
    
    gaotongStartBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    gaotongStartBtn.frame = CGRectMake(10, view.frame.size.height - 30, 50, 25);
    gaotongStartBtn.layer.cornerRadius = 5;
    gaotongStartBtn.layer.borderWidth = 2;
    gaotongStartBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    gaotongStartBtn.clipsToBounds = YES;
    [gaotongStartBtn setTitle:@"启用" forState:UIControlStateNormal];
    gaotongStartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [gaotongStartBtn addTarget:self
                   action:@selector(gaotongStartBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gaotongStartBtn];
    
   
}
- (void) gaotongStartBtnAction:(id) sender {
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy isLvboGaotongStart];
    
    [_curProxy controlLVboGaotongStart:!isMute];
    
    BOOL isFanKuiYiZhi = [_curProxy isLvboGaotongStart];
    
    if(isFanKuiYiZhi)
    {
        [gaotongStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [gaotongStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
- (void) gaotongxielvAction:(UIButton*) sender {
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    LvBoJunHeng_Chooser *sel = [[LvBoJunHeng_Chooser alloc] init];
    sel._dataArray = [_curProxy getLvBoGaoTongXielvArray];
    sel._type = 2;
    
    int h = [sel._dataArray count]*30 + 50;
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(LvBoJunHeng_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseGaotongXieLv:object idx:index];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:[sender superview]];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseGaotongXieLv:(NSString*)device idx:(int)index{
    
    if (device == nil) {
        return;
    }
   
    //Show
    NSString *dispaly = [NSString stringWithFormat:@"  %@",device];
    [gaotongXielvBtn setTitle:dispaly forState:UIControlStateNormal];
    
    //控制
    [_curProxy controlGaoTongXieLv:device];
    
    [fglm setHPFilterWithSlope:index];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

- (void) leixingBtnAction:(UIButton*) sender {
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    LvBoJunHeng_Chooser *sel = [[LvBoJunHeng_Chooser alloc] init];
    sel._dataArray = [_curProxy getLvBoGaoTongArray];
    sel._type = 0;
    
    int h = [sel._dataArray count]*30 + 50;
    
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(LvBoJunHeng_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseGaotong:object idx:index];
    };
    
    CGRect rect = [self convertRect:sender.frame
                                fromView:[sender superview]];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseGaotong:(NSString*)device idx:(int)index{
    if (device == nil) {
        return;
    }
    NSString *dispaly = [@"   " stringByAppendingString:device];
    
    [gaotongTypeBtn setTitle:dispaly forState:UIControlStateNormal];
    
    [_curProxy controlGaoTongType:device];
    
    [fglm setHPFilterWithType:index];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

- (void) createBoDuan:(UIView*)view {
    
    int num = 16;
    
    self._boduanChannelBtns = [NSMutableArray array];
    
    float x = 15;
    int y = 10;
    int bw = 40;
    int bh = 25;
    
    _channelSelIndex = 0;
    
    float spx = (view.frame.size.width - bw * 8 - x *2)/7;
    if(spx > 10)
        spx = 10;
    
    for(int i = 0; i < num; i++) {
        UIButton *btn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
        btn.frame = CGRectMake(x+15, y, bw, bh);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        btn.tag = i;
        [view addSubview:btn];
        
        if(i == 0)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        }
        
        [btn addTarget:self
                action:@selector(boduanChannelBtnAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 7) {
            x = 15;
            y += bh + spx;
        } else {
            x+=bw;
            x+=spx;
        }
        
        [_boduanChannelBtns addObject:btn];
    }
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"类型";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(10, 95, view.frame.size.width, 25);
    [view addSubview:addLabel2];
    
    int btnStartX = 10;
    int btnY = 125;
    boduanleixingBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    boduanleixingBtn.frame = CGRectMake(btnStartX, btnY, 100, 30);
    boduanleixingBtn.layer.cornerRadius = 5;
    boduanleixingBtn.layer.borderWidth = 2;
    boduanleixingBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    boduanleixingBtn.clipsToBounds = YES;
   
    boduanleixingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    boduanleixingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(boduanleixingBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [boduanleixingBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [boduanleixingBtn addTarget:self
                   action:@selector(boduantypeAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:boduanleixingBtn];
    
    
    int startX = 120;
    int gap = 100;
    int labelY = 80;
    int labelBtnGap = 0;
    int weiYi = 20;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"频率 (Hz)";
    addLabel.font = [UIFont systemFontOfSize: 13];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(startX+weiYi+12, labelY, 120, 20);
    [view addSubview:addLabel];
    
    boduanPinLvSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap, 120, 120)];
    boduanPinLvSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    boduanPinLvSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [boduanPinLvSlider enableValueSet:YES];
    boduanPinLvSlider.delegate = self;
    boduanPinLvSlider.tag = 3;
    [view addSubview:boduanPinLvSlider];
    
    NSString *boduanPinlv = [_curProxy getlvboBoduanPinlv];
    float boduanPinlvvalue = [boduanPinlv floatValue];
    float boduanPinlvvaluef = (boduanPinlvvalue+12.0)/24.0;
    [boduanPinLvSlider setCircleValue:boduanPinlvvaluef];
    
    boduanPinlvL = [[UILabel alloc] initWithFrame:CGRectMake(startX, labelY+labelBtnGap+95, 120, 20)];
    if (boduanPinlv) {
        boduanPinlvL.text = [boduanPinlv stringByAppendingString:@" Hz"];
    }
    
    boduanPinlvL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:boduanPinlvL];
    boduanPinlvL.font = [UIFont systemFontOfSize:13];
    boduanPinlvL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel23 = [[UILabel alloc] init];
    addLabel23.text = @"增益 (dB)";
    addLabel23.font = [UIFont systemFontOfSize: 13];
    addLabel23.textColor = [UIColor whiteColor];
    addLabel23.frame = CGRectMake(startX+gap+weiYi+10, labelY, 120, 20);
    [view addSubview:addLabel23];
    
    boduanZengyiSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap, 120, 120)];
    boduanZengyiSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    boduanZengyiSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [boduanZengyiSlider enableValueSet:YES];
    boduanZengyiSlider.delegate = self;
    boduanZengyiSlider.tag = 4;
    [view addSubview:boduanZengyiSlider];
    
    NSString *boduanZengYi = [_curProxy getlvboBoduanZengyi];
    float boduanZengYivalue = [boduanZengYi floatValue];
    float boduanZengYivaluef = (boduanZengYivalue+12.0)/24.0;
    [boduanPinLvSlider setCircleValue:boduanZengYivaluef];
    
    boduanZengyiL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap, labelY+labelBtnGap+95, 120, 20)];
    if (boduanZengYi) {
        boduanZengyiL.text = [boduanZengYi stringByAppendingString:@" dB"];
    }
    
    boduanZengyiL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:boduanZengyiL];
    boduanZengyiL.font = [UIFont systemFontOfSize:13];
    boduanZengyiL.textColor = YELLOW_COLOR;
    
    UILabel *addLabel224= [[UILabel alloc] init];
    addLabel224.text = @"Q";
    addLabel224.font = [UIFont systemFontOfSize: 13];
    addLabel224.textColor = [UIColor whiteColor];
    addLabel224.frame = CGRectMake(startX+gap*2+weiYi+33, labelY, 120, 20);
    [view addSubview:addLabel224];
    
    boduanQSlider = [[SlideButton alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap, 120, 120)];
    boduanQSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    boduanQSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [boduanQSlider enableValueSet:YES];
    boduanQSlider.delegate = self;
    boduanQSlider.tag = 5;
    [view addSubview:boduanQSlider];
    
    NSString *boduanQ = [_curProxy getlvboBoduanZengyi];
    float boduanQvalue = [boduanQ floatValue];
    float boduanQvaluef = (boduanQvalue+12.0)/24.0;
    [boduanQSlider setCircleValue:boduanQvaluef];
    
    boduanQL = [[UILabel alloc] initWithFrame:CGRectMake(startX+gap*2, labelY+labelBtnGap+95, 120, 20)];
    if (boduanQ) {
        boduanQL.text = [boduanQ stringByAppendingString:@" dB"];
    }
    
    boduanQL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:boduanQL];
    boduanQL.font = [UIFont systemFontOfSize:13];
    boduanQL.textColor = YELLOW_COLOR;
    
    buduanStartBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    buduanStartBtn.frame = CGRectMake(10, view.frame.size.height - 30, 50, 25);
    buduanStartBtn.layer.cornerRadius = 5;
    buduanStartBtn.layer.borderWidth = 2;
    buduanStartBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    buduanStartBtn.clipsToBounds = YES;
    [buduanStartBtn setTitle:@"启用" forState:UIControlStateNormal];
    buduanStartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [buduanStartBtn addTarget:self
                    action:@selector(boduanStartBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buduanStartBtn];
    
    BOOL isBoDuanStarted = [_curProxy islvboBoduanStart];
    
    if(isBoDuanStarted)
    {
        [buduanStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [buduanStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
- (void) boduanStartBtnAction:(id)sender {
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy islvboBoduanStart];
    
    [_curProxy controllvboBoduanStart:!isMute];
    
    BOOL isFanKuiYiZhi = [_curProxy islvboBoduanStart];
    
    if(isFanKuiYiZhi)
    {
        [buduanStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [buduanStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int tag = (int) slbtn.tag;
    if (slbtn == gaotongFeqSlider) {
        
        NSDictionary *range = [_curProxy getHighRateRange];
        int max = [[range objectForKey:@"RATE_max"] intValue];
        int min = [[range objectForKey:@"RATE_min"] intValue];
        
        int feq = value * (max - min) + min;
        gaotongFeqL.text = [NSString stringWithFormat:@"%d Hz", feq];

        [_curProxy controlLvBoGaotongPinlv:[NSString stringWithFormat:@"%d", feq]];
        
        [fglm setHPFilterWithFreq:feq];
        
    } else if (tag == 2) {
        
        int k = (value *24)-12;
        NSString *valueStr= [NSString stringWithFormat:@"%d dB", k];
        
        ditongXielvL.text = valueStr;
        
        [_curProxy controllvboDitongPinlv:[NSString stringWithFormat:@"%d", k]];
    } else if (tag == 3) {
        int k = (value *(10000-10))-10;
        
        NSString *valueStr= [NSString stringWithFormat:@"%d Hz", k];
        
        boduanPinlvL.text = valueStr;
        
        [_curProxy controllvboBoduanPinlv:[NSString stringWithFormat:@"%d", k]];
        
    } else if (tag == 4) {
        int k = (value *40)-20;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        boduanZengyiL.text = valueStr;
        
        [fglm setPEQWithBand:_channelSelIndex gain:k];
        [_curProxy controllvboBoduanZengyi:[NSString stringWithFormat:@"%d", k]];
        
    } else {
        int k = (value *2000)-1000;
        NSString *valueStr= [NSString stringWithFormat:@"%d", k];
        
        boduanQL.text = valueStr;
        
        [_curProxy controllvboBoduanQ:[NSString stringWithFormat:@"%d", k]];
    }
}

- (void) boduantypeAction:(UIButton*)sender {
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    LvBoJunHeng_Chooser *sel = [[LvBoJunHeng_Chooser alloc] init];
    sel._dataArray = [_curProxy getLvBoBoDuanArray];
    sel._type = 2;
    
    int h = [sel._dataArray count] * 30 + 50;
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(LvBoJunHeng_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseBoduanType:object];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:[sender superview]];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseBoduanType:(NSString*)device{
    if (device == nil) {
        return;
    }
    NSString *dispaly = [@"   " stringByAppendingString:device];
    
    [boduanleixingBtn setTitle:dispaly forState:UIControlStateNormal];
    
    [_curProxy controlBoduanType:device];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

- (void) zhitongBtn2Action:(id)sender {
    
}

- (void) createDiTong:(UIView*)view {
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"低通";
    addLabel.textAlignment = NSTextAlignmentCenter;
    addLabel.font = [UIFont systemFontOfSize: 15];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.frame = CGRectMake(0, 5, view.frame.size.width, 25);
    [view addSubview:addLabel];
    
    UILabel *addLabel2 = [[UILabel alloc] init];
    addLabel2.text = @"类型";
    addLabel2.font = [UIFont systemFontOfSize: 13];
    addLabel2.textColor = [UIColor whiteColor];
    addLabel2.frame = CGRectMake(10, 35, view.frame.size.width, 25);
    [view addSubview:addLabel2];
    
    int btnStartX = 10;
    int btnY = 50;
    ditongTypeBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    ditongTypeBtn.frame = CGRectMake(btnStartX+60, btnY-20, 100, 30);
    ditongTypeBtn.layer.cornerRadius = 5;
    ditongTypeBtn.layer.borderWidth = 2;
    ditongTypeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    ditongTypeBtn.clipsToBounds = YES;
    NSString *dispaly = @"";
    if ([_curProxy getDiTongType]) {
        dispaly = [@"   " stringByAppendingString:[_curProxy getDiTongType]];
    }
    
    [ditongTypeBtn setTitle:dispaly forState:UIControlStateNormal];
    ditongTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    ditongTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(ditongTypeBtn.frame.size.width - 20, 10, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [ditongTypeBtn addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    [ditongTypeBtn addTarget:self
                   action:@selector(ditongTypeAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ditongTypeBtn];
    
    
    UILabel *addLabel3 = [[UILabel alloc] init];
    addLabel3.text = @"频率 (HZ)";
    addLabel3.font = [UIFont systemFontOfSize: 13];
    addLabel3.textColor = [UIColor whiteColor];
    addLabel3.frame = CGRectMake(CGRectGetMaxX(ditongTypeBtn.frame)-35, btnY+20, 75, 25);
    [view addSubview:addLabel3];
    
    btnY+=35;
    
    UILabel *addLabel22 = [[UILabel alloc] init];
    addLabel22.text = @"斜率";
    addLabel22.font = [UIFont systemFontOfSize: 13];
    addLabel22.textColor = [UIColor whiteColor];
    addLabel22.frame = CGRectMake(10, btnY, view.frame.size.width, 25);
    [view addSubview:addLabel22];
    
    btnY+=30;
    ditongxielvBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    ditongxielvBtn.frame = CGRectMake(btnStartX, btnY, 100, 30);
    ditongxielvBtn.layer.cornerRadius = 5;
    ditongxielvBtn.layer.borderWidth = 2;
    ditongxielvBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    ditongxielvBtn.clipsToBounds = YES;
    NSString *ditongXielvStr = @"";
    if ([_curProxy getDiTongXieLv]) {
        ditongXielvStr = [@"  " stringByAppendingString:[_curProxy getDiTongXieLv]];
    }
    
    [ditongxielvBtn setTitle:ditongXielvStr forState:UIControlStateNormal];
    ditongxielvBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    ditongxielvBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImageView *icon2 = [[UIImageView alloc]
                          initWithFrame:CGRectMake(ditongxielvBtn.frame.size.width - 20, 10, 10, 10)];
    icon2.image = [UIImage imageNamed:@"remote_video_down.png"];
    [ditongxielvBtn addSubview:icon2];
    icon2.alpha = 0.8;
    icon2.layer.contentsGravity = kCAGravityResizeAspect;
    [ditongxielvBtn addTarget:self
                 action:@selector(ditongxielvAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ditongxielvBtn];
    
    ditongXielvSlider = [[SlideButton alloc] initWithFrame:CGRectMake(100, 70, 120, 120)];
    ditongXielvSlider._grayBackgroundImage = [UIImage imageNamed:@"slide_btn_gray_nokd.png"];
    ditongXielvSlider._lightBackgroundImage = [UIImage imageNamed:@"slide_btn_light_nokd.png"];
    [ditongXielvSlider enableValueSet:YES];
    ditongXielvSlider.delegate = self;
    ditongXielvSlider.tag = 2;
    [view addSubview:ditongXielvSlider];
    
    NSString *ditongPinlv = [_curProxy getlvboDitongPinlv];
    float ditongPinlvvalue = [ditongPinlv floatValue];
    float ditongPinlvvaluef = (ditongPinlvvalue+12.0)/24.0;
    [ditongXielvSlider setCircleValue:ditongPinlvvaluef];
    
    ditongXielvL = [[UILabel alloc] initWithFrame:CGRectMake(100, 180, 120, 20)];
    if (ditongPinlv) {
        ditongXielvL.text = [ditongPinlv stringByAppendingString:@" dB"];
    }
    
    ditongXielvL.textAlignment = NSTextAlignmentCenter;
    [view addSubview:ditongXielvL];
    ditongXielvL.font = [UIFont systemFontOfSize:13];
    ditongXielvL.textColor = YELLOW_COLOR;
    
    ditongStartBtn = [UIButton buttonWithColor:RGB(75, 163, 202) selColor:nil];
    ditongStartBtn.frame = CGRectMake(10, view.frame.size.height - 30, 50, 25);
    ditongStartBtn.layer.cornerRadius = 5;
    ditongStartBtn.layer.borderWidth = 2;
    ditongStartBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    ditongStartBtn.clipsToBounds = YES;
    [ditongStartBtn setTitle:@"启用" forState:UIControlStateNormal];
    ditongStartBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [ditongStartBtn addTarget:self
                    action:@selector(ditongStartBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ditongStartBtn];
    
    BOOL isDiTongStarted = [_curProxy islvboDitongStart];
    
    if(isDiTongStarted)
    {
        [ditongStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [ditongStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
- (void) ditongStartBtnAction:(id) sender {
    
    if(_curProxy == nil)
        return;
    
    BOOL isMute = [_curProxy _islvboDitongStart];
    
    [_curProxy controllvboDitongStart:!isMute];
    
    BOOL isFanKuiYiZhi = [_curProxy _islvboDitongStart];
    
    if(isFanKuiYiZhi)
    {
        [ditongStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [ditongStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
}
-(void) ditongTypeAction:(UIButton*)sender {
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    LvBoJunHeng_Chooser *sel = [[LvBoJunHeng_Chooser alloc] init];
    sel._dataArray = [_curProxy getLvBoDiTongArray];
    sel._type = 1;
    
    sel.preferredContentSize = CGSizeMake(150, 350);
    sel._size = CGSizeMake(150, 350);
    
    IMP_BLOCK_SELF(LvBoJunHeng_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseDitong:object];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:sender];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseDitong:(NSString*)device{
    if (device == nil) {
        return;
    }
    NSString *dispaly = [@"   " stringByAppendingString:device];
    
    [ditongTypeBtn setTitle:dispaly forState:UIControlStateNormal];
    
    [_curProxy controlDiTongType:device];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

-(void) ditongxielvAction:(UIButton*)sender {
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
    LvBoJunHeng_Chooser *sel = [[LvBoJunHeng_Chooser alloc] init];
    sel._dataArray = [_curProxy getLvBoDiTongXielvArray];
    sel._type = 2;
    
    sel.preferredContentSize = CGSizeMake(150, 350);
    sel._size = CGSizeMake(150, 350);
    
    IMP_BLOCK_SELF(LvBoJunHeng_UIView);
    sel._block = ^(id object, int index)
    {
        [block_self chooseDitongXieLv:object];
    };
    
    CGRect rect = [self convertRect:sender.frame
                           fromView:sender];
    
    _deviceSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _deviceSelector.popoverContentSize = sel.preferredContentSize;
    
    [_deviceSelector presentPopoverFromRect:rect
                                     inView:self
                   permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) chooseDitongXieLv:(NSString*)device{
    if (device == nil) {
        return;
    }
    NSString *dispaly = [@"   " stringByAppendingString:device];
    
    [ditongxielvBtn setTitle:dispaly forState:UIControlStateNormal];
    
    [_curProxy controlDiTongXieLv:device];
    
    if ([_deviceSelector isPopoverVisible]) {
        [_deviceSelector dismissPopoverAnimated:NO];
    }
    
}

- (void) zhitongBtn3Action:(id) sender {
    
}

- (void) boduanChannelBtnAction:(UIButton*)sender{
    
    _channelSelIndex = (int)sender.tag;
    
    for(UIButton * btn in _boduanChannelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
- (void) channelBtnAction:(UIButton*)sender{
    
    for(UIButton * btn in _channelBtns)
    {
        if(btn == sender)
        {
            [btn setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    int idx = (int)sender.tag;
    self._curProxy = [self._proxys objectAtIndex:idx];
    
    [self updateProxyCommandValIsLoaded];
}

- (void) updateBoDuan {
    NSString *dispaly;
    if ([_curProxy getBoduanType]) {
        dispaly = [@"   " stringByAppendingString:[_curProxy getBoduanType]];
    }
    
    [boduanleixingBtn setTitle:dispaly  forState:UIControlStateNormal];
    
    NSString *boduanPinlv = [_curProxy getlvboBoduanPinlv];
    float boduanPinlvvalue = [boduanPinlv floatValue];
    float boduanPinlvvaluef = (boduanPinlvvalue+12.0)/24.0;
    [boduanPinLvSlider setCircleValue:boduanPinlvvaluef];
    if (boduanPinlv) {
        boduanPinlvL.text = [boduanPinlv stringByAppendingString:@" Hz"];
    }
    
    NSString *boduanZengyi = [_curProxy getlvboBoduanZengyi];
    float boduanZengyivalue = [boduanZengyi floatValue];
    float boduanZengyivaluef = (boduanZengyivalue+12.0)/24.0;
    [boduanZengyiSlider setCircleValue:boduanZengyivaluef];
    if (boduanZengyi) {
        boduanZengyiL.text = [boduanZengyi stringByAppendingString:@" Hz"];
    }
    
    NSString *boduanQ = [_curProxy getlvboBoduanQ];
    float boduanQvalue = [boduanQ floatValue];
    float boduanQvaluef = (boduanQvalue+12.0)/24.0;
    [boduanQSlider setCircleValue:boduanQvaluef];
    if (boduanQ) {
        boduanQL.text = [boduanQ stringByAppendingString:@" Hz"];
    }
    
    BOOL isBoduanStart = [_curProxy islvboBoduanStart];
    
    if(isBoduanStart)
    {
        [buduanStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [buduanStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
    
    
}

-(void) updateDiTong {
    NSString *dispaly = @"";
    if ([_curProxy getDiTongType]) {
        dispaly = [@"   " stringByAppendingString:[_curProxy getDiTongType]];
    }
   
    [ditongTypeBtn setTitle:dispaly  forState:UIControlStateNormal];
    NSString *ditongXielv = @"";
    if ([_curProxy getDiTongXieLv]) {
        ditongXielv = [@"  " stringByAppendingString:[_curProxy getDiTongXieLv]];
    }
    
    [ditongxielvBtn setTitle:ditongXielv forState:UIControlStateNormal];
    
    NSString *ditongPinlv = [_curProxy getlvboDitongPinlv];
    float ditongPinlvvalue = [ditongPinlv floatValue];
    float ditongPinlvvaluef = (ditongPinlvvalue+12.0)/24.0;
    [ditongXielvSlider setCircleValue:ditongPinlvvaluef];
    
    if (ditongPinlv) {
        ditongXielvL.text = [ditongPinlv stringByAppendingString:@" Hz"];
    }
    
    BOOL isDitongStart = [_curProxy _islvboDitongStart];
    
    if(isDitongStart)
    {
        [ditongStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [ditongStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
}

- (void) updateProxyCommandValIsLoaded
{
    _curProxy.delegate = self;
    [_curProxy checkRgsProxyCommandLoad];
    
}

- (void) didLoadedProxyCommand{
    
    _curProxy.delegate = nil;
    
    
    [self updateUICtrlVals];
    
    
}

- (void) updateUICtrlVals{
    
    NSString *dispaly = @"";
    if ([_curProxy getGaoTongType]) {
        dispaly = [NSString stringWithFormat:@"   %@",[_curProxy getGaoTongType]];
    }
    [gaotongTypeBtn setTitle:dispaly  forState:UIControlStateNormal];
    
    NSString *gaotongXieLv = @"";
    if ([_curProxy getGaoTongXieLv]) {
        gaotongXieLv = [NSString stringWithFormat:@"  %@",[_curProxy getGaoTongXieLv]];
    }
    [gaotongXielvBtn setTitle:gaotongXieLv forState:UIControlStateNormal];

    NSString *gaotongPinLv = [_curProxy getLvboGaotongPinlv];
    float value = [gaotongPinLv floatValue];
    
    NSDictionary *range = [_curProxy getHighRateRange];
    int max = [[range objectForKey:@"RATE_max"] intValue];
    int min = [[range objectForKey:@"RATE_min"] intValue];
    if(max)
    {
        float gtVal = (value - min)/(max - min);
        [gaotongFeqSlider setCircleValue:gtVal];
    }
    
    if (gaotongPinLv) {
        gaotongFeqL.text = [NSString stringWithFormat:@"%@ Hz", gaotongPinLv];
    }
    
    BOOL isGaoTongStarted = [_curProxy isLvboGaotongStart];
    
    if(isGaoTongStarted)
    {
        [gaotongStartBtn changeNormalColor:THEME_RED_COLOR];
    }
    else
    {
        [gaotongStartBtn changeNormalColor:RGB(75, 163, 202)];
    }
    
    
    NSString *boduanType= @"";
    if ([_curProxy getBoduanType]) {
        boduanType = [@"  " stringByAppendingString:[_curProxy getBoduanType]];
    }
    [boduanleixingBtn setTitle:boduanType forState:UIControlStateNormal];
}

@end
