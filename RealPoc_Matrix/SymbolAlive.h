//
//  SymbolAlive.h
//  dfxgcvjhghfchngc
//
//  Created by  on 18.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymbolAlive : NSObject

typedef struct cell CELL;
struct cell
{ 
    int x;
    int y;
};
typedef struct color COLOR;
struct color
{ 
    float red;
    float green;
    float blue;
};

@property (nonatomic, assign) int lifeTime;
@property (nonatomic, assign) int lifeTimeLeft;
@property (nonatomic, assign) char sym;
@property (nonatomic, assign) COLOR selfColor;
@property (nonatomic, assign) float alpha;
@property (nonatomic, assign) int symbolChangeChance;
@property (nonatomic, assign) CELL cellFrame;
@property (nonatomic, assign) int fontSize;


-(id) initWithColor:(COLOR)initialColor andFrame:(CELL) initialCell andTime:(int)initialTime andFontSize:(int)initialFontSize;
-(void) recountSymbol;

@end
