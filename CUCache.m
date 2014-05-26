//
//  Cache.m
//  Loovie
//
//  Created by Paul Savich on 19.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUCache.h"

#pragma mark Cache Log Functions


@implementation CUCacheItem

@synthesize key;
@synthesize object;
@synthesize nextItem;
@synthesize prevItem;

- (id)init {
	if ((self = [super init])) {
		nextItem = self;
		prevItem = self;
	}
	return self;
}

- (void)dealloc {
	[key release];
	[object release];
	[super dealloc];
}

- (void)extract {
	// Link others
	nextItem->prevItem = prevItem;
	prevItem->nextItem = nextItem;
	// Link myself
	nextItem = self;
	prevItem = self;
}

- (void)setNextItem:(CUCacheItem*)_nextItem {
	// Extract next item
	[_nextItem extract];
	// Link _nextImer
	_nextItem->nextItem = nextItem;
	_nextItem->prevItem = self;
	// Link others
	nextItem->prevItem = _nextItem;
	nextItem = _nextItem;
}

- (void)setPrevItem:(CUCacheItem*)_prevItem {
	// Extract next item
	[_prevItem extract];
	// Link _prevItem
	_prevItem->prevItem = prevItem;
	_prevItem->nextItem = self;
	// Link others
	prevItem->nextItem = _prevItem;
	prevItem = _prevItem;
}


@end


@implementation CUCache

- (id)initWithSize:(NSUInteger)_size {
	if ((self = [super init])) {
		// Create cache
		size = _size;
		cache = [[NSMutableDictionary alloc] init];
		
		// Create items
		allCacheItems = [[NSMutableArray alloc] initWithCapacity:size];
		headItem = [[[CUCacheItem alloc] init] autorelease];
		[allCacheItems addObject:headItem];
		for (NSInteger i = 1; i < size; i++) {
			CUCacheItem *nextItem = [[[CUCacheItem alloc] init] autorelease];
			headItem.prevItem = nextItem;
			[allCacheItems addObject:nextItem];
		}
	}
	return self;
}

- (void)dealloc {
	[allCacheItems release];
	[cache release];
	[super dealloc];
}

- (id)objectForKey:(id)key {
	// Cache item
	CUCacheItem *item = [cache objectForKey:key];
	
	// Check
	if (item == nil) {
		return nil;
	}
	
	// Move
	headItem.nextItem = item;
	
	// Done
	return item.object;
}

- (void)setObject:(id)object forKey:(id)key {
	// Cache item
	CUCacheItem *item = headItem.prevItem;

	// Removing old key (if any)
	if (item.key != nil) {
		[cache removeObjectForKey:item.key];
	}
	
	// Set cache value
	// (Don't check existing key - if there was another item with the same key, it will soon move to the tail)
	[cache setObject:item forKey:key];

	// Update
	item.key = key;
	item.object = object;
	
	// Move
	headItem.nextItem = item;
}

- (void)clear {
	// Clear cache items
	for (CUCacheItem *item in allCacheItems) {
		item.key = nil;
		item.object = nil;
	}
	// Clear cache
	[cache removeAllObjects];
}

@end
