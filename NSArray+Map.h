//
//  NSArray+Map.h
//  Loovie
//
//  Created by Paul Savich on 19.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (Map)

// Map
- (NSArray*)mapObjectsUsingSelector:(SEL)aSelector;
- (NSArray*)mapObjectsUsingSelector:(SEL)aSelector withObject:(id)anObject;
- (NSArray*)mapObjectsUsingBlock:(id (^)(id object))block;

// All
- (BOOL)allObjectsReturnYesForSelector:(SEL)aSelector;
- (BOOL)allObjectsReturnYesForSelector:(SEL)aSelector withObject:(id)anObject;

// Any
- (BOOL)hasObjectReturningYesForSelector:(SEL)aSelector;
- (BOOL)hasObjectReturningYesForSelector:(SEL)aSelector withObject:(id)anObject;

@end
