//
//  StickerLayerView.h
//  APoster
//
//  Created by chen jack on 12-10-28.
//  Copyright (c) 2012年 chen jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickerLayerViewDelegate <NSObject>

@optional
- (void) didBeginTouchedStickerLayer:(id)layer;
- (void) didMovedStickerLayer:(id)layer sticker:(id)sticker;
- (void) didEndTouchedStickerLayer:(id)layer sticker:(id)sticker;

- (void) didAnimationFinishedStickerLayer:(id)layer;
- (void) didRemoveStickerLayer:(id)layer;

- (void) didTappedStickerLayer:(id)layer;

- (void) longPressed:(id)sticker;

- (void) updateSelectedStatus:(BOOL)isSelected layer:(id)layer;

@end


@interface StickerLayerView : UIView
{
    
    UIImageView *_sticker;
    UIImageView *_stickerCopy;
 
    BOOL isMoving;
    

    CGPoint pt;
    float center_y;

    NSDictionary *_element;
    
    BOOL _isSelected;
    
    UIImageView *_topIcon;
}
@property (nonatomic, weak) id <StickerLayerViewDelegate> delegate_;
@property (nonatomic, strong) NSDictionary * _element;
@property (nonatomic, strong) UIImage * selectedImg;
@property (nonatomic, strong) UIImage * normalImg;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, assign) BOOL _enableDrag;

@property (nonatomic, assign) BOOL _resetWhenEndDrag;

@property (nonatomic, strong) NSDictionary * _linkedElement;

- (void) selected;
- (void) unselected;

- (BOOL) getIsSelected;

- (void) setSticker:(NSString*)sticker;

- (void) enableLongPressed;

- (void) setTopIconImage:(UIImage*)icon;

- (void) setEmptyCell;

@end
