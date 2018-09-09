//
//  ECPlusSelectView.m
//  veenoon
//
//  Created by chen jack on 2017/12/10.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "VideoProcessRightView.h"
#import "EPlusLayerView.h"
#import "UIButton+Color.h"
#import "VVideoProcessSet.h"
#import "RgsDriverObj.h"
#import "VDVDPlayerSet.h"
#import "VTVSet.h"
#import "VCameraSettingSet.h"
#import "VRemoteVideoSet.h"
#import "VTouyingjiSet.h"
#import "VLuBoJiSet.h"
#import "VPinJieSet.h"

@interface VideoProcessRightView () <EPlusLayerViewDelegate>
{
    UIScrollView *_content;
    
    UIView       *_maskView;
    
    int          _curIndex;
}
@property (nonatomic, strong) NSMutableArray *_btns;

@property (nonatomic, strong) NSArray *_inDevs;
@property (nonatomic, strong) NSArray *_outDevs;

@end

@implementation VideoProcessRightView
@synthesize _data;
@synthesize delegate;
@synthesize _btns;
@synthesize _currentObj;
@synthesize _numOfDevice;
@synthesize _callback;
@synthesize _curentDeviceIndex;
@synthesize _currentVideoDevices;

@synthesize _inDevs;
@synthesize _outDevs;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (void) initData{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"input_icon" ofType:@"plist"];
    NSArray *bundelArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSDictionary *sec = [bundelArray objectAtIndex:0];
    NSMutableArray *items = [sec objectForKey:@"items"];
    
    NSMutableArray *inDevices = [NSMutableArray array];
    [inDevices addObjectsFromArray:items];
    
    int itemID = 302;
    
    for (BasePlugElement *basePlugin in self._currentVideoDevices) {
        
        NSString *baseName = basePlugin._name;
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        
        [dataDic setObject:[NSString stringWithFormat:@"%d", itemID] forKey:@"id"];
        
        [dataDic setObject:baseName forKey:@"name"];
        
        
        NSString *deviceID = [NSString stringWithFormat:@"%d", (int)
                              ((RgsDriverObj*)(basePlugin._driver)).m_id];
        [dataDic setObject:deviceID forKey:@"type"];
        [dataDic setObject:deviceID forKey:@"driverid"];
        
        [dataDic setObject:@"1" forKey:@"input_output"];
        
        if(basePlugin){
            NSString *className  = NSStringFromClass([basePlugin class]);
            [dataDic setObject:className forKey:@"class"];
        }
        
        if ([basePlugin isKindOfClass:[VDVDPlayerSet class]]) {
            [dataDic setObject:@"videop_dvd_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_dvd_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_dvd_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_dvd_s.png" forKey:@"user_show_icon_s"];
        } else if([basePlugin isKindOfClass:[VCameraSettingSet class]])
        {
            [dataDic setObject:@"videop_camera_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_camera_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_camera_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_camera_s.png" forKey:@"user_show_icon_s"];
        } else if([baseName isEqualToString:@"信息盒"])
        {
            [dataDic setObject:@"videop_xinxihe_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_xinxihe_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_desk_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_desk_s.png" forKey:@"user_show_icon_s"];
        } else if([basePlugin isKindOfClass:[VRemoteVideoSet class]])
        {
            [dataDic setObject:@"videop_remotevideo_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_remotevideo_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_remote_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_remote_s.png" forKey:@"user_show_icon_s"];
        }
        if ([dataDic objectForKey:@"icon"]) {
            [inDevices addObject:dataDic];
        }
        itemID++;
    }
    
    
    NSMutableArray *outDevices = [NSMutableArray array];
    
    for (BasePlugElement *basePlugin in self._currentVideoDevices) {
        NSString *baseName = basePlugin._name;
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        
        [dataDic setObject:[NSString stringWithFormat:@"%d", itemID] forKey:@"id"];
        
        [dataDic setObject:baseName forKey:@"name"];
        
        NSString *deviceID = [NSString stringWithFormat:@"%d", (int)
                              ((RgsDriverObj*)(basePlugin._driver)).m_id];
        [dataDic setObject:deviceID forKey:@"type"];
        [dataDic setObject:deviceID forKey:@"driverid"];
        
        [dataDic setObject:@"2" forKey:@"input_output"];
        
        if(basePlugin){
            NSString *className  = NSStringFromClass([basePlugin class]);
            [dataDic setObject:className forKey:@"class"];
        }
        
        
        if ([basePlugin isKindOfClass:[VRemoteVideoSet class]]) {
            [dataDic setObject:@"videop_remotevideo_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_remotevideo_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_remote_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_remote_s.png" forKey:@"user_show_icon_s"];
        } else if([basePlugin isKindOfClass:[VPinJieSet class]])
        {
            [dataDic setObject:@"videop_screen_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_screen_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_pinjieping_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_pinjieping_s.png" forKey:@"user_show_icon_s"];
        } else if([basePlugin isKindOfClass:[VTVSet class]])
        {
            [dataDic setObject:@"videop_tv_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_tv_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_yejing_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_yejing_s.png" forKey:@"user_show_icon_s"];
        } else if([basePlugin isKindOfClass:[VLuBoJiSet class]])
        {
            [dataDic setObject:@"videop_player_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_player_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_lubo_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_lubo_s.png" forKey:@"user_show_icon_s"];
        } else if([basePlugin isKindOfClass:[VTouyingjiSet class]])
        {
            [dataDic setObject:@"videop_tscreen_w.png" forKey:@"icon"];
            [dataDic setObject:@"videop_tscreen_y.png" forKey:@"icon_sel"];
            [dataDic setObject:@"user_video_touying_n.png" forKey:@"user_show_icon"];
            [dataDic setObject:@"user_video_touying_s.png" forKey:@"user_show_icon_s"];
        }
        if ([dataDic objectForKey:@"icon"]) {
            [outDevices addObject:dataDic];
        }
    }
    
    
    self._inDevs = inDevices;
    self._outDevs = outDevices;
    
    
}

