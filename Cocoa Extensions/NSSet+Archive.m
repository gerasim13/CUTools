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
        id set = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (set) {
            return set;
        }
    }
    return [self set];
}

- (void)archiveWithIdentifier:(NSString*)identifier
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:identifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)addObject:(id)object toSetWithIdentifier:(NSString*)identifier
{
    NSMutableSet *set = [NSMutableSet setWithIdentifier:identifier];
    if (![set containsIdenticalObject:object]) {
        // Add object
        [set addObject:object];
        [set archiveWithIdentifier:identifier];
        return YES;
    }
    return NO;
}

+ (BOOL)removeObject:(id)object fromSetWithIdentifier:(NSString*)identifier
{
    NSMutableSet *set = [NSMutableSet setWithIdentifier:identifier];
    if ([set containsObject:object]) {
        // Remove object
        [set removeObject:object];
        [set archiveWithIdentifier:identifier];
        return YES;
    }
    return NO;
}

+ (BOOL)updateObject:(id)object inSetWithIdentifier:(NSString*)identifier
{
    NSMutableSet *set = [NSMutableSet setWithIdentifier:identifier];
    NSObject     *oldObj = [set identicalObject:object];
    if (oldObj) {
        // Replace object
        [set removeObject:oldObj];
        [set addObject:object];
        [set archiveWithIdentifier:identifier];
        return YES;
    }
    return NO;
}

@end
