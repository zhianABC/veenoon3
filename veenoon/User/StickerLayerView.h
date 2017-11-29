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
- (void) didEndTouchedStickerLayer:(id)layer;

- (void) didAnimationFinishedStickerLayer:(id)layer;
- (void) didRemoveStickerLayer:(id)layer;

- (void) didTappedStickerLayer:(id)layer;

@end


@interface StickerLayerView : UIView
{
    
    UIImageView *_sticker;
    UIImageView *_stickerCopy;
 
    BOOL isZooming;
    BOOL isMoving;
    

    CGPoint pt;
    
    BOOL isJumping;
    
    float center_y;
    
    UIButton *closeBtn;
    
    NSDictionary *_element;
    
}
@property (nonatomic, weak) id <StickerLayerViewDelegate> delegate_;
@property (nonatomic, strong) NSDictionary * _element;
@property (nonatomic, strong) UIImage * selectedImg;
@property (nonatomic, strong) UIImage * normalImg;

- (void) selected;
- (void) unselected;

- (void) setSticker:(NSString*)sticker;

@end
