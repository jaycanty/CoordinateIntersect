//
//  CrossLineView.m
//  Commuter
//
//  Created by j on 2/15/13.
//  Copyright (c) 2013 j. All rights reserved.
//

#define ARROW_LENGTH 30.0f

#import "LineView.h"

@interface LineView()

@end

@implementation LineView

@synthesize pointA, pointB;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:23.0/255.0 green:45.0/255.0 blue:121.0/255.0 alpha:0.1];
        self.userInteractionEnabled = NO;

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);

    // draw start line
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    CGContextMoveToPoint(context, self.pointA.x, self.pointA.y); //start at this point
    CGContextAddLineToPoint(context, self.pointB.x, self.pointB.y); //draw to this point
    
    CGContextStrokePath(context);
    
    /*
    // draw direction arrow
    CGPoint midPoint = CGPointMake( (self.pointA.x + self.pointB.x)/2, (self.pointA.y + self.pointB.y)/2 );
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextMoveToPoint(context, midPoint.x, midPoint.y); //start at this point
    
    double yDelta = (self.pointB.y - self.pointA.y);
    double xDelta = (self.pointB.x - self.pointA.x);
    
    if (yDelta == 0 && xDelta == 0)
    {
        //on top of each other
        CGContextAddLineToPoint(context, midPoint.x, midPoint.y); //draw no arrow
        
    }
    else
    {
        double factor = sqrt( pow(ARROW_LENGTH,2) / ( pow(xDelta, 2) + pow(yDelta, 2)) );
        CGContextAddLineToPoint(context, midPoint.x - yDelta*factor,
                                midPoint.y + xDelta*factor); //draw no arrow
    
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
     */
}


@end
