//
//  NSMutableArray+MoveArray.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 24.01.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "NSMutableArray+MoveArray.h"

@implementation NSMutableArray (MoveArray)
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [obj retain];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
        [obj release];
    }
}
@end
