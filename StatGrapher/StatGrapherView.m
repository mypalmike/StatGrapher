//
//  StatGrapherView.m
//  StatGrapher
//
//  Created by MICHAEL WHITE on 10/12/13.
//  Copyright (c) 2013 MICHAEL WHITE. All rights reserved.
//

#import "StatGrapherView.h"
#import <Appkit/NSText.h>

@implementation StatGrapherView

- (NSColor *) randomBGColor
{
    float brightness = SSRandomFloatBetween( 0.0, 0.1 );

    return [NSColor colorWithCalibratedRed:brightness
                                     green:brightness
                                      blue:brightness
                                     alpha:1.0];
}

- (NSColor *) randomAxisColor
{
    float red, green, blue;

    // Calculate a random color
    red = 0.5; // SSRandomFloatBetween( 0.5, 1.0 );
    green = SSRandomFloatBetween( 0.85, 1.0 );
    blue = 0.5; //SSRandomFloatBetween( 0.5, 1.0 );
    
    return [NSColor colorWithCalibratedRed:red
                                      green:green
                                       blue:blue
                                      alpha:1.0];
}

- (NSColor *) randomGridColor
{
    float red, green, blue;
    
    // Calculate a random color
    red = SSRandomFloatBetween( 0.2, 0.4 );
    green = SSRandomFloatBetween( 0.2, 0.4 );
    blue = SSRandomFloatBetween( 0.2, 0.4 );
    
    return [NSColor colorWithCalibratedRed:red
                                     green:green
                                      blue:blue
                                     alpha:1.0];
}

- (NSColor *) randomTextColor
{
    float red = 0.0;
    float green = 0.0;
    float blue = 0.0;
    int primary = SSRandomIntBetween(0, 5);
    if (primary == 0)
    {
        red = SSRandomFloatBetween( 0.9, 1.0 );
    }
    else if (primary == 1)
    {
        green = SSRandomFloatBetween( 0.9, 1.0 );
    }
    else if (primary == 2)
    {
        blue = SSRandomFloatBetween( 0.9, 1.0 );
    }
    else
    {
        float brightness = SSRandomFloatBetween( 0.9, 1.0 );
        red = brightness;
        green = brightness;
        blue = brightness;
    }
    
    return [NSColor colorWithCalibratedRed:red
                                     green:green
                                      blue:blue
                                     alpha:1.0];
}

- (NSColor *)randomLineColor
{
    float red, green, blue;
    
    // Calculate a random color
    red = SSRandomFloatBetween( 0.6, 0.9 );
    green = SSRandomFloatBetween( 0.6, 0.9 );
    blue = SSRandomFloatBetween( 0.6, 0.9 );
    
    return [NSColor colorWithCalibratedRed:red
                                     green:green
                                      blue:blue
                                     alpha:1.0];
}

- (int)minFontSize:(int)height
{
    return MAX(height / 30.0, 8.0);
}

- (NSSize)stringSize:(NSString *)string font:(NSFont *)theFont
{
    NSDictionary* attrs = [[NSDictionary alloc] initWithObjectsAndKeys:theFont, NSFontAttributeName, nil];
    return [string sizeWithAttributes:attrs];
}

- (int)maxFontSize:(NSString *)string width:(int)width height:(int)height font:(NSString *)fontN max:(int)max
{
    int minFontSize = [self minFontSize:height];
    int i;
    NSFont * currFont;
    for( i = max; i > minFontSize; i--)
    {
        currFont = [NSFont fontWithName:fontN size:i];
        NSSize strSize = [self stringSize:string font:currFont];
        if (strSize.width < width && strSize.height < height)
        {
            break;
        }
    }
    return i;
}

- (void)setMode:(GraphMode)mode frames:(int)untilAction
{
    graphMode = mode;
    framesUntilAction = untilAction;
}

