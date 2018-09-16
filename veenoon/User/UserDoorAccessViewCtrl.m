#import "UserDoorAccessViewCtrl.h"
#import "UIButton+Color.h"

@interface UserDoorAccessViewCtrl() {
    NSMutableArray *_doorAccessRoomList;
    NSMutableArray *_doorAccessBtnList;
    
    UILabel *_telephoneNumberL;
}
    @property (nonatomic, strong) NSMutableArray *_doorAccessRoomList;
    @end

@implementation UserDoorAccessViewCtrl
    @synthesize _doorAccessRoomList;
    
- (void) initData {
    if (_doorAccessRoomList) {
        [_doorAccessRoomList removeAllObjects];
    } else {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"小会议室", @"name",
                                     nil];
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        NSMutableDictionary *dic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"大会议室", @"name",
                                     nil];
        self._doorAccessRoomList = [NSMutableArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic7, nil];
    }
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    if (_doorAccessBtnList) {
        [_doorAccessBtnList removeAllObjects];
    } else {
        _doorAccessBtnList = [[NSMutableArray alloc] init];
    }
    
    self.view.backgroundColor = USER_GRAY_COLOR;
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
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
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int leftGap = 165;
    int scrollHeight = 600;
    int cellWidth = 100;
    int rowGap = 40;
    int number = [self._doorAccessRoomList count];
    int contentWidth = number * 100 + (number-1) * rowGap-30;
    UIScrollView *airCondtionView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftGap, SCREEN_HEIGHT-scrollHeight, SCREEN_WIDTH - leftGap*2, cellWidth+10)];
    airCondtionView.contentSize =  CGSizeMake(contentWidth, cellWidth+10);
    airCondtionView.scrollEnabled=YES;
    airCondtionView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:airCondtionView];
    
    int index = 0;
    for (id dic in _doorAccessRoomList) {
        int startX = index*cellWidth+index*rowGap+10;
        int startY = 5;
        
        UIButton *airConditionBtn = [UIButton buttonWithColor:nil selColor:nil];
        airConditionBtn.tag = index;
        airConditionBtn.frame = CGRectMake(startX, startY, cellWidth, cellWidth);
        [airConditionBtn setImage:[UIImage imageNamed:@"user_door_access_n.png"] forState:UIControlStateNormal];
        [airConditionBtn setImage:[UIImage imageNamed:@"user_door_access_s.png"] forState:UIControlStateHighlighted];
        [airConditionBtn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [airConditionBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
        [airConditionBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
        airConditionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [airConditionBtn setTitleEdgeInsets:UIEdgeInsetsMake(airConditionBtn.imageView.frame.size.height+10,-90,-20,20)];
        [airConditionBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,-15,airConditionBtn.titleLabel.bounds.size.height, 0)];
        [airConditionBtn addTarget:self action:@selector(airConditionAction:) forControlEvents:UIControlEventTouchUpInside];
        [airCondtionView addSubview:airConditionBtn];
        
        index++;
        
        [_doorAccessBtnList addObject:airConditionBtn];
    }
    
    int labelHeight = SCREEN_HEIGHT - 550;
    int leftSpace = 400;
    
    UIButton *phone1Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone1Btn.frame = CGRectMake(leftSpace, labelHeight+80+85, 80, 80);
    phone1Btn.layer.cornerRadius = 5;
    phone1Btn.layer.borderWidth = 2;
    phone1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone1Btn.clipsToBounds = YES;
    [phone1Btn setTitle:@"1" forState:UIControlStateNormal];
    [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone1Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone1Btn];
    [phone1Btn addTarget:self
                  action:@selector(phone1Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone2Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone2Btn.frame = CGRectMake(leftSpace+85, labelHeight+80+85, 80, 80);
    phone2Btn.layer.cornerRadius = 5;
    phone2Btn.layer.borderWidth = 2;
    phone2Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone2Btn.clipsToBounds = YES;
    [phone2Btn setTitle:@"2" forState:UIControlStateNormal];
    [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone2Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone2Btn];
    [phone2Btn addTarget:self
                  action:@selector(phone2Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone3Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone3Btn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85, 80, 80);
    phone3Btn.layer.cornerRadius = 5;
    phone3Btn.layer.borderWidth = 2;
    phone3Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone3Btn.clipsToBounds = YES;
    [phone3Btn setTitle:@"3" forState:UIControlStateNormal];
    [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone3Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone3Btn];
    [phone3Btn addTarget:self
                  action:@selector(phone3Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone4Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone4Btn.frame = CGRectMake(leftSpace+85+85+85, labelHeight+80+85, 80, 80);
    phone4Btn.layer.cornerRadius = 5;
    phone4Btn.layer.borderWidth = 2;
    phone4Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone4Btn.clipsToBounds = YES;
    [phone4Btn setTitle:@"4" forState:UIControlStateNormal];
    [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone4Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone4Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone4Btn];
    [phone4Btn addTarget:self
                  action:@selector(phone4Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone5Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone5Btn.frame = CGRectMake(leftSpace, labelHeight+80+85+85, 80, 80);
    phone5Btn.layer.cornerRadius = 5;
    phone5Btn.layer.borderWidth = 2;
    phone5Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone5Btn.clipsToBounds = YES;
    [phone5Btn setTitle:@"5" forState:UIControlStateNormal];
    [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone5Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone5Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone5Btn];
    [phone5Btn addTarget:self
                  action:@selector(phone5Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone6Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone6Btn.frame = CGRectMake(leftSpace+85, labelHeight+80+85+85, 80, 80);
    phone6Btn.layer.cornerRadius = 5;
    phone6Btn.layer.borderWidth = 2;
    phone6Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone6Btn.clipsToBounds = YES;
    [phone6Btn setTitle:@"6" forState:UIControlStateNormal];
    [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone6Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone6Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone6Btn];
    [phone6Btn addTarget:self
                  action:@selector(phone6Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone7Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone7Btn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85+85, 80, 80);
    phone7Btn.layer.cornerRadius = 5;
    phone7Btn.layer.borderWidth = 2;
    phone7Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone7Btn.clipsToBounds = YES;
    [phone7Btn setTitle:@"7" forState:UIControlStateNormal];
    [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone7Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone7Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone7Btn];
    [phone7Btn addTarget:self
                  action:@selector(phone7Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone8Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone8Btn.frame = CGRectMake(leftSpace+85+85+85, labelHeight+80+85+85, 80, 80);
    phone8Btn.layer.cornerRadius = 5;
    phone8Btn.layer.borderWidth = 2;
    phone8Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone8Btn.clipsToBounds = YES;
    [phone8Btn setTitle:@"8" forState:UIControlStateNormal];
    [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone8Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone8Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone8Btn];
    [phone8Btn addTarget:self
                  action:@selector(phone8Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone9Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone9Btn.frame = CGRectMake(leftSpace, labelHeight+80+85+85+85, 80, 80);
    phone9Btn.layer.cornerRadius = 5;
    phone9Btn.layer.borderWidth = 2;
    phone9Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone9Btn.clipsToBounds = YES;
    [phone9Btn setTitle:@"9" forState:UIControlStateNormal];
    [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone9Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone9Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone9Btn];
    [phone9Btn addTarget:self
                  action:@selector(phone9Action:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phonedotBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phonedotBtn.frame = CGRectMake(leftSpace+85, labelHeight+80+85+85+85, 80, 80);
    phonedotBtn.layer.cornerRadius = 5;
    phonedotBtn.layer.borderWidth = 2;
    phonedotBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    phonedotBtn.clipsToBounds = YES;
    [phonedotBtn setTitle:@"0" forState:UIControlStateNormal];
    [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phonedotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phonedotBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phonedotBtn];
    [phonedotBtn addTarget:self
                    action:@selector(phone0Action:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phone0Btn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phone0Btn.frame = CGRectMake(leftSpace+85+85, labelHeight+80+85+85+85, 80, 80);
    phone0Btn.layer.cornerRadius = 5;
    phone0Btn.layer.borderWidth = 2;
    phone0Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    phone0Btn.clipsToBounds = YES;
    [phone0Btn setTitle:@"." forState:UIControlStateNormal];
    [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phone0Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phone0Btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phone0Btn];
    [phone0Btn addTarget:self
                  action:@selector(phonedotAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *phoneStarBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    phoneStarBtn.frame = CGRectMake(leftSpace+85+85+85, labelHeight+80+85+85+85, 80, 80);
    phoneStarBtn.layer.cornerRadius = 5;
    phoneStarBtn.layer.borderWidth = 2;
    phoneStarBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    phoneStarBtn.clipsToBounds = YES;
    [phoneStarBtn setTitle:@"确认" forState:UIControlStateNormal];
    [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    phoneStarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:phoneStarBtn];
    [phoneStarBtn addTarget:self
                     action:@selector(phoneConfirmAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    _telephoneNumberL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 120, SCREEN_HEIGHT -100, 240, 33)];
    _telephoneNumberL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_telephoneNumberL];
    _telephoneNumberL.font = [UIFont boldSystemFontOfSize:16];
    _telephoneNumberL.textColor  = [UIColor redColor];
    _telephoneNumberL.text = @"";
}
    
- (void) phoneConfirmAction:(id)sender{
    
}
- (void) phone0Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"0"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phonedotAction:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"."];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone9Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"9"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone8Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"8"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone7Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"7"];
    
    _telephoneNumberL.text = newTextStr;
}
    
- (void) phone6Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"6"];
    
    _telephoneNumberL.text = newTextStr;
}
    
- (void) phone5Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"5"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone4Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"4"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone3Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"3"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone2Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"2"];
    
    _telephoneNumberL.text = newTextStr;
}
- (void) phone1Action:(id)sender{
    NSString *textStr = _telephoneNumberL.text;
    NSString *newTextStr = [textStr stringByAppendingString:@"1"];
    
    _telephoneNumberL.text = newTextStr;
}
    
- (void) airConditionAction:(id)sender{
    UIButton *selectBtn = (UIButton*) sender;
    int selectTag = selectBtn.tag;
    
    for (UIButton *btn in _doorAccessBtnList) {
        if (btn.tag == selectTag) {
            [btn setImage:[UIImage imageNamed:@"user_door_access_s.png"] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
        } else {
            [btn setImage:[UIImage imageNamed:@"user_door_access_n.png"] forState:UIControlStateNormal];
            [btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
        }
    }
}
    
- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
    
@end
