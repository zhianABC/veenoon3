//
//  GradeLineView.m
//  veenoon
//
//  Created by chen jack on 2018/2/26.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "GradeLineView.h"

@interface GradeLineView ()
{
    CGPathRef path;
}
@property (nonatomic, strong) NSMutableArray *points;

@end


@implementation GradeLineView
@synthesize points;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
   -20-40-|           |-20-
 */

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        int badge = 20;
        int x = badge+40;
        int w = (frame.size.width - x - badge);
        int sp = w/5;
        int y = badge;
        
        for(int i = 0; i < 6; i++)
        {
            CGRect rc = CGRectMake(x, y, w, 1);
            UIImageView *line = [[UIImageView alloc] initWithFrame:rc];
            line.backgroundColor = YELLOW_COLOR;
            [self addSubview:line];
            
            y+=sp;
        }
        
        y = badge;
        for(int i = 0; i < 6; i++)
        {
            CGRect rc = CGRectMake(x, y, 1, w);
            UIImageView *line = [[UIImageView alloc] initWithFrame:rc];
            line.backgroundColor = YELLOW_COLOR;
            [self addSubview:line];
            
            x+=sp;
        }
        
        
        
    }
    return self;
}

- (void) drawXY:(NSArray*)xs y:(NSArray*)ys{
    
    
    
    int badge = 20;
    int x = badge+40;
    int w = (self.frame.size.width - x - badge);
    int sp = w/5;
    int y = badge;
    
    for(int i = 0; i < 6; i++)
    {
        if(i < [ys count])
        {
            int dlt = 5;
            if(i == 0)
                dlt = 10;
        CGRect rc = CGRectMake(0, y-dlt, 50, 20);
        UILabel *lb = [[UILabel alloc] initWithFrame:rc];
        lb.textColor = [UIColor whiteColor];
        [self addSubview:lb];
        
        lb.font = [UIFont systemFontOfSize:13];
        lb.textAlignment = NSTextAlignmentRight;
        
        lb.text = [ys objectAtIndex:i];
        
        y+=sp;
        }
    }
    
    int xx = 0;
    y = badge+w+5;
    int ww = sp;
    for(int i = 0; i < 6; i++)
    {
        if(i < [xs count])
        {
            if(i == 0)
                ww = 45;
            else
                ww = sp;
            CGRect rc = CGRectMake(xx, y, ww+5, 20);
            UILabel *lb = [[UILabel alloc] initWithFrame:rc];
            lb.textColor = [UIColor whiteColor];
            [self addSubview:lb];
            
            lb.font = [UIFont systemFontOfSize:13];
            lb.textAlignment = NSTextAlignmentRight;
            
            lb.text = [xs objectAtIndex:i];
            
            if(i == 0)
                xx+=60;
            else
                xx+=ww;
        }
    }
}

- (void) processValueToPoints
{
    self.points = [NSMutableArray array];
    
    int badge = 20;
    int x = badge+40;
    int w = (self.frame.size.width - x - badge);
    int sp = w/5;
    int y = badge;
    [points addObject:@{@"x":[NSNumber numberWithInt:x],
                        @"y":[NSNumber numberWithInt:badge+w]}];
    
    [points addObject:@{@"x":[NSNumber numberWithInt:x+2*sp],
                        @"y":[NSNumber numberWithInt:y+3*sp]}];
    
    [points addObject:@{@"x":[NSNumber numberWithInt:x+w],
                        @"y":[NSNumber numberWithInt:y+2*sp]}];
    
    [points addObject:@{@"x":[NSNumber numberWithInt:x+w],
                        @"y":[NSNumber numberWithInt:y+w]}];
    
    [self setNeedsDisplay];
}
- (void) drawRect:(CGRect)rect
{
    if([points count] == 0)
        return;
    
    if(!path)
    {
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        for(int i = 0; i < [points count]; i++)
        {
            NSDictionary *pt = [points objectAtIndex:i];
            float x = [[pt objectForKey:@"x"] floatValue];
            float y = [[pt objectForKey:@"y"] floatValue];

            if(i == 0)
                CGPathMoveToPoint(pathRef, NULL, x, y);
            else
                CGPathAddLineToPoint(pathRef, NULL, x, y);
        }
        
        if([points count])
        {
            NSDictionary *pt = [points objectAtIndex:0];
            float x = [[pt objectForKey:@"x"] floatValue];
            float y = [[pt objectForKey:@"y"] floatValue];
            
            CGPathAddLineToPoint(pathRef, NULL, x, y);
        }
        
        CGPathCloseSubpath(pathRef);
        path = pathRef;
        
        
    }
    
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1);
    CGContextAddPath(currentContext, path);
    [YELLOW_COLOR setStroke];
    
    UIColor *fillColor = RGBA(1, 138, 182, 0.6);
    CGContextSetFillColorWithColor(currentContext, fillColor.CGColor);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
   
}

@end
