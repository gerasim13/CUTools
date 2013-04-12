//
//  NSSet+NSUserDefaults.m
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 23.09.12.
//
//

#import "NSSet+Archive.h"
#import "NSSet+Compare.h"

@implementation NSSet (Archive)

+ (id)setWithIdentifier:(NSString*)identifier
{
    return [self unarchiverSetWithIdentifier:identifier];
}

+ (id)unarchiverSetWithIdentifier:(NSString*)identifier
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:identifier];
    if (data != nil) {
        NSSet *set = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (set != nil && [set isKindOfClass:[NSSet class]]) {
            return [NSSet setWithSet:set];
        }
    }
    return [NSSet set];
}

- (void)archiveWithIdentifier:(NSString*)identifier
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:identifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)addObject:(id)object toSetWithIdentifier:(NSString*)identifier
{
    NSSet        *set    = [self setWithIdentifier:identifier];
    NSMutableSet *mutSet = [NSMutableSet setWithSet:set];
    if (![mutSet containsIdenticalObject:object]) {
        // Add object
        [mutSet addObject:object];
        [mutSet archiveWithIdentifier:identifier];
        return YES;
    }
    return NO;
}

+ (BOOL)removeObject:(id)object fromSetWithIdentifier:(NSString*)identifier
{
    NSSet        *set    = [self setWithIdentifier:identifier];
    NSMutableSet *mutSet = [NSMutableSet setWithSet:set];
    if ([mutSet containsObject:object]) {
        // Remove object
        [mutSet removeObject:object];
        [mutSet archiveWithIdentifier:identifier];
        return YES;
    }
    return NO;
}

+ (BOOL)updateObject:(id)object inSetWithIdentifier:(NSString*)identifier
{
    NSSet        *set    = [self setWithIdentifier:identifier];
    NSMutableSet *mutSet = [NSMutableSet setWithSet:set];
    NSObject     *oldObj = [set identicalObject:object];
    if (oldObj) {
        // Replace object
        [mutSet removeObject:oldObj];
        [mutSet addObject:object];
        [mutSet archiveWithIdentifier:identifier];
        return YES;
    }
    return NO;
}

@end
