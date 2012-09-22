//
//  NSSet+NSUserDefaults.m
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 23.09.12.
//
//

#import "NSSet+Archive.h"

@implementation NSSet (Archive)

- (BOOL)containsKeyedObject:(NSObject*)object
{
    for (NSObject *_object in self) {
        if ([object isEqual:_object]) {
            return YES;
        }
    }
    return NO;
}

- (void)addObject:(NSObject*)object toSetWithIdentifier:(NSString*)identifier
{
    NSSet        *set    = [NSSet unarchiverSetWithIdentifier:identifier];
    NSMutableSet *mutSet = [NSMutableSet setWithSet:set];
    // Search for duplicete of movie
    if (![self containsKeyedObject:object]) {
        // Add movie
        [mutSet addObject:object];
        [mutSet archiveWithIdentifier:identifier];
    }
}

- (void)archiveWithIdentifier:(NSString*)identifier
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:identifier];
}

+ (NSSet*)unarchiverSetWithIdentifier:(NSString*)identifier
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

@end
