//
//  VNSettingsView.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "VNSettingsView.h"
#import "SettingsUserView.h"
#import "SettingsViewView.h"

@interface VNSettingsView () <UIScrollViewDelegate> {
  
    UILabel* titleL;
    
    SettingsUserView *settingsUserView;
    UIScrollView *_content;
    UIPageControl *_pageCtrl1;
    
    SettingsViewView *_imgSetting;
}

@end

@implementation VNSettingsView

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGB(1, 138, 182);
        
        
        UIImageView *titleIcon = [[UIImageView alloc]
                                  initWithImage:[UIImage imageNamed:@"back_white_ico.png"]];
        [self addSubview:titleIcon];
        titleIcon.center = CGPointMake(50, 20+22);
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
        line.backgroundColor = RGB(75, 163, 202);
        [self addSubview:line];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"账户与安全";
        titleL.textAlignment = NSTextAlignmentCenter;
        
        
        ///
        UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        [self addSubview:bottomBar];
        
        //缺切图，把切图贴上即可。
        bottomBar.backgroundColor = [UIColor grayColor];
        bottomBar.userInteractionEnabled = YES;
        bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
        

        _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT-64-50)];
        [self addSubview:_content];
        _content.contentSize = CGSizeMake(SCREEN_WIDTH*2, CGRectGetHeight(_content.frame));
        _content.pagingEnabled = YES;
        _content.showsHorizontalScrollIndicator = NO;
        _content.delegate = self;
        
        settingsUserView = [[SettingsUserView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
        settingsUserView.backgroundColor = [UIColor clearColor];
        [_content addSubview:settingsUserView];
        
        _imgSetting = [[SettingsViewView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50)];
        [_content addSubview:_imgSetting];
        
        
        _pageCtrl1 = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-30, 120, 20)];
        [self addSubview:_pageCtrl1];
        _pageCtrl1.currentPage = 0;
        _pageCtrl1.userInteractionEnabled = NO;
        _pageCtrl1.backgroundColor = [UIColor clearColor];
        _pageCtrl1.numberOfPages = 2;
        _pageCtrl1.center = CGPointMake(SCREEN_WIDTH/2,
                                        _pageCtrl1.center.y);
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 60, 50);
        [self addSubview:backBtn];
        backBtn.center = titleIcon.center;
        [backBtn addTarget:self
                    action:@selector(backAction:)
          forControlEvents:UIControlEventTouchUpInside];

    }
    
    return self;
}

- (void) backAction:(id)sender{
    
    UIScrollView *cnt = (UIScrollView*)[self superview];
    [cnt setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) setViewCtrl:(UIViewController *)ctrl{
    
    _imgSetting._ctrl = ctrl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //NSLog(@"pageHeight = %f", pageHeight);
    int _pageIndex = scrollView.contentOffset.x / pageWidth;
    
    if(_pageIndex == 0)
    {
        titleL.text = @"账户与安全";
        _pageCtrl1.currentPage = 0;
    }
    else{
        titleL.text = @"墙纸";
        _pageCtrl1.currentPage = 1;
    }
    
}


- (void) cancelAction:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
