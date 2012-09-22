//
//  NSMutableArray+MoveArray.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 24.01.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveArray)
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
@end
