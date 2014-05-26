//
//  NSArray+Map.m
//  Loovie
//
//  Created by Paul Savich on 19.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "NSArray+Map.h"


@implementation NSArray (Map)

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
	return [NSArray arrayWithArray:array];
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
	return [NSArray arrayWithArray:array];
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



@end
