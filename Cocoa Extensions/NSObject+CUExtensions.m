//
//  NSObject+CUExtensions.m
//  Loopseque
//
//  Created by Павел Савич on 12.09.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "NSObject+CUExtensions.h"

@implementation NSObject (CUExtensions)

- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay {
    [self performSelector:aSelector withObject:nil afterDelay:delay];
}

- (void)performSelectorOnce:(SEL)selector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:anArgument];
    [self performSelector:selector withObject:anArgument afterDelay:delay];
}

- (void)performSelectorOnce:(SEL)selector afterDelay:(NSTimeInterval)delay {
    [self performSelectorOnce:selector withObject:nil afterDelay:delay];
}


@end
