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

@interface AudioMatrixSettingViewCtrl () <AudioMatrixViewDelegate, UIScrollViewDelegate, SlideButtonDelegate>
{
    UIScrollView *_matrix;
    UIScrollView *_page1;
    UIScrollView *_page2;
    UIScrollView *_leftTiles;
    UIScrollView *_topTiles;
    UIScrollView *_ams;
    
    AudioMatrixView *page1v1;
    AudioMatrixView *page1v2;
    
    AudioMatrixView *page2v1;
    AudioMatrixView *page2v2;
    
    UIPageControl *_pageCtrl1;
    UIPageControl *_pageCtrl2;
    
    UIButton *_inBtn;
    UIButton *_outputBtn;
    UIButton *_muteBtn;
}
@property (nonatomic, strong) UIView* _selectedPage;

@end

@implementation AudioMatrixSettingViewCtrl
@synthesize _selectedPage;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
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
    
    
    int w = 45 * 8;
    int h = 45 * 8;
    int top = (SCREEN_HEIGHT  - h)/2;
    
    _leftTiles = [[UIScrollView alloc] initWithFrame:CGRectMake(70, top, 50, h)];
    [self.view addSubview:_leftTiles];
    _leftTiles.userInteractionEnabled = NO;
    _leftTiles.contentSize = CGSizeMake(30, h*2);
    
    for(int i = 0; i < 16; i++)
    {
        UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(0, i*45, 50, 40)];
        tl.textColor = [UIColor whiteColor];
        tl.font = [UIFont systemFontOfSize:12];
        tl.text = [NSString stringWithFormat:@"OUT%02d", i+1];
        
        [_leftTiles addSubview:tl];
    }
    
    _topTiles = [[UIScrollView alloc] initWithFrame:CGRectMake(120, top-30, w, 30)];
    [self.view addSubview:_topTiles];
    _topTiles.userInteractionEnabled = NO;
    _topTiles.contentSize = CGSizeMake(w*2, h);
    
    for(int i = 0; i < 16; i++)
    {
        UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(i*45, 0, 45, 20)];
        tl.textColor = [UIColor whiteColor];
        tl.font = [UIFont systemFontOfSize:12];
        tl.text = [NSString stringWithFormat:@"IN%02d", i+1];
        tl.textAlignment = NSTextAlignmentCenter;
        [_topTiles addSubview:tl];
    }
    
    UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_topTiles.frame), top-30, 45, 20)];
    tl.textColor = [UIColor whiteColor];
    tl.font = [UIFont systemFontOfSize:12];
    tl.text = @"AM";
    tl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tl];

    _ams = [[UIScrollView alloc] initWithFrame:CGRectMake(120+w, top, 45, h)];
    [self.view addSubview:_ams];
    _ams.contentSize = CGSizeMake(45, h*2);
    for(int i = 0; i < 16; i++)
    {
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:nil];
        btn.frame = CGRectMake(0, i*45, 40, 40);
        [_ams addSubview:btn];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitle:@"0.0" forState:UIControlStateNormal];
        
        [btn addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = i;

    }
    
    _matrix = [[UIScrollView alloc] initWithFrame:CGRectMake(120, top, w, h)];
    _matrix.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_matrix];
    _matrix.contentSize = CGSizeMake(w*2, h);
    _matrix.pagingEnabled = YES;
    _matrix.delegate = self;
    _matrix.bounces = NO;
    _matrix.showsHorizontalScrollIndicator = NO;
    _matrix.showsVerticalScrollIndicator = NO;
    
    _pageCtrl1 = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    [self.view addSubview:_pageCtrl1];
    _pageCtrl1.currentPage = 0;
    _pageCtrl1.backgroundColor = [UIColor clearColor];
    _pageCtrl1.numberOfPages = 2;
    _pageCtrl1.center = CGPointMake(CGRectGetMidX(_matrix.frame),
                                    CGRectGetMaxY(_matrix.frame)+20);
    
    _pageCtrl2 = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    [self.view addSubview:_pageCtrl2];
    _pageCtrl2.currentPage = 0;
    _pageCtrl2.backgroundColor = [UIColor clearColor];
    _pageCtrl2.numberOfPages = 2;
    _pageCtrl2.center = CGPointMake(CGRectGetMaxX(_matrix.frame)+65,
                                    CGRectGetMidY(_matrix.frame));
    _pageCtrl2.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    
    _page1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [_matrix addSubview:_page1];
    _page1.pagingEnabled = YES;
    _page1.contentSize = CGSizeMake(w, h*2);
    _page1.delegate = self;
    _page1.bounces = NO;
    _page1.showsVerticalScrollIndicator = NO;
    
    _page2 = [[UIScrollView alloc] initWithFrame:CGRectMake(w, 0, w, h)];
    [_matrix addSubview:_page2];
    _page2.pagingEnabled = YES;
    _page2.contentSize = CGSizeMake(w, h*2);
    _page2.delegate = self;
    _page2.bounces = NO;
    _page2.showsVerticalScrollIndicator = NO;
    
    
    page1v1 = [[AudioMatrixView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [_page1 addSubview:page1v1];
    page1v1.delegate = self;
    
    page1v2 = [[AudioMatrixView alloc] initWithFrame:CGRectMake(0, h, w, h)];
    [_page1 addSubview:page1v2];
    page1v2.delegate = self;
    
    page2v1 = [[AudioMatrixView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [_page2 addSubview:page2v1];
    page2v1.delegate = self;
    
    page2v2 = [[AudioMatrixView alloc] initWithFrame:CGRectMake(0, h, w, h)];
    [_page2 addSubview:page2v2];
    page2v2.delegate = self;
    
    int xx = CGRectGetMaxX(_matrix.frame)+100;
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(xx, 0, 350, 280)];
    [self.view addSubview:contentView];
    contentView.layer.cornerRadius = 5;
    contentView.clipsToBounds = YES;
    contentView.backgroundColor = RGB(0, 89, 118);
    contentView.center = CGPointMake(contentView.center.x, CGRectGetMidY(_matrix.frame));
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 350, 20)];
    title.text = @"混音值";
    title.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:title];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [UIColor whiteColor];

    
    _inBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _inBtn.frame = CGRectMake(50, 120, 70, 30);
    _inBtn.clipsToBounds = YES;
    _inBtn.layer.cornerRadius = 8;
    _inBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_inBtn setTitle:@"In 1" forState:UIControlStateNormal];
    _inBtn.userInteractionEnabled = NO;
    //[_inBtn setTitleColor: forState:UIControlStateNormal];
    [contentView addSubview:_inBtn];
    
    _outputBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _outputBtn.frame = CGRectMake(50, 160, 70, 30);
    _outputBtn.clipsToBounds = YES;
    _outputBtn.layer.cornerRadius = 8;
    _outputBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_outputBtn setTitle:@"Out 1" forState:UIControlStateNormal];
    _outputBtn.userInteractionEnabled = NO;
    //[_inBtn setTitleColor: forState:UIControlStateNormal];
    [contentView addSubview:_outputBtn];
    
    _muteBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _muteBtn.frame = CGRectMake(50, 200, 70, 30);
    _muteBtn.clipsToBounds = YES;
    _muteBtn.layer.cornerRadius = 8;
    _muteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_muteBtn setTitle:@"静音" forState:UIControlStateNormal];
    _muteBtn.userInteractionEnabled = NO;
    //[_inBtn setTitleColor: forState:UIControlStateNormal];
    [contentView addSubview:_muteBtn];
    
    
    int lx = 350/2;
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(lx, 120, 120, 20)];
    tL.text = @"增益（db）";
    tL.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tL];
    tL.font = [UIFont systemFontOfSize:13];
    tL.textColor = [UIColor whiteColor];
    
    SlideButton *dbbtn = [[SlideButton alloc] initWithFrame:CGRectMake(lx, 140, 120, 120)];
    [contentView addSubview:dbbtn];
    dbbtn.delegate = self;
    
}

