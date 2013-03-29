//
//  NSSet+Compare.m
//  MolodejjTV
//
//  Created by Павел Литвиненко on 29.03.13.
//
//

#import "NSSet+Compare.h"

@implementation NSSet (Compare)

- (BOOL)containsIdenticalObject:(NSObject*)object
{
    NSObject *obj = [self identicalObject:object];
    return (obj != nil);
}

- (id)identicalObject:(NSObject*)object
{
    for (NSObject *obj in self) {
        if ([obj isEqual:object]) {
            return obj;
        }
    }
    return nil;
}

@end
