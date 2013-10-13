//
//  StatGrapherView.h
//  StatGrapher
//
//  Created by MICHAEL WHITE on 10/12/13.
//  Copyright (c) 2013 MICHAEL WHITE. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

typedef NS_ENUM(NSInteger, GraphMode) {
    GraphModeStart,
    GraphModeXAxis,
    GraphModeYAxis,
    GraphModeHorizontals,
    GraphModeVerticals,
    GraphModeText,
    GraphModeParabola,
    GraphModeLines,
    GraphModeReset
};

@interface StatGrapherView : ScreenSaverView
{
    GraphMode graphMode;
    int framesUntilAction;
    NSColor *bgColor;
    NSColor *axisColor;
    NSColor *gridColor;
    NSColor *textColor;
    NSPoint origin;
    NSString *text;
    NSString *fontName;
    NSFont *font;
    NSPoint textOrigin;
    int linesToDraw;
}
@end
