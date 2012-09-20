//
//  NSArray+Map.h
//  Loovie
//
//  Created by Paul Savich on 19.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Map)

// Create
+ (NSArray*)arrayWithObjectsCount:(NSInteger)count usingBlock:(id (^)(NSInteger index))block;
- (NSArray*)expandToCount:(NSInteger)count withIndexSelector:(SEL)indexSelector usingBlock:(id (^)(NSInteger index))block;

// Map
- (NSArray*)mapObjectsUsingSelector:(SEL)aSelector;
- (NSArray*)mapObjectsUsingSelector:(SEL)aSelector withObject:(id)anObject;
- (NSArray*)mapObjectsUsingBlock:(id (^)(id object))block;
- (NSArray*)mapObjectsWithIndicesUsingBlock:(id (^)(id object, NSInteger index))block;

// All
- (BOOL)allObjectsReturnYesForSelector:(SEL)aSelector;
- (BOOL)allObjectsReturnYesForSelector:(SEL)aSelector withObject:(id)anObject;

// Any
- (BOOL)hasObjectReturningYesForSelector:(SEL)aSelector;
- (BOOL)hasObjectReturningYesForSelector:(SEL)aSelector withObject:(id)anObject;
- (BOOL)hasObjectReturningObject:(id)anObject forSelector:(SEL)aSelector;
- (BOOL)hasObjectReturningObject:(id)anObject forSelector:(SEL)aSelector withObject:(id)anotherObject;

// Remove
- (NSArray*)arrayByRemovingObjectAtIndex:(NSUInteger)index;

@end
