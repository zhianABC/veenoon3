//
//  EngineerLuBoJiViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerLuBoJiViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "DragCellView.h"
#import "UIImage+Color.h"
#import "OutputScreenView.h"
#import "LuBoJiRightView.h"

@interface EngineerLuBoJiViewController ()<CustomPickerViewDelegate, DragCellViewDelegate> {
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    UIView *_outputScreenView;
    
    int showType;
    
    BOOL isSettings;
    LuBoJiRightView *_rightView;
    UIButton *okBtn;
}
@property (nonatomic, strong) NSArray *_inputs;
@property (nonatomic, strong) NSMutableArray *_outputs;
@property (nonatomic, strong) NSMutableArray *_ctrls;
@end

@implementation EngineerLuBoJiViewController
@synthesize _lubojiArray;
@synthesize _inputs;
@synthesize _outputs;
@synthesize _ctrls;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"info_day_s.png" withTitle:@"录播机"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    _selectSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSysBtn.frame = CGRectMake(50, 100, 80, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"001" forState:UIControlStateNormal];
    _selectSysBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,_selectSysBtn.imageView.bounds.size.width)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width+35,0,0)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    _outputScreenView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
    _outputScreenView.backgroundColor = RGB(0, 89, 118);
    _outputScreenView.layer.cornerRadius = 8;
    _outputScreenView.clipsToBounds = YES;
    [self.view addSubview:_outputScreenView];
    
    _outputScreenView.center = CGPointMake(SCREEN_WIDTH/2+60, 320);
    
    
    int dragW = 70;
    int dragH = 50;
    int sx = CGRectGetMinX(_outputScreenView.frame) - 80;
    int sy = CGRectGetMinY(_outputScreenView.frame);
    
    
    self._inputs = @[@{@"title":@"视频1",@"code":@"1001"},
                     @{@"title":@"视频2",@"code":@"1002"},
                     @{@"title":@"视频3",@"code":@"1003"},
                     @{@"title":@"视频4",@"code":@"1004"},
                     @{@"title":@"视频5",@"code":@"1005"}];
    
    for(int i = 0; i < [_inputs count]; i++)
    {
        NSDictionary *dic = [_inputs objectAtIndex:i];
        
        DragCellView *dragCell = [[DragCellView alloc] initWithFrame:CGRectMake(sx, sy, dragW, dragH)];
        [self.view addSubview:dragCell];
        
        dragCell._enableDrag = YES;
        dragCell.normalImg = [UIImage imageWithColor:RGB(0, 89, 118) andSize:CGSizeMake(5, 5)];
        dragCell.selectedImg = [UIImage imageWithColor:RGB(242, 148, 20) andSize:CGSizeMake(5, 5)];
        [dragCell draw];
        dragCell._element = dic;
        dragCell.delegate_ = self;
        [dragCell setTitleTxt:[dic objectForKey:@"title"]];
        
        sy+=dragH;
        sy+=12;
        
    }
    
    int bw = 100;
    int bh = 100;
    
    int x = (SCREEN_WIDTH - (bw * 9 + 80))/2;
    int y = CGRectGetMaxY(_outputScreenView.frame)+60;
    
    self._ctrls = [NSMutableArray array];
    
    for(int i = 0; i < 9; i++)
    {
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118)
                                         selColor:RGB(242, 148, 20)];
        btn.frame = CGRectMake(x, y, bw, bh);
        [self.view addSubview:btn];
        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;
        
        [_ctrls addObject:btn];
        
        btn.tag = i;
        [btn addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [self drawSplice:btn w:100 h:100 type:i spacex:15 spacey:15];
        
        x+=bw;
        x+=10;
        
        if(i == 0)
        {
            [btn setBackgroundImage:[UIImage imageWithColor:RGB(242, 148, 20)
                                                    andSize:CGSizeMake(1, 1)]
                           forState:UIControlStateNormal];
        }
    }
    
    int w = 400;
    int h = 300;
    
    
    self._outputs = [NSMutableArray array];
    [self drawSplice:_outputScreenView w:w h:h type:0 spacex:50 spacey:30];
}

- (void) didEndTouchedStickerLayer:(DragCellView*)layer sticker:(UIImageView*)sticker{
    
    CGPoint pt = [self.view convertPoint:sticker.center
                                fromView:layer];
    
    
    for(OutputScreenView *screen in _outputs)
    {
        CGRect rc = [self.view convertRect:screen.frame
                                  fromView:_outputScreenView];
        
        if(CGRectContainsPoint(rc, pt))
        {
            screen._input = layer._element;
            [screen fillInputSource];
        }
    }
    
}


