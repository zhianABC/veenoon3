//
//  MapMarkerLayer.m
//  ZhiHui
//
//  Created by chen jack on 13-2-24.
//
//

#import "MapMarkerLayer.h"


#define DRAW_LINE_WIDTH 2

@implementation MapMarkerLayer
@synthesize delegate_;
@synthesize points1;
@synthesize points2;
@synthesize points3;
@synthesize path1;
@synthesize path2;
@synthesize path3;
@synthesize keyId;
@synthesize data;
@synthesize isFill;
@synthesize otherData;
@synthesize selectedColor;
@synthesize isSelected;

- (void) dealloc {
    CGPathRelease(path1);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        isFill = YES;
        
        isSelected = 0;
        
        self.otherData = [NSMutableArray array];
    }
    return self;
}

- (void) selected {
    
    isSelected = YES;
    [self setNeedsDisplay];
}
- (void) unSelected{
    
    isSelected = NO;
    [self setNeedsDisplay];
}
-(void)drowPath:(CGPathRef)path withPoints:(NSMutableArray*)points {
    if(!path) {
        CGMutablePathRef pathRef=CGPathCreateMutable();
        
        float maxy = 0;
        for(int i = 0; i < [points count]; i++) {
            NSDictionary *pt = [points objectAtIndex:i];
            float x = [[pt objectForKey:@"LX"] floatValue];
            float y = [[pt objectForKey:@"LY"] floatValue];
            
            maxy = maxy>y?maxy:y;
            
            
            if (i == 0) {
                CGPathMoveToPoint(pathRef, NULL, x, y);
            } else {
                CGPathAddLineToPoint(pathRef, NULL, x, y);
            }
        }
        
        if ([points count]) {
            NSDictionary *pt = [points objectAtIndex:0];
            float x = [[pt objectForKey:@"LX"] floatValue];
            float y = [[pt objectForKey:@"LY"] floatValue];
            
            CGPathAddLineToPoint(pathRef, NULL, x, y);
        }
        
        CGPathCloseSubpath(pathRef);
        if (points == points1) {
            path1 = pathRef;
        } else if (points == points2) {
            path2 = pathRef;
        } else {
            path3 = pathRef;
        }
        
        path = pathRef;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    if(isSelected == 0) {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(currentContext, DRAW_LINE_WIDTH);
        CGContextAddPath(currentContext, path);
        [selectedColor setStroke];
        
        CGContextSetAlpha(currentContext, 0.7);
        CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
        CGContextDrawPath(currentContext, kCGPathFillStroke);
    } else {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(currentContext, DRAW_LINE_WIDTH);
        if (isSelected == 1) {
            CGContextAddPath(currentContext, path1);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_ER_BUTTON_SD_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGContextAddPath(currentContext, path2);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGContextAddPath(currentContext, path3);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
        } else if (isSelected == 2) {
            CGContextAddPath(currentContext, path1);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGContextAddPath(currentContext, path2);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_ER_BUTTON_SD_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGContextAddPath(currentContext, path3);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
        } else {
            CGContextAddPath(currentContext, path1);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGContextAddPath(currentContext, path2);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_UR_BUTTON_GRAY_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            
            CGContextAddPath(currentContext, path3);
            CGContextSetAlpha(currentContext, 0.7);
            CGContextSetFillColorWithColor(currentContext, NEW_ER_BUTTON_SD_COLOR.CGColor);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
        }
    }
}

- (void) drawRect:(CGRect)rect {
    [self drowPath:path1 withPoints:points1];
    [self drowPath:path2 withPoints:points2];
    [self drowPath:path3 withPoints:points3];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    int select = [self testTouchPoint:p];
    if([delegate_ respondsToSelector:@selector(didSelectView:)]){
        [delegate_ didSelectView:select];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    int select = [self testTouchPoint:p];
    if([delegate_ respondsToSelector:@selector(didUnSelectView:)]){
        [delegate_ didUnSelectView:select];
    }
}

- (int) testTouchPoint:(CGPoint)pt {
    
    CGPoint pt1 = CGPointMake(pt.x, pt.y);
    
    if(CGPathContainsPoint(path1, NULL, pt1, NO)) {
        return 1;
    }
    if(CGPathContainsPoint(path2, NULL, pt1, NO)) {
        return 2;
    }
    if(CGPathContainsPoint(path3, NULL, pt1, NO)) {
        return 3;
    }
    return 0;
}

@end
