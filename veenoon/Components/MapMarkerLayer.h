//
//  MapMarkerLayer.h
//  ZhiHui
//
//  Created by chen jack on 13-2-24.
//
//

#import <UIKit/UIKit.h>
@protocol MapMarkerLayerDelegate <NSObject>

@optional
- (void) didSelectView:(int) selected;
- (void) didUnSelectView:(int) selected;
@end

@interface MapMarkerLayer : UIView
{
    NSMutableArray *points1;
    NSMutableArray *points2;
    NSMutableArray *points3;
    CGPathRef    path1;
    CGPathRef    path2;
    CGPathRef    path3;
    NSString     *keyId;
    
    NSDictionary *data;

    BOOL          isFill;
    
    UIColor       *selectedColor;
    
    NSMutableArray *otherData;
    
    int          isSelected;
    
}
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, weak) id <MapMarkerLayerDelegate> delegate_;
@property (nonatomic, strong) NSMutableArray *points1;
@property (nonatomic, strong) NSMutableArray *points2;
@property (nonatomic, strong) NSMutableArray *points3;
@property (nonatomic, strong) NSString *keyId;
@property (nonatomic) CGPathRef path1;
@property (nonatomic) CGPathRef path2;
@property (nonatomic) CGPathRef path3;
@property (nonatomic, readonly) UITextView * title;
@property (nonatomic) BOOL isFill;
@property (nonatomic, strong) NSMutableArray *otherData;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic) int isSelected;

- (int) testTouchPoint:(CGPoint)pt;

- (void) selected;
- (void) unSelected;

@end
