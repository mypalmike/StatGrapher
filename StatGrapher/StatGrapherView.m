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

- (NSURL*)applicationDirectory
{
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager*fm = [NSFileManager defaultManager];
    NSURL*    dirPath = nil;
    
    // Find the application support directory in the home directory.
    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
                                        inDomains:NSUserDomainMask];
    if ([appSupportDir count] > 0)
    {
        // Append the bundle ID to the URL for the
        // Application Support directory
        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
        
        // If the directory does not exist, this method creates it.
        // This method call works in OS X 10.7 and later only.
        NSError*    theError = nil;
        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
                           attributes:nil error:&theError])
        {
            return nil;
        }
    }
    
    return dirPath;
}

- (void) loadWords
{
    word1s = [[NSMutableArray alloc] init];
    word2s = [[NSMutableArray alloc] init];
    word3s = [[NSMutableArray alloc] init];
    word4s = [[NSMutableArray alloc] init];
    
    NSURL *dirUrl = [self applicationDirectory];
    if (dirUrl)
    {
        NSURL *fileUrl = [dirUrl URLByAppendingPathComponent:@"statgrapher_words"];
        NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:nil];
        NSData* fileContents = nil;
        if (aHandle)
        {
            fileContents = [aHandle readDataToEndOfFile];
            NSString *fileContentsStr = [[NSString alloc] initWithData:fileContents
                                                      encoding:NSUTF8StringEncoding];

            NSArray *lines = [fileContentsStr componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
            
            NSMutableArray *currArr = word1s;
            for (NSString *line in lines)
            {
                NSString *trimmedLine = [line stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];

                if ([trimmedLine isEqual:@"*1*"])
                {
                    currArr = word1s;
                }
                else if ([trimmedLine isEqual:@"*2*"])
                {
                    currArr = word2s;
                }
                else if ([trimmedLine isEqual:@"*3*"])
                {
                    currArr = word3s;
                }
                else if ([trimmedLine isEqual:@"*4*"])
                {
                    currArr = word4s;
                }
                else if ([trimmedLine length] > 0)
                {
                    [currArr addObject:trimmedLine];
                }
            }
        }
    }
    // Fill in defaults if no file (or section in file) found.
    if ([word1s count] < 1)
    {
        word1s = [[NSMutableArray alloc] initWithObjects:@"Interpolated",
                  @"Haptic", @"Approximate", @"Expected", @"Runtime", @"Tangential",
                  @"Emergency failover", @"Improved", @"Quantum", @"Angular", @"Mechanical", nil];
    }
    if ([word2s count] < 1)
    {
        word2s = [[NSMutableArray alloc] initWithObjects:@"phase diffusion",
                  @"real", @"token", @"orbital", @"suction",
                  @"direction", @"strong force", @"computed", @"vibration",
                  @"subchannel spectrum", @"diffusion field", @"radioactive", nil];
    }
    if ([word3s count] < 1)
    {
        word3s = [[NSMutableArray alloc] initWithObjects: @"thrust", @"vector",
                  @"angle", @"force", @"power", @"length",
                  @"area", @"entropy", @"velocity", @"cycle", @"torque",
                  @"bearings", nil];
    }
    if ([word4s count] < 1)
    {
        word4s = [[NSMutableArray alloc] initWithObjects:@"[measured]", @"(cubic nanometers)",
                  @"[projected]", @"(per minute)", @"[amortized]", @"[normalized]", @"[off peak]",
                  @"(parts per billion)", @"[observed]", @"[modeled]", nil];
        

    }
}