- (id) initWithFrame:(CGRect)frame withVideoDevices:(NSMutableArray*) videoDevices {

    if(self = [super initWithFrame:frame]) {
        
        _curIndex = 0;
        
        self._currentVideoDevices = videoDevices;
        
        [self initData];
        
        self.backgroundColor = [UIColor clearColor];
        
        _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   frame.size.width,
                                                                   frame.size.height)];
        [self addSubview:_content];
        _content.clipsToBounds = NO;
        
        
        [self layoutCells];
        
    }
    return self;
}



- (void) refreshView:(VVideoProcessSet*) vVideoProcessSet {
    
    self._currentObj = vVideoProcessSet;
    self._curentDeviceIndex = _currentObj._index;
}


- (void) layoutCells{

    float xx = 15;
    float i = (self.frame.size.width - 30 - ([_inDevs count] * 80 + [_outDevs count] * 80 + 20))/2.0;
    if(xx < i ){
        xx = i+15;
    }
    
    
    for(int idx = 0; idx < [_inDevs count]; idx++)
    {
        NSDictionary *dic = [_inDevs objectAtIndex:idx];
        
        EPlusLayerView *rowCell = [[EPlusLayerView alloc]
                                   initWithFrame:CGRectMake(xx, 10,
                                                            80, 80)];
        
        [rowCell setIconContentsGravity:kCAGravityCenter];
        
        [_content addSubview:rowCell];
        rowCell.tag = idx;
        rowCell._enableDrag = YES;
        rowCell.delegate_ = self;
        rowCell._element = dic;
        NSString *image = [dic objectForKey:@"icon"];
        [rowCell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"icon_sel"];
        rowCell.selectedImg = [UIImage imageNamed:sel];
        
        xx+=80;
    }
    
    if([_inDevs count]){
        xx+=10;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(xx, 40, 1, 20)];
        line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [_content addSubview:line];
        
        xx+=10;
    }
    
    for(int idx = 0; idx < [_outDevs count]; idx++)
    {
        NSDictionary *dic = [_outDevs objectAtIndex:idx];
        
        EPlusLayerView *rowCell = [[EPlusLayerView alloc]
                                   initWithFrame:CGRectMake(xx, 10,
                                                            80, 80)];
        
        [rowCell setIconContentsGravity:kCAGravityCenter];
        
        [_content addSubview:rowCell];
        rowCell.tag = 100+idx;
        rowCell._enableDrag = YES;
        rowCell.delegate_ = self;
        rowCell._element = dic;
        NSString *image = [dic objectForKey:@"icon"];
        [rowCell setSticker:image];
        
        NSString *sel = [dic objectForKey:@"icon_sel"];
        rowCell.selectedImg = [UIImage imageNamed:sel];
        
        xx+=80;
    }
    
    if(xx > _content.frame.size.width)
        _content.contentSize  = CGSizeMake(xx, 100);
}


- (void) didBeginTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _content.scrollEnabled = NO;

}
- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker{
    
    _content.scrollEnabled = YES;
    
  
    EPlusLayerView *st = layer;
    UIImageView *icon = sticker;
    
    CGPoint pt = [_content convertPoint:icon.center
                                 fromView:st];
    
    CGPoint ptNew = pt;
    ptNew.x = pt.x - _content.contentOffset.x;
    
    //NSLog(@"%f - %f", ptNew.x, ptNew.y);
    
    if(delegate && [delegate respondsToSelector:@selector(didEndDragingElecCell:pt:)])
    {
        [delegate didEndDragingElecCell:st._element pt:ptNew];
    }
    
}

@end
