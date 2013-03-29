//
//  NSSet+Filter.m
//  MolodejjTV
//
//  Created by Павел Литвиненко on 29.03.13.
//
//

#import "NSSet+Filter.h"

@implementation NSSet (Filter)

- (id)filteredObjectWithPredicate:(NSPredicate*)predicate
{
    NSSet *filtered = [self filteredSetUsingPredicate:predicate];
    if (filtered.count > 0) {
        return [filtered anyObject];
    }
    return nil;
}

@end