- (NSArray *) getRandomWords
{
    NSString *word1;
    NSString *word2;
    NSString *word3;
    NSString *word4;
    
    word1 = [word1s objectAtIndex:SSRandomIntBetween(0, (int)[word1s count] - 1)];
    word2 = [word2s objectAtIndex:SSRandomIntBetween(0, (int)[word2s count] - 1)];
    word3 = [word3s objectAtIndex:SSRandomIntBetween(0, (int)[word3s count] - 1)];
    word4 = [word4s objectAtIndex:SSRandomIntBetween(0, (int)[word4s count] - 1)];
    
    if (SSRandomIntBetween(0, 100) == 0)
    {
        word4 = @"puppies";
    }
    
    NSArray *words = [[NSArray alloc] initWithObjects:word1, word2, word3, word4, nil];
    return words;
}

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
    red = SSRandomFloatBetween( 0.4, 0.6 );
    green = SSRandomFloatBetween( 0.6, 0.9 );
    blue = SSRandomFloatBetween( 0.4, 0.6 );
    
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
    origin.x = SSRandomFloatBetween(width * 0.05, width * 0.95);
    origin.y = SSRandomFloatBetween(height * 0.05, height * 0.95);
    linesToDraw = SSRandomIntBetween(0, 4);
    doParens = (SSRandomIntBetween(0, 2) == 0);
    
    NSArray *words = [self getRandomWords];
    text = [NSString stringWithFormat:@"%@ %@ %@ %@", [words objectAtIndex:0], [words objectAtIndex:1], [words objectAtIndex:2], [words objectAtIndex:3]];
    shortText = [NSString stringWithFormat:@"%@ %@ %@", [words objectAtIndex:0], [words objectAtIndex:1], [words objectAtIndex:2]];
    fontName = @"Verdana";
    int maxFontSize = [self maxFontSize:text width:width * 0.9 height:height * 0.9 font:fontName max:(int)height * 0.125];
    int fontSize = SSRandomIntBetween([self minFontSize:height], maxFontSize);
    font = [NSFont fontWithName:fontName size:fontSize];
    NSSize strSize = [self stringSize:text font:font];
    float maxTextX = width - strSize.width;
    textOrigin.x = SSRandomFloatBetween(maxTextX * 0.2, maxTextX * 0.8);
    textOrigin.y = SSRandomFloatBetween(height * 0.1, height * 0.3);
    if (SSRandomIntBetween(0, 1))
    {
        textOrigin.y = height - textOrigin.y;
    }

    [self setMode: GraphModeStart frames:0];
}

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAnimationTimeInterval:0.2];
    }

    minDelay = 3;
    maxDelay = 15;
    
    [self loadWords];
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

- (void)randomBend:(NSSize)size width:(CGFloat)w
{
    float width = size.width;
    float height = size.height;
    
    float sideX = SSRandomFloatBetween(width * -0.6, width * -0.3);
    float sideY = SSRandomIntBetween(height * 0.6, height);
    float vertX = SSRandomIntBetween(width * 0.6, width);
    float vertY = SSRandomFloatBetween(width * -0.6, width * -0.3);

    if (SSRandomIntBetween(0, 1) == 0)
    {
        sideX = width - sideX;
        vertX = width - vertX;
    }
    if (SSRandomIntBetween(0, 1) == 0)
    {
        sideY = height - sideY;
        vertY = height - vertY;
    }
    
    NSPoint controlPoint = NSMakePoint(vertX, sideY);
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(sideX, sideY)];
    [path curveToPoint:NSMakePoint(vertX, vertY) controlPoint1:controlPoint controlPoint2:controlPoint];
    [path setLineWidth:w];
    [path stroke];
}

- (void)randomCurve:(NSSize)size width:(CGFloat)w
{
    if (SSRandomIntBetween(0, 1) == 0)
    {
        [self randomParabola:size width:w];
    }
    else
    {
        [self randomBend:size width:w];
    }
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

- (void)drawTextShort
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:shortText attributes: attributes];
    [currentText drawAtPoint:textOrigin];
}

- (void)drawTextLong
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    
    NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:text attributes: attributes];
    [currentText drawAtPoint:textOrigin];
}

