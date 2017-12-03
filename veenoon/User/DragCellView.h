//
//  DragCellView.h
//  APoster
//
//  Created by chen jack on 12-10-28.
//  Copyright (c) 2012年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DragCellViewDelegate <NSObject>

@optional
- (void) didBeginTouchedStickerLayer:(id)layer;
- (void) didMovedStickerLayer:(id)layer sticker:(id)sticker;
- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker;

@end


@interface DragCellView : UIView
{
    
    UIImageView *_sticker;
    UIImageView *_stickerCopy;
 
    BOOL isMoving;
    

    CGPoint pt;
    float center_y;

    NSDictionary *_element;
    
    BOOL _isSelected;
    
    
    
}
@property (nonatomic, weak) id <DragCellViewDelegate> delegate_;
@property (nonatomic, strong) NSDictionary * _element;
@property (nonatomic, strong) UIImage * selectedImg;
@property (nonatomic, strong) UIImage * normalImg;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, assign) BOOL _enableDrag;

@property (nonatomic, assign) BOOL _resetWhenEndDrag;

- (void) selected;
- (void) unselected;

- (BOOL) getIsSelected;

- (void) draw;
- (void) setTitleTxt:(NSString*)txt;

@end
