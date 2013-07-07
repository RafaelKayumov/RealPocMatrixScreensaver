//
//  RealPoc_MatrixView.m
//  RealPoc_Matrix
//
//  Created by Rafael Kayumov on 26.09.12.
//  Copyright (c) 2012 Rafael Kayumov. All rights reserved.
//

#import "RealPoc_MatrixView.h"
#import "SymbolAlive.h"
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>

#define SYMBOLS_FONT_SIZE 17
#define ROWS_COUNT (int)((float)self.bounds.size.width/(float)SYMBOLS_FONT_SIZE)
#define CELLS_IN_ROW (int)((float)self.bounds.size.height/(float)SYMBOLS_FONT_SIZE)

#define MATRIX_FONT "Matrix Code NFI"
#define USUAL_FONT "Helvetica-Bold"

@implementation RealPoc_MatrixView

@synthesize count = _count;
@synthesize rowsArray = _rowsArray;
@synthesize value = _value;

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self)
    {
        self.rowsArray = [[NSMutableArray alloc] init];
        for(int i = 0; i<ROWS_COUNT; i++)
        {
            NSMutableArray *ar = [[NSMutableArray alloc] init];
            [self.rowsArray addObject:ar];
        }
        for(int i = 0; i<ROWS_COUNT; i++)
        {
            int row = i;
            int randomSpeed = 10 + (random() % (25));
            int randomLifeTime = 5 + (random() % (20));
            
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            
            [parameters setObject:[NSNumber numberWithInt:row] forKey:@"row"];
            [parameters setObject:[NSNumber numberWithInt:randomSpeed] forKey:@"speed"];
            [parameters setObject:[NSNumber numberWithInt:randomLifeTime] forKey:@"lifeTime"];
            
            [self startRowThreadWithParameters:parameters];
        }
        [self setAnimationTimeInterval:1/20.0];
    }
    return self;
}

