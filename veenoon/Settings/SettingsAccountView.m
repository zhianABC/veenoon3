//
//  SettingsAccountView.m
//  veenoon
//
//  Created by 安志良 on 2017/11/18.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "SettingsAccountView.h"


@interface SettingsAccountView () {
    UIButton *languageBtn;
    UIButton *updateVersionBtn;
    UIButton *sceneSelectBtn;
    UIButton *deleteSceanBtn;
    UIButton *resetSystemBtn;
    UIButton *outOfSystemBtn;
    
    UILabel *versionLabel;
}

@end

@implementation SettingsAccountView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, SCREEN_WIDTH-80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:20];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"系统设置";
        
        int firstGap = 200;
        int heightGap = 40;
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(230, 120+heightGap*2, SCREEN_WIDTH-230, 20)];
        titleL2.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL2];
        titleL2.font = [UIFont boldSystemFontOfSize:20];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"系统";
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(230, 120+heightGap*5, SCREEN_WIDTH-230, 20)];
        titleL3.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL3];
        titleL3.font = [UIFont boldSystemFontOfSize:20];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"设置";
        
        
        UILabel* titleL4 = [[UILabel alloc] initWithFrame:CGRectMake(210+firstGap, 120+heightGap*2, SCREEN_WIDTH-230-firstGap, 20)];
        titleL4.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL4];
        titleL4.font = [UIFont boldSystemFontOfSize:16];
        titleL4.textColor  = RGB(70, 219, 254);
        titleL4.text = @"语言";
        
        
        
        UILabel* titleL5 = [[UILabel alloc] initWithFrame:CGRectMake(210+firstGap, 120+heightGap*3, SCREEN_WIDTH-230-firstGap, 20)];
        titleL5.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL5];
        titleL5.font = [UIFont boldSystemFontOfSize:16];
        titleL5.textColor  = RGB(70, 219, 254);
        titleL5.text = @"软件版本";
        
        UILabel* titleL6 = [[UILabel alloc] initWithFrame:CGRectMake(210+firstGap, 120+heightGap*5, SCREEN_WIDTH-230-firstGap, 20)];
        titleL6.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL6];
        titleL6.font = [UIFont boldSystemFontOfSize:16];
        titleL6.textColor  = RGB(70, 219, 254);
        titleL6.text = @"删除场景模式";
        
        UILabel* titleL7 = [[UILabel alloc] initWithFrame:CGRectMake(210+firstGap, 120+heightGap*6, SCREEN_WIDTH-230-firstGap, 20)];
        titleL7.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL7];
        titleL7.font = [UIFont boldSystemFontOfSize:16];
        titleL7.textColor  = RGB(70, 219, 254);
        titleL7.text = @"还原系统设置";
        
        
        UILabel* titleL8 = [[UILabel alloc] initWithFrame:CGRectMake(210+firstGap, 120+heightGap*7, SCREEN_WIDTH-230-firstGap, 20)];
        titleL8.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL8];
        titleL8.font = [UIFont boldSystemFontOfSize:16];
        titleL8.textColor  = RGB(70, 219, 254);
        titleL8.text = @"退出登录";
        
        int secondGap =100;
        
        languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        languageBtn.frame = CGRectMake(230+firstGap+secondGap, 120+heightGap*5/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40);
        languageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [languageBtn setTitleColor:RGB(109, 210, 244) forState:UIControlStateNormal];
        languageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:languageBtn];
        [languageBtn addTarget:self
                       action:@selector(areaPickAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *rightArraw2 = [[UIImageView alloc] initWithFrame:CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-70, 120+heightGap*5/2-23, 10, 6)];
        [self addSubview:rightArraw2];
        rightArraw2.userInteractionEnabled = YES;
        rightArraw2.image = [UIImage imageNamed:@"down_arraw.png"];
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*5/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line1.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line1];
        
        versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*7/2-35, SCREEN_WIDTH-230-firstGap*2-130, 40)];
        versionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:versionLabel];
        versionLabel.font = [UIFont systemFontOfSize:20];
        versionLabel.textColor  = [UIColor whiteColor];
        versionLabel.text = @"TESLARIA 10.2.3";
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*7/2+1, SCREEN_WIDTH-230-firstGap*2-130, 1)];
        line2.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line2];
        
        updateVersionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        updateVersionBtn.frame = CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-100, 120+heightGap*7/2-35, 50, 40);
        [self addSubview:updateVersionBtn];
        [updateVersionBtn setTitle:@"更新" forState:UIControlStateNormal];
        [updateVersionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [updateVersionBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        updateVersionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [updateVersionBtn addTarget:self
                      action:@selector(updateVersionAction:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line2_1 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-100, 120+heightGap*7/2+1, 50, 1)];
        line2_1.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line2_1];
        
        sceneSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sceneSelectBtn.frame = CGRectMake(230+firstGap+secondGap, 120+heightGap*11/2-35, SCREEN_WIDTH-230-firstGap*2-130, 40);
        sceneSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [sceneSelectBtn setTitleColor:RGB(109, 210, 244) forState:UIControlStateNormal];
        sceneSelectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:sceneSelectBtn];
        [sceneSelectBtn addTarget:self
                        action:@selector(sceanSelectAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *rightArraw3 = [[UIImageView alloc] initWithFrame:CGRectMake(230+firstGap+secondGap +SCREEN_WIDTH-230-firstGap*2-140, 120+heightGap*11/2-23, 10, 6)];
        [self addSubview:rightArraw3];
        rightArraw3.userInteractionEnabled = YES;
        rightArraw3.image = [UIImage imageNamed:@"down_arraw.png"];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*11/2+1, SCREEN_WIDTH-230-firstGap*2-130, 1)];
        line3.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line3];
        
        deleteSceanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteSceanBtn.frame = CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-100, 120+heightGap*11/2-35, 50, 40);
        [self addSubview:deleteSceanBtn];
        [deleteSceanBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteSceanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteSceanBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        deleteSceanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [deleteSceanBtn addTarget:self
                             action:@selector(deleteSceanAction:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line3_1 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-100, 120+heightGap*11/2+1, 50, 1)];
        line3_1.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line3_1];
        
        resetSystemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        resetSystemBtn.frame = CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-100, 120+heightGap*13/2-35, 50, 40);
        [self addSubview:resetSystemBtn];
        [resetSystemBtn setTitle:@"确定" forState:UIControlStateNormal];
        [resetSystemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resetSystemBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        resetSystemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [resetSystemBtn addTarget:self
                           action:@selector(resetSystemAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*13/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line4.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line4];
        
        outOfSystemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        outOfSystemBtn.frame = CGRectMake(230+firstGap+secondGap + SCREEN_WIDTH-230-firstGap*2-100, 120+heightGap*15/2-35, 50, 40);
        [self addSubview:outOfSystemBtn];
        [outOfSystemBtn setTitle:@"确定" forState:UIControlStateNormal];
        [outOfSystemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [outOfSystemBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        outOfSystemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [outOfSystemBtn addTarget:self
                           action:@selector(outSystemAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*15/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line5.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line5];
        
    }
    return self;
}

- (void) areaPickAction:(id)sender{
    
}

- (void) updateVersionAction:(id)sender{
    
}

- (void) sceanSelectAction:(id)sender{
    
}

- (void) deleteSceanAction:(id)sender{
    
}

- (void) resetSystemAction:(id)sender{
    
}

- (void) outSystemAction:(id)sender{
    [self.delegate performSelector:@selector(enterOutSystem) withObject:nil];
}

@end
