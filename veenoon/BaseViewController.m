//
//  BaseViewController.m
//  hkeeping
//
//  Created by jack on 2/18/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Color.h"

@interface BaseViewController ()
{
    
}
@end

@implementation BaseViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    if(IOS7_OR_LATER){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    self.view.backgroundColor = RGB(1, 138, 182);
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topBar.backgroundColor = THEME_COLOR;
    [self.view addSubview:_topBar];
    
    titleIcon = [[UIImageView alloc] init];
    [_topBar addSubview:titleIcon];
    titleIcon.frame = CGRectMake(55, 35, 16, 19);
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 300, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_topBar addSubview:titleLabel];
    
    centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleLabel.textColor = [UIColor whiteColor];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_topBar addSubview:centerTitleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [_topBar addSubview:line];
    

    _http = [[WebClient alloc] initWithDelegate:self];
    _http._httpMethod = @"GET";
    
}

- (void) setCenterTitle:(NSString*)centerTitle {
    centerTitleLabel.text = centerTitle;
}

- (void) setTitleAndImage:(NSString*)imageName withTitle:(NSString*)title {
    UIImage *image = [UIImage imageNamed:imageName];
    titleIcon.image = image;
    
    titleLabel.text = title;
}

- (void) dealloc {
    _http._successBlock = nil;
    _http._failBlock = nil;
    
}

//- (BOOL)shouldAutorotate{
//
//    return YES;
//
//}
//- (NSUInteger)supportedInterfaceOrientations{
//
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize )lengthString:(NSString *)text  withFont:(UIFont *)font //根据字符串、字体计算长度
{
    CGSize constraint = CGSizeMake(1000.0f, 20000.0f);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@
                                          {
                                          NSFontAttributeName:font
                                          }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
    
}



@end