- (void) SomeAction:(id)anObject
{
    @autoreleasepool {
        NSMutableDictionary *parameters = (NSMutableDictionary *)anObject;
        NSNumber *rowIndex = [parameters objectForKey:@"row"];
        NSNumber *speed = [parameters objectForKey:@"speed"];
        NSNumber *lifeTime = [parameters objectForKey:@"lifeTime"];
        
        int i=0;
        
        while (i<CELLS_IN_ROW)
        {
            COLOR col;
            col.red = 230.f/256.f;
            col.green = 253.0f/256.f;
            col.blue = 157.0f/256.f;
            
            CELL cell;
            
            cell.x = (int)[rowIndex integerValue];
            cell.y = (int)[(NSMutableArray *)[self.rowsArray objectAtIndex:[rowIndex integerValue]] count];
            
            int fontSize = SYMBOLS_FONT_SIZE;
            int initialLifeTime = (int)[lifeTime integerValue];
            
            SymbolAlive *s = [[SymbolAlive alloc] initWithColor:col andFrame:cell andTime:initialLifeTime andFontSize:fontSize];
            
            if(i < (int)[(NSMutableArray *)[self.rowsArray objectAtIndex:[rowIndex integerValue]] count] && [(NSMutableArray *)[self.rowsArray objectAtIndex:[rowIndex integerValue]] count]>0)
            {
                SymbolAlive * curS = [[self.rowsArray objectAtIndex:[rowIndex integerValue]] objectAtIndex:i];
                curS.selfColor = col;
                curS.lifeTime = [lifeTime integerValue];
                curS.lifeTimeLeft = curS.lifeTime;
                curS.alpha = 1;
            }
            else [[self.rowsArray objectAtIndex:[rowIndex integerValue]] addObject:s];
            
            i++;
            [NSThread sleepForTimeInterval: 1/[speed floatValue]];
            
        }
        
        int randomSpeed = 5 + (random() % (15));
        int randomLifeTime = 10 + (random() % (35));

        NSMutableDictionary *newParams = [[NSMutableDictionary alloc] init];
        [newParams setObject:rowIndex forKey:@"row"];
        [newParams setObject:[NSNumber numberWithInt:randomSpeed] forKey:@"speed"];
        [newParams setObject:[NSNumber numberWithInt:randomLifeTime] forKey:@"lifeTime"];
        
        [self performSelectorOnMainThread:@selector(startRowThreadWithParameters:) withObject:newParams waitUntilDone:NO];
        [NSThread exit];
    
    }
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

- (void)startRowThreadWithParameters:(NSMutableDictionary *)params
{
    [NSThread detachNewThreadSelector:@selector(SomeAction:) toTarget:self withObject:params];
}

void MyDrawText (CGContextRef myContext, CGRect contextRect, CGPoint drawPoint, char sym, COLOR col, float alpha) // 1
{
    CGFloat w, h;
    w = contextRect.size.width;
    h = contextRect.size.height;
    
    //NSString *postScriptName = (NSString *)CFBridgingRelease(CTFontCopyPostScriptName([RealPoc_MatrixView fontFromBundle:MATRIX_FONT withHeight:SYMBOLS_FONT_SIZE]));
    
    
    CGContextSelectFont (myContext,
                         MATRIX_FONT,
                         SYMBOLS_FONT_SIZE,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (myContext, 1);
    CGContextSetTextDrawingMode (myContext, kCGTextFill);
    
    CGContextSetRGBFillColor (myContext, col.red, col.green, col.blue, alpha); 
    
    NSString *s = [NSString stringWithFormat:@"%c",sym];
       
    CGContextShowTextAtPoint (myContext, drawPoint.x, drawPoint.y, [s UTF8String], 1);
}

- (void)animateOneFrame
{
    [self drawRect:NSRectFromCGRect(self.bounds)];
    
    CGContextRef theContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGRect viewBounds = self.bounds;
   
    for (int x = 0; x<[self.rowsArray count];x++)
    {
        for(int y=0; y<[(NSMutableArray *)[self.rowsArray objectAtIndex:x] count]; y++)
        {
            if([(NSMutableArray *)[self.rowsArray objectAtIndex:x] objectAtIndex:y] != nil)
            {
                SymbolAlive *currentSymbol = (SymbolAlive *)[(NSMutableArray *)[self.rowsArray objectAtIndex:x] objectAtIndex:y];
                if(currentSymbol.alpha > 0)
                {
                    MyDrawText(theContext, viewBounds, CGPointMake(currentSymbol.cellFrame.x * SYMBOLS_FONT_SIZE, self.bounds.size.height - (currentSymbol.cellFrame.y * SYMBOLS_FONT_SIZE)), currentSymbol.sym, currentSymbol.selfColor, currentSymbol.alpha);
                
                    [currentSymbol recountSymbol];
                }
            }
        }
    }
    return;
}

/*+ (CTFontRef) fontFromBundle : (NSString*) fontName withHeight : (CGFloat) height;
{
    // Get the path to our custom font and create a data provider.
    NSString* fontPath = [[NSBundle mainBundle] pathForResource : fontName
                                                         ofType : @"ttf" ];
    if (nil==fontPath)
        return NULL;
    
    CGDataProviderRef dataProvider =
    CGDataProviderCreateWithFilename ([fontPath UTF8String]);
    if (NULL==dataProvider)
        return NULL;
    
    // Create the font with the data provider, then release the data provider.
    CGFontRef fontRef = CGFontCreateWithDataProvider ( dataProvider );
    if ( NULL == fontRef )
    {
        CGDataProviderRelease ( dataProvider );
        return NULL;
    }
    
    CTFontRef fontCore = CTFontCreateWithGraphicsFont(fontRef, height, NULL, NULL);
    CGDataProviderRelease (dataProvider);
    CGFontRelease(fontRef);
    
    return fontCore;
}*/

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
