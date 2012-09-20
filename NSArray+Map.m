//
//  NSArray+Map.m
//  Loovie
//
//  Created by Paul Savich on 19.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "NSArray+Map.h"


@implementation NSArray (Map)

#pragma mark Create

+ (NSArray*)arrayWithObjectsCount:(NSInteger)count usingBlock:(id (^)(NSInteger index))block {
    // Create empty array
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    // Call block to create and add objects
    for (NSInteger index = 0; index < count; index++) {
        id result = block(index);
        if (result != nil) {
            [array addObject:result];
        }
    }
	// Return immutable copy of created array
	return array;
}

- (NSArray*)expandToCount:(NSInteger)count withIndexSelector:(SEL)indexSelector usingBlock:(id (^)(NSInteger index))block {
    // Create empty array
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    // Iterate through array
    for (id object in self) {
        // Current object index
        NSInteger index = (NSInteger)[object performSelector:indexSelector];
        // Fill gap
        while (array.count < index) { [array addObject:block(array.count)]; }
        // Add object
        if (array.count != index) { @throw [NSException exceptionWithName:@"InvalidIndexException" reason:@"Index order should be strictly ascending" userInfo:nil]; }
        [array addObject:object];
    }
    // Fill gap
    while (array.count < count) { [array addObject:block(array.count)]; }
    return array;
}



#pragma mark Map

- (NSArray*)mapObjectsUsingSelector:(SEL)aSelector {
	return [self mapObjectsUsingSelector:aSelector withObject:nil];
}

- (NSArray*)mapObjectsUsingSelector:(SEL)aSelector withObject:(id)anObject {
	// Create empty array
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	// Enumerate objects in current array and add results to a new array
	for (id object in self) {
		id result = [object performSelector:aSelector withObject:anObject];
		if (result != nil) {
			[array addObject:result];
		}
	}
	// Return immutable copy of created array
	return array;
}

- (NSArray*)mapObjectsUsingBlock:(id (^)(id object))block {
	// Create empty array
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	// Enumerate objects in current array and add results to a new array
	for (id object in self) {
		id result = block(object);
		if (result != nil) {
			[array addObject:result];
		}
	}
	// Return immutable copy of created array
	return array;
}

- (NSArray*)mapObjectsWithIndicesUsingBlock:(id (^)(id object, NSInteger index))block {
	// Create empty array
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	// Enumerate objects in current array and add results to a new array
	for (NSInteger index = 0; index < self.count; index++) {
        id object = [self objectAtIndex:index];
		id result = block(object, index);
		if (result != nil) {
			[array addObject:result];
		}
	}
	// Return immutable copy of created array
	return array;
}


#pragma mark All

- (BOOL)allObjectsReturnYesForSelector:(SEL)aSelector {
	return [self allObjectsReturnYesForSelector:aSelector withObject:nil];
}

- (BOOL)allObjectsReturnYesForSelector:(SEL)aSelector withObject:(id)anObject {
	for (id object in self) {
		if (![object performSelector:aSelector withObject:anObject]) {
			return NO;
		}
	}
	return YES;
}


#pragma mark All

- (BOOL)hasObjectReturningYesForSelector:(SEL)aSelector {
	return [self hasObjectReturningYesForSelector:aSelector withObject:nil];
}

- (BOOL)hasObjectReturningYesForSelector:(SEL)aSelector withObject:(id)anObject {
	for (id object in self) {
		if ([object performSelector:aSelector withObject:anObject]) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)hasObjectReturningObject:(id)anObject forSelector:(SEL)aSelector {
	for (id object in self) {
		if ([anObject isEqual:[object performSelector:aSelector]]) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)hasObjectReturningObject:(id)anObject forSelector:(SEL)aSelector withObject:(id)anotherObject {
	for (id object in self) {
		if ([anObject isEqual:[object performSelector:aSelector withObject:anotherObject]]) {
			return YES;
		}
	}
	return NO;
}

#pragma mark Remove

- (NSArray*)arrayByRemovingObjectAtIndex:(NSUInteger)index {
    
}


@end