- (int)getDelay
{
    return SSRandomIntBetween(minDelay, maxDelay);
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
        [self setMode: GraphModeXAxis frames:4];
    }
    else if( graphMode == GraphModeXAxis ) {
        NSPoint start = NSMakePoint(0.0, origin.y);
        NSPoint end = NSMakePoint(width, origin.y);
        [axisColor set];
        [self line:start to:end width:MAX(1.0, height/200.0)];
        [self setMode: GraphModeYAxis frames:[self getDelay]];
    }
    else if( graphMode == GraphModeYAxis ) {
        NSPoint start = NSMakePoint(origin.x, 0.0);
        NSPoint end = NSMakePoint(origin.x, height);
        [axisColor set];
        [self line:start to:end width:MAX(1.0, height/200.0)];
        [self setMode: GraphModeHorizontals frames:[self getDelay]];
    }
    else if( graphMode == GraphModeHorizontals) {
        float logScale;
        float initialLineDist = SSRandomFloatBetween(height / 40.0, height / 25.0);
        logScale =  SSRandomFloatBetween(1.0, 1.25);
        [gridColor set];
        
        float lineDist = initialLineDist;
        float y = origin.y - lineDist;
        while( y > 0.0 )
        {
            lineDist *= logScale;
            NSPoint start = NSMakePoint(0.0, y);
            NSPoint end = NSMakePoint(width, y);
            [self line:start to:end width:1.0];
            y -= lineDist;
        }
        
        lineDist = initialLineDist;
        y = origin.y + lineDist;
        while( y < height )
        {
            lineDist *= logScale;
            NSPoint start = NSMakePoint(0.0, y);
            NSPoint end = NSMakePoint(width, y);
            [self line:start to:end width:1.0];
            y += lineDist;
        }
        
        [self setMode: GraphModeVerticals frames:[self getDelay]];
    }
    else if( graphMode == GraphModeVerticals)
    {
        float logScale;
        float initialLineDist = SSRandomFloatBetween(height / 40.0, height / 25.0);
        logScale =  SSRandomFloatBetween(1.0, 1.25);
        [gridColor set];
        
        float lineDist = initialLineDist;
        float x = origin.x - lineDist;
        while( x > 0.0 )
        {
            lineDist *= logScale;
            NSPoint start = NSMakePoint(x, 0.0);
            NSPoint end = NSMakePoint(x, height);
            [self line:start to:end width:1.0];
            x -= lineDist;
        }
        
        lineDist = initialLineDist;
        x = origin.x + lineDist;
        while( x < width )
        {
            lineDist *= logScale;
            NSPoint start = NSMakePoint(x, 0.0);
            NSPoint end = NSMakePoint(x, height);
            [self line:start to:end width:1.0];
            x += lineDist;
        }
        
        [self setMode: GraphModeParabola frames:[self getDelay]];
    }
    else if( graphMode == GraphModeParabola )
    {
        [[self randomLineColor] set];
        [self randomCurve:[self bounds].size width:MAX(1.0, height/400.0)];
        [self setMode: GraphModeText frames:[self getDelay]];
    }
    else if( graphMode == GraphModeText)
    {
        [self drawTextShort];
        [self setMode: GraphModeLines frames:[self getDelay] * 2];
    }
    else if( graphMode == GraphModeLines )
    {
        if (linesToDraw-- > 0)
        {
            [[self randomLineColor] set];
            if (SSRandomIntBetween(0, 2) == 0)
            {
                [self randomCurve:[self bounds].size width:MAX(1.0, height/400.0)];
            }
            else
            {
                [self randomLine:[self bounds].size width:MAX(1.0, height/400.0)];
            }
            [self drawTextShort];
            [self setMode: GraphModeLines frames:[self getDelay]];
        }
        else
        {
            [self setMode: GraphModeTextParen frames:[self getDelay] * 2];
        }
    }
    else if( graphMode == GraphModeTextParen)
    {
        if( doParens )
        {
            [self drawTextLong];
        }
        
        if (SSRandomIntBetween(0, 10) == 0)
        {
            [self setMode: GraphModeStrayLine frames:[self getDelay] * 4];
        }
        else
        {
            [self setMode: GraphModeReset frames:maxDelay];
        }
    }
    else if( graphMode == GraphModeStrayLine )
    {
        [[self randomLineColor] set];
        [self randomLine:[self bounds].size width:MAX(1.0, height/400.0)];
        if( doParens )
        {
            [self drawTextLong];
        }
        [self setMode: GraphModeReset frames:1];
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