- (void) buttonAction:(UIButton*)btn{
    
    int w = 400;
    int h = 300;
    
    int type = (int)btn.tag;
    
    for(UIButton *b in _ctrls)
    {
        if(b.tag == btn.tag)
        {
            [b setBackgroundImage:[UIImage imageWithColor:RGB(242, 148, 20)
                                                  andSize:CGSizeMake(1, 1)]
                         forState:UIControlStateNormal];
        }
        else
        {
            [b setBackgroundImage:[UIImage imageWithColor:RGB(0, 89, 118)
                                                  andSize:CGSizeMake(1, 1)]
                         forState:UIControlStateNormal];
        }
    }
    
    showType = type;
    
    [[_outputScreenView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    [self drawSplice:_outputScreenView w:w h:h type:type spacex:50 spacey:30];
    
}

- (void) drawSplice:(UIView *)container w:(int)w h:(int)h type:(int)type spacex:(int)spacex spacey:(int)spacey{
    
    int fontSize = 60;
    if(w <= 100)
        fontSize = 26;
    
    if(_outputScreenView == container)
    {
        [self._outputs removeAllObjects];
    }
    
    if(type == 0)
    {
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
        }
    }
    else if(type == 1)
    {
        int x = w/2+spacex;
        int y = h/2+spacey;
        
        
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, x, y)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, y, w-x, h-y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
        }
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w-x, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 1, h-y)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
    }
    else if(type == 2)
    {
        int x = w/2+spacex;
        int y = h/2+spacey;
        
        
        
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, x, y)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, y, w-x, h-y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 1, h)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
        }
        
    }
    else if(type == 3)
    {
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, w/2, h)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(w/2, 0, w/2, h)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(w/2, 0, 1, h)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
        }
    }
    
    else if(type == 4)
    {
        int x = w/2;
        int y = h/2;
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, 0, w/2, h)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, w/2, y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        OutputScreenView *tLC = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, y, w/2, y)];
        tLC._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLC._txtLabel.text = @"C";
        [container addSubview:tLC];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(w/2, 0, 1, h)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, x, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
            [self._outputs addObject:tLC];
        }
    }
    else if(type == 5)
    {
        int x = w/2;
        int y = h/2;
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, w/2, h)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, 0, w/2, y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        OutputScreenView *tLC = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, y, w/2, y)];
        tLC._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLC._txtLabel.text = @"C";
        [container addSubview:tLC];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(w/2, 0, 1, h)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, x, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
            [self._outputs addObject:tLC];
        }
    }
    else if(type == 6)
    {
        int x = w/2;
        int y = h/2;
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, w, h/2)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, y, w/2, y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        OutputScreenView *tLC = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, y, w/2, y)];
        tLC._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLC._txtLabel.text = @"C";
        [container addSubview:tLC];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 1, y)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
            [self._outputs addObject:tLC];
        }
    }
    else if(type == 7)
    {
        int x = w/2;
        int y = h/2;
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, w/2, h/2)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, 0, w/2, y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        OutputScreenView *tLC = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, y, w/2, y)];
        tLC._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLC._txtLabel.text = @"C";
        [container addSubview:tLC];
        
        OutputScreenView *tLD = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, y, w/2, y)];
        tLD._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLD._txtLabel.text = @"D";
        [container addSubview:tLD];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 1, h)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
            [self._outputs addObject:tLC];
            [self._outputs addObject:tLD];
        }
    }
    else if(type == 8)
    {
        int x = w/3;
        int y = h/3;
        OutputScreenView *tL = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 0, x*2, y*2)];
        tL._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tL._txtLabel.text = @"A";
        [container addSubview:tL];
        
        OutputScreenView *tLB = [[OutputScreenView alloc] initWithFrame:CGRectMake(0, 2*y, x, y)];
        tLB._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLB._txtLabel.text = @"B";
        [container addSubview:tLB];
        
        OutputScreenView *tLC = [[OutputScreenView alloc] initWithFrame:CGRectMake(x, 2*y, x, y)];
        tLC._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLC._txtLabel.text = @"C";
        [container addSubview:tLC];
        
        OutputScreenView *tLD = [[OutputScreenView alloc] initWithFrame:CGRectMake(x*2, 0, x, y)];
        tLD._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLD._txtLabel.text = @"D";
        [container addSubview:tLD];
        
        OutputScreenView *tLE = [[OutputScreenView alloc] initWithFrame:CGRectMake(x*2, y, x, y)];
        tLE._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLE._txtLabel.text = @"E";
        
        [container addSubview:tLE];
        
        OutputScreenView *tLF = [[OutputScreenView alloc] initWithFrame:CGRectMake(x*2, y*2, x, y)];
        tLF._txtLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        tLF._txtLabel.text = @"F";
        [container addSubview:tLF];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(x*2, 0, 1, h)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y*2, w, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        //
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x, 2*y, 1, y)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        //
        line = [[UIImageView alloc] initWithFrame:CGRectMake(x*2, y, x, 1)];
        line.backgroundColor = RGB(63, 58, 55);
        [container addSubview:line];
        
        if(_outputScreenView == container)
        {
            [self._outputs addObject:tL];
            [self._outputs addObject:tLB];
            [self._outputs addObject:tLC];
            [self._outputs addObject:tLD];
            [self._outputs addObject:tLE];
            [self._outputs addObject:tLF];
        }
        
    }
}

- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 100) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 2; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"00%d", i]];
    }
    
    _customPicker._pickerDataArray = @[@{@"values":arr}];
    
    
    _customPicker._selectColor = [UIColor orangeColor];
    _customPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_customPicker];
    _customPicker.delegate_ = self;
}
- (void) didConfirmPickerValue:(NSString*) pickerValue {
    if (_customPicker) {
        [_customPicker removeFromSuperview];
    }
    NSString *title =  [@"" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}
- (void) okAction:(id)sender{
    if (!isSettings) {
        _rightView = [[LuBoJiRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        [self.view addSubview:_rightView];
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
