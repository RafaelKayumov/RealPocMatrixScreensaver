//
//  RealPoc_MatrixView.h
//  RealPoc_Matrix
//
//  Created by Rafael Kayumov on 26.09.12.
//  Copyright (c) 2012 Rafael Kayumov. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface RealPoc_MatrixView : ScreenSaverView

@property (readwrite) int count;
@property (readwrite) int value;
@property (nonatomic, strong) NSMutableArray *rowsArray;

@end