- (void)resetGraph:(NSRect)frame isPreview:(BOOL)isPreview
{
    float width = frame.size.width;
    float height = frame.size.height;
    
    bgColor = [self randomBGColor];
    axisColor = [self randomAxisColor];
    gridColor = [self randomGridColor];
    textColor = [self randomTextColor];
    origin.x = SSRandomFloatBetween(0.0, width * 0.5);
    origin.y = SSRandomFloatBetween(0.0, height * 0.5);
    linesToDraw = SSRandomIntBetween(0, 4);
    
    text = @"Floatillabillionaire Rastermania Indexification (normalized)";
    fontName = @"Courier";
    int maxFontSize = [self maxFontSize:text width:width * 0.9 height:height * 0.9 font:fontName max:(int)height * 0.125];
    int fontSize = SSRandomIntBetween([self minFontSize:height], maxFontSize);
    font = [NSFont fontWithName:fontName size:fontSize];
    NSSize strSize = [self stringSize:text font:font];
    float maxTextX = width - strSize.width;
    textOrigin.x = SSRandomFloatBetween(maxTextX * 0.2, maxTextX * 0.8);
    textOrigin.y = SSRandomFloatBetween(height * 0.2, height * 0.8);

    [self setMode: GraphModeStart frames:0];
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:0.2];
    }

    [self resetGraph:frame isPreview:isPreview];

    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)line:(NSPoint)start to:(NSPoint)end width:(CGFloat)w
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    [path moveToPoint:start];
    [path lineToPoint:end];
    [path setLineWidth:w];
    [path stroke];
}

- (void)randomParabola:(NSSize)size width:(CGFloat)w
{
    float width = size.width;
    float height = size.height;
    
    float midX = SSRandomFloatBetween( width * 0.2, width * 0.8);
    float span = SSRandomFloatBetween( width * 0.2, width * 1.2);
    float minX = midX - span * 0.5;
    float maxX = midX + span * 0.5;
    float y, yControl;
    if( SSRandomIntBetween(0, 1) )
    {
        y = 0.0;
        yControl = SSRandomFloatBetween(height * 0.5, height * 1.4);
    }
    else
    {
        y = height;
        yControl = SSRandomFloatBetween(height * -0.4, height * 0.5);
    }
    
    NSPoint controlPoint = NSMakePoint(midX, yControl);
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(minX, y)];
    [path curveToPoint:NSMakePoint(maxX, y) controlPoint1:controlPoint controlPoint2:controlPoint];
    [path setLineWidth:w];
    [path stroke];
}

- (void)randomLine:(NSSize)size width:(CGFloat)w
{
    float centerX = SSRandomFloatBetween(size.width * 0.3, size.width * 0.7);
    float centerY = SSRandomFloatBetween(size.height * 0.3, size.height * 0.7);
    float slope = SSRandomFloatBetween(0.3, 1.5);
    if (SSRandomIntBetween(0, 1))
    {
        slope = -slope;
    }
    float x0 = 0.0;
    float x1 = size.width;
    float deltaX = x1 - centerX;
    float deltaY = deltaX * slope;
    float y1 = centerY + deltaY;
    deltaX = centerX - x0;
    deltaY = deltaX * slope;
    float y0 = centerY - deltaY;
    [self line:NSMakePoint(x0, y0) to:NSMakePoint(x1, y1) width:w];
}

