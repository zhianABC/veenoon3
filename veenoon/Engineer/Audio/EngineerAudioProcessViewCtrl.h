//
//  EngineerAudioProcessViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/19.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EngineerSliderView.h"

@interface EngineerAudioProcessViewCtrl< EngineerSliderViewDelegate> : BaseViewController {
    NSMutableArray *_audioProcessArray;
    
    int _inputNumber;
    int _outputNumber;
}
@property (nonatomic,strong) NSMutableArray *_audioProcessArray;

@end
