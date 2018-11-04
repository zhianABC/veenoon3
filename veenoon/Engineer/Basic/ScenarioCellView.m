//
//  ScenarioCellView.m
//  veenoon
//
//  Created by chen jack on 2018/9/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ScenarioCellView.h"
#import "Scenario.h"
#import "UIButton+Color.h"
#import "DataBase.h"

@interface ScenarioCellView () <ScenarioDelegate>
{
    UIImageView *iconView;
    UILabel     *titleL;
    UIButton *scenarioCellBtn;
    UILabel *line;
}
@property (nonatomic, strong) Scenario *_scen;
@end

@implementation ScenarioCellView
@synthesize _scen;
@synthesize ctrl;
@synthesize delegate;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame])
    {
        scenarioCellBtn = [UIButton buttonWithColor:DARK_BLUE_COLOR
                                                     selColor:nil];
        [self addSubview:scenarioCellBtn];
    
        scenarioCellBtn.frame = self.bounds;
        scenarioCellBtn.layer.cornerRadius = 5;
        scenarioCellBtn.clipsToBounds = YES;
    
        [scenarioCellBtn addTarget:self
                            action:@selector(buttonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        scenarioCellBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 70)];
        [self addSubview:iconView];
        iconView.tag = 101;
        iconView.contentMode = UIViewContentModeCenter;
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(2, 70, frame.size.width-4, 1)];
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self addSubview:line];
        
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, frame.size.width, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:14];
        titleL.textColor  = [UIColor whiteColor];
        titleL.tag = 102;
        titleL.textAlignment = NSTextAlignmentCenter;

    }
    
    return self;
}
- (Scenario*) getData {
    
    return self._scen;
}
- (void) fillData:(Scenario *)data
{
    self._scen = data;
    
    if(data == nil)
    {
        [scenarioCellBtn setTitle:@"+" forState:UIControlStateNormal];
        [scenarioCellBtn setTitleColor:DARK_BLUE_COLOR
                              forState:UIControlStateNormal];
        
        [scenarioCellBtn changeNormalColor:[UIColor clearColor]];
        scenarioCellBtn.layer.borderColor = DARK_BLUE_COLOR.CGColor;;
        scenarioCellBtn.clipsToBounds = YES;
        scenarioCellBtn.layer.borderWidth = 2;
        
        line.hidden = YES;
    }
    else
    {
        
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(longPressed0:)];
        [self addGestureRecognizer:longPress0];
        
        NSString *name  = [[_scen senarioData] objectForKey:@"name"];
        
        NSString *small = [[_scen senarioData] objectForKey:@"small_icon"];
        if(small)
        {
            UIImage * img = [UIImage imageNamed:small];
            
            if(img){
                iconView.image = img;
            }
        }
        
        titleL.text = name;
        
        _scen.delegate = self;
        [_scen syncDataFromRegulus];
        
    }
    
}

- (void) didEndLoadingUserData{
    
    NSString *name  = [[_scen senarioData] objectForKey:@"name"];
    NSString *small = [[_scen senarioData] objectForKey:@"small_icon"];
    if(small)
    {
        UIImage * img = [UIImage imageNamed:small];
        
        if(img){
            iconView.image = img;
        }
    }
    
    titleL.text = name;
}

- (void) buttonAction:(id)sender{
    
    if(delegate && [delegate respondsToSelector:@selector(didButtonCellTapped:)])
    {
        [delegate didButtonCellTapped:_scen];
    }
}

- (void) longPressed0:(id)sender{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"提示"
                                          message:@"请输入场景名称"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"场景名称";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"英文名称";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([alertController.textFields count] == 2)
        {
            UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
            NSString *scenarioName = envirnmentNameTextField.text;
            
            UITextField *enNameTextField = [alertController.textFields objectAtIndex:1];
            NSString *enName = enNameTextField.text;
            
            if (scenarioName && [scenarioName length] > 0 && [enName length])
            {
                NSMutableDictionary *sdic = [_scen senarioData];
                [sdic setObject:scenarioName
                         forKey:@"name"];
                
                [sdic setObject:enName
                         forKey:@"en_name"];
                
               
                titleL.text = scenarioName;
                
                [[DataBase sharedDatabaseInstance] saveScenario:sdic];
                
                [_scen uploadToRegulusCenter];
            }
        }
    }]];
    
    
    [self.ctrl presentViewController:alertController animated:true completion:nil];
}

- (void) refreshDraggedData:(NSDictionary*)data{
    
    NSString *imageName = [data objectForKey:@"iconbig"];
    NSString *icon_user = [data objectForKey:@"icon_user"];
    NSString *title = [data objectForKey:@"title"];
    NSString *en_name = [data objectForKey:@"en_name"];
    
    iconView.image = [UIImage imageNamed:imageName];
    
    NSMutableDictionary *scenarioDic = [_scen senarioData];
    [scenarioDic setObject:imageName forKey:@"small_icon"];
    [scenarioDic setObject:icon_user forKey:@"icon_user"];
    [scenarioDic setObject:title forKey:@"name"];
    
    if(en_name)
        [scenarioDic setObject:en_name
                        forKey:@"en_name"];
    
    titleL.text = title;
    
    [[DataBase sharedDatabaseInstance] saveScenario:scenarioDic];
    
    [_scen uploadToRegulusCenter];
}
@end
