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
    GraphModeParabola,
    GraphModeText,
    GraphModeLines,
    GraphModeTextParen,
    GraphModeStrayLine,
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
    NSString *shortText;
    NSString *text;
    NSString *fontName;
    NSFont *font;
    NSPoint textOrigin;
    int linesToDraw;
    NSMutableArray *word1s;
    NSMutableArray *word2s;
    NSMutableArray *word3s;
    NSMutableArray *word4s;
    int minDelay;
    int maxDelay;
    BOOL doParens;
}
@end
