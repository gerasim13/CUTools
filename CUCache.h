//
//  CICache.h
//  Loovie
//
//  Created by Paul Savich on 19.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUCacheItem : NSObject {
	id key;
	id object;
	CUCacheItem *nextItem;
	CUCacheItem *prevItem;
}
@property (nonatomic, retain) id key;
@property (nonatomic, retain) id object;
@property (nonatomic, assign) CUCacheItem *nextItem;
@property (nonatomic, assign) CUCacheItem *prevItem;

- (void)extract;

@end

//-------------------------------------------------------------

@interface CUCache : NSObject {
	NSUInteger size;
	NSMutableArray *allCacheItems;
	NSMutableDictionary *cache;
	CUCacheItem *headItem;
}

- (id)initWithSize:(NSUInteger)size;
- (id)objectForKey:(id)key;
- (void)setObject:(id)value forKey:(id)key;
- (void)clear;

@end
