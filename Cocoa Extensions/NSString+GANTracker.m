//
//  NSString+GANTracker.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 30.01.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "NSString+GANTracker.h"

@implementation NSString (GANTracker)

- (NSString*)stringForGANTracker {
    return [[self stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString];
}

@end
