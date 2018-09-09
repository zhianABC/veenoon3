//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "AudioProcessRightView.h"
#import "UIButton+Color.h"
#import "ComSettingView.h"
#import "AudioEProcessor.h"

@interface AudioProcessRightView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *_btns;
@property (nonatomic) int _numOfChannel;
@end

@implementation AudioProcessRightView 
@synthesize delegate_;
@synthesize _btns;
@synthesize _numOfChannel;
@synthesize _processor;

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RIGHT_VIEW_CORNER_SD_COLOR;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        _btns = [[NSMutableArray alloc] init];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-400)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        int bw = 120;
        int x = (frame.size.width - bw)/2;
        int top = (frame.size.height/2 - 40*2 - 5*3);
        btn1 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn1.frame = CGRectMake(x, top, bw, 40);
        btn1.clipsToBounds = YES;
        btn1.layer.cornerRadius = 5;
//        [self addSubview:btn1];
        
        [btn1 setTitle:@"输入设置" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(yuyinjiliAction:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn2 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn2.frame = CGRectMake(x, top, bw, 40);
        btn2.clipsToBounds = YES;
        btn2.layer.cornerRadius = 5;
//        [self addSubview:btn2];
        
        [btn2 setTitle:@"输出设置" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(biaozhunfayanAction:) forControlEvents:UIControlEventTouchUpInside];
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        
        top+=40;
        top+=5;
        
        btn3 = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        btn3.frame = CGRectMake(x, top, bw, 40);
        btn3.clipsToBounds = YES;
        btn3.layer.cornerRadius = 5;
//        [self addSubview:btn3];
        
        [btn3 setTitle:@"矩阵路由" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(yinpinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
        btn3.titleLabel.font = [UIFont systemFontOfSize:15];
        

    }
    
    return self;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //_curIndex = (int)textField.tag;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _processor._ipaddress = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"listCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.editing = NO;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-30, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    if (indexPath.row == 0) {
        titleL.text = @"输入设置";
    } else if (indexPath.row == 1) {
        titleL.text = @"输出设置";
    } else if (indexPath.row == 2) {
        titleL.text = @"矩阵路由";
    }
    
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+5, 17, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_right.png"];
    [cell.contentView addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  TITLE_LINE_COLOR;
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int targetIndx = (int)indexPath.row;
    
    if (targetIndx == 0) {
        [self yuyinjiliAction:nil];
    } else if (targetIndx == 1) {
        [self biaozhunfayanAction:nil];
    } else if (targetIndx == 2) {
        [self yinpinchuliAction:nil];
    }
}

- (void) yuyinjiliAction:(id)sender{
    
    [self selectBtnAction:btn1.titleLabel.text];
}
- (void) biaozhunfayanAction:(id)sender{
    
    [self selectBtnAction:btn2.titleLabel.text];
}
- (void) yinpinchuliAction:(id)sender{
    
    [self selectBtnAction:btn3.titleLabel.text];
}

- (void) selectBtnAction:(NSString*)btnTitle {
    if([delegate_ respondsToSelector:@selector(didSelectButtonAction:)]){
        [delegate_ didSelectButtonAction:btnTitle];
    }
}



- (void) swipClose{
    
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(dissmissSettingView)])
    {
        [delegate_ dissmissSettingView];
    }
 
}

@end



