//
//  VideoProgressIndicator.m
//  SEVEN
//
//  Created by Bobby Ren on 7/28/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "VideoProgressIndicator.h"

#define SECS_PER_CLIP 3
#define MAX_CLIPS 2
#define TIMER_RADS_PER_SECOND (2*M_PI/(SECS_PER_CLIP * MAX_CLIPS))
#define TIMER_RADS_PER_CENT (2.0*M_PI/100.0)
#define BEZIER_WIDTH 8

@implementation VideoProgressIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}
#pragma mark Progress
-(float)updateProgress:(float)timeInSec {
    percentDone = timeInSec / (SECS_PER_CLIP*MAX_CLIPS) * 100;
    if (percentDone > 100)
        percentDone = 100;
    [self setNeedsDisplay];
    return percentDone;
}

-(UIBezierPath*)getCurveForPercent:(float)percent {
    float startAngle = 0, endAngle;

    endAngle = TIMER_RADS_PER_CENT * percent;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 );
    float radius = self.frame.size.height/2 - BEZIER_WIDTH/2;
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [bezierPath setLineWidth:BEZIER_WIDTH];
    [bezierPath setLineCapStyle:kCGLineCapSquare];
    return bezierPath;
}

#pragma mark Drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // outer circle
    [self drawOuterCircle:rect];

    // progress
    if (percentDone > 0) {
        [self drawPercent:percentDone color:[UIColor blueColor] rect:rect];
    }
}

-(void)drawOuterCircle:(CGRect)rect {
    [self drawPercent:100 color:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] rect:rect];
}

-(void)drawPercent:(float)percent color:(UIColor *)color rect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *aPath = [self getCurveForPercent:percent]; //[self progressPath];

    // If you have content to draw after the shape,
    // save the current state before changing the transform.
    CGContextSaveGState(context);

    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, 0, 0); //self.frame.size.width / 2, self.frame.size.height / 2);

    // translate to center in order to rotate, then translate back
    CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.height / 2);
    CGContextRotateCTM(context, -M_PI/2); // left side of square of the start stroke should not be centered
    CGContextTranslateCTM(context, -self.frame.size.width / 2, -self.frame.size.height / 2);

    // Adjust the drawing options as needed.

    [color setStroke];
    [aPath stroke];

    CGContextRestoreGState(context);
}

@end
