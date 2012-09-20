//
//  NSObject+PerformBlock.m
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 31.08.12.
//
//

#import "NSObject+PerformBlock.h"

@implementation NSObject (PerformBlock)

- (void)performBlock:(void (^)())block afterDelay:(double)delay
{
    if (delay > 0) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), block);
    } else {
        block();
    }
}

- (void)performBlock:(void (^)())block
{
    [self performBlock:block afterDelay:0];
}

@end