- (void)animateOneFrame
{
    [super animateOneFrame];
    
    float width = [self bounds].size.width;
    float height = [self bounds].size.height;
    
    if(framesUntilAction-- > 0)
    {
        return;
    }
    
    if( graphMode == GraphModeStart )
    {
        [bgColor set];
        NSRectFill ( [self bounds] );
        [self setMode: GraphModeXAxis frames:0];
    }
    else if( graphMode == GraphModeXAxis ) {
        NSPoint start = NSMakePoint(0.0, origin.y);
        NSPoint end = NSMakePoint(width, origin.y);
        [axisColor set];
        [self line:start to:end width:MAX(1.0, height/200.0)];
        [self setMode: GraphModeYAxis frames:0];//;10];
    }
    else if( graphMode == GraphModeYAxis ) {
        NSPoint start = NSMakePoint(origin.x, 0.0);
        NSPoint end = NSMakePoint(origin.x, height);
        [axisColor set];
        [self line:start to:end width:MAX(1.0, height/200.0)];
        [self setMode: GraphModeHorizontals frames:0];//10];
    }
    else if( graphMode == GraphModeHorizontals) {
        float height = [self bounds].size.height;
        float initialLineDist;
        float logScale;
        if( SSRandomIntBetween( 0, 10 ) > 5 )
        {
            initialLineDist = SSRandomFloatBetween(height / 12.0, height / 15.0);
            logScale =  SSRandomFloatBetween(1.3, 1.6);
        }
        else
        {
            initialLineDist = SSRandomFloatBetween(height / 20.0, height / 4.0);
            logScale = SSRandomFloatBetween(0.6, 0.8);
        }
        [gridColor set];
        float y = origin.y;
        float lineDist = initialLineDist;
        while( y > 0.0 && lineDist > [self bounds].size.height / 100.0 )
        {
            y -= lineDist;
            if( y > 0.0 )
            {
                lineDist *= logScale;
                NSPoint start = NSMakePoint(0.0, y);
                NSPoint end = NSMakePoint([self bounds].size.width, y);
                [self line:start to:end width:1.0];
            }
        }
        y = origin.y;
        lineDist = initialLineDist;
        while( y < [self bounds].size.height && lineDist > [self bounds].size.height / 100.0)
        {
            y += lineDist;
            if( y < [self bounds].size.height )
            {
                lineDist *= logScale;
                NSPoint start = NSMakePoint(0.0, y);
                NSPoint end = NSMakePoint([self bounds].size.width, y);
                [self line:start to:end width:1.0];
            }
        }
        [self setMode: GraphModeVerticals frames:0];//10];
    }
    else if( graphMode == GraphModeVerticals)
    {
        float width = [self bounds].size.width;
        float height = [self bounds].size.height;
        // Use height as guide so it's similar in scale to horizontals
        float lineDist = SSRandomFloatBetween(height / 20.0, height / 4.0);
        [gridColor set];
        float x = origin.x;
        while( x > 0.0 )
        {
            x -= lineDist;
            if( x > 0.0 )
            {
                NSPoint start = NSMakePoint(x, 0);
                NSPoint end = NSMakePoint(x, width);
                [self line:start to:end width:1.0];
            }
        }
        x = origin.x;
        while( x < width )
        {
            x += lineDist;
            if( x < width )
            {
                NSPoint start = NSMakePoint(x, 0);
                NSPoint end = NSMakePoint(x, width);
                [self line:start to:end width:1.0];
            }
        }
        [self setMode: GraphModeText frames:0];//10];
    }
    else if( graphMode == GraphModeText)
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];

        NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:text attributes: attributes];
        [currentText drawAtPoint:textOrigin];
        
        [self setMode: GraphModeParabola frames:0];//10];
    }
    else if( graphMode == GraphModeParabola )
    {
        [[self randomLineColor] set];
        [self randomParabola:[self bounds].size width:MAX(1.0, height/400.0)];
        [self setMode: GraphModeLines frames:0];//10];
    }
    else if( graphMode == GraphModeLines )
    {
        [[self randomLineColor] set];
        if (SSRandomIntBetween(0, 3) == 0)
        {
            [self randomParabola:[self bounds].size width:MAX(1.0, height/400.0)];
        }
        else
        {
            [self randomLine:[self bounds].size width:MAX(1.0, height/400.0)];
        }
        
        if (linesToDraw-- > 0)
        {
            [self setMode: GraphModeLines frames:0];//10];
        }
        else
        {
            [self setMode: GraphModeReset frames:0];//10];
        }
    }
    else if( graphMode == GraphModeReset )
    {
        [self resetGraph:[self bounds] isPreview:[self isPreview]];
    }
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
