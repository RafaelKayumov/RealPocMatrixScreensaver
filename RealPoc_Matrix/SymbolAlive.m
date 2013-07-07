//
//  SymbolAlive.m
//  dfxgcvjhghfchngc
//
//  Created by  on 18.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SymbolAlive.h"
#define MATRIX_ALPHABET "123456789abcdefghigklmnopqrstuvwxyz$+-*/=%#&().,;:?!|{}<>"

@implementation SymbolAlive

@synthesize alpha, lifeTime, cellFrame, selfColor, lifeTimeLeft, symbolChangeChance, fontSize, sym;

-(id) initWithColor:(COLOR)initialColor andFrame:(CELL) initialCell andTime:(int)initialTime andFontSize:(int)initialFontSize
{
    self = [super init];
    self.fontSize = initialFontSize;
    self.lifeTime = initialTime;
    self.lifeTimeLeft = self.lifeTime;
    
    self.alpha = 1;
    
    self.cellFrame = initialCell;
    self.selfColor = initialColor;
    self.sym = [self returnRandomSymbol];
    return self;
}
-(void) recountSymbol
{
    self.lifeTimeLeft --;
    
    if((self.lifeTime - self.lifeTimeLeft) == 2)
    {
        selfColor.red = 80/256.f;
        selfColor.green = 248/256.f;
        selfColor.blue = 7/256.f;
    }
    self.alpha = (float)self.lifeTimeLeft / (float)self.lifeTime;
    if(self.alpha == 0)[self destroy];
    
    
    if([self changeSymbol])
    {
        self.sym = [self returnRandomSymbol];
    }
}
- (char) returnRandomSymbol
{
    int randomValue = 0 + (random() % (56));
    
    char retSym = MATRIX_ALPHABET[randomValue];
    
    return retSym;
}
-(BOOL) changeSymbol
{
    int randomValue = 0 + (random() % (99));
    
    if(randomValue > 95) return YES;
    else return NO;
}

-(void)destroy
{
    
}

@end
