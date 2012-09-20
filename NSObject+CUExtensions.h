//
//  NSObject+CUExtensions.h
//  Loopseque
//
//  Created by Павел Савич on 12.09.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CUExtensions)

- (void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)delay;
- (void)performSelectorOnce:(SEL)selector afterDelay:(NSTimeInterval)delay;
- (void)performSelectorOnce:(SEL)selector withObject:(id)anArgument afterDelay:(NSTimeInterval)delay;

@end