- (void) didSlideButtonValueChanged:(float)value{
    
    float fv = (value * 10.0);
    if([self._selectedPage isKindOfClass:[AudioMatrixView class]])
    {
        [((AudioMatrixView*)_selectedPage) changeValue:fv];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView == _page1 || scrollView == _page2)
    {
        if(_page1 == scrollView)
        {
            _page2.contentOffset = scrollView.contentOffset;
        }
        else if(_page2 == scrollView)
        {
            _page1.contentOffset = scrollView.contentOffset;
        }
        _leftTiles.contentOffset = scrollView.contentOffset;
        _ams.contentOffset = scrollView.contentOffset;
        
        CGFloat pageWidth = scrollView.frame.size.height;
        //NSLog(@"pageHeight = %f", pageHeight);
        int pageIndex = floor((scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        if(pageIndex > 1)
            pageIndex = 1;
        _pageCtrl2.currentPage = pageIndex;
    }
    else if(scrollView == _matrix)
    {
        _topTiles.contentOffset = _matrix.contentOffset;
        
        CGFloat pageWidth = scrollView.frame.size.width;
        //NSLog(@"pageHeight = %f", pageHeight);
        int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(pageIndex > 1)
            pageIndex = 1;
        _pageCtrl1.currentPage = pageIndex;
        
    }
}

- (void) didSelectButton:(int)index view:(id)view{
    
    self._selectedPage = view;
    
    if(view == page1v1)
    {
        int row = index/8 + 1;
        int col = index%8 + 1;
        
        [_inBtn setTitle:[NSString stringWithFormat:@"In %d", col] forState:UIControlStateNormal];
        [_outputBtn setTitle:[NSString stringWithFormat:@"Out %d", row] forState:UIControlStateNormal];
    }
    else if(view == page1v2)
    {
        int row = index/8 + 1 + 8;
        int col = index%8 + 1;
        
        [_inBtn setTitle:[NSString stringWithFormat:@"In %d", col] forState:UIControlStateNormal];
        [_outputBtn setTitle:[NSString stringWithFormat:@"Out %d", row] forState:UIControlStateNormal];
    }
    else if(view == page2v1)
    {
        int row = index/8 + 1;
        int col = index%8 + 1 + 8;
        
        [_inBtn setTitle:[NSString stringWithFormat:@"In %d", col] forState:UIControlStateNormal];
        [_outputBtn setTitle:[NSString stringWithFormat:@"Out %d", row] forState:UIControlStateNormal];
    }
    else if(view == page2v2)
    {
        int row = index/8 + 1 + 8;
        int col = index%8 + 1 + 8;
        
        [_inBtn setTitle:[NSString stringWithFormat:@"In %d", col] forState:UIControlStateNormal];
        [_outputBtn setTitle:[NSString stringWithFormat:@"Out %d", row] forState:UIControlStateNormal];
    }
}

- (void) buttonAction:(id)sender{
    
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
