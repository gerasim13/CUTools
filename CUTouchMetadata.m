//
//  CUTouchMetadata.m
//  Loopseque
//
//  Created by Paul Savich on 02.09.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CUTouchMetadata.h"


@implementation CUTouchMetadata

#pragma mark Lifecycle

+ (id)touchMetadata {
	return [[[CUTouchMetadata alloc] init] autorelease];
}

- (id)init {
	if ((self = [super init])) {
		metadata = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[metadata release];
	[super dealloc];
}


#pragma mark Metadata access

- (NSMutableDictionary*)dictionaryForTouch:(UITouch*)touch shouldCreate:(BOOL)shouldCreate {
	NSString *key = [NSString stringWithFormat:@"%p", touch];
	NSMutableDictionary *dic = [metadata objectForKey:key];
	if (dic == nil && shouldCreate) {
		dic = [NSMutableDictionary dictionary];
		[metadata setObject:dic forKey:key];
	}
	return dic;
}

- (void)setObject:(id)object forKey:(NSString*)key forTouch:(UITouch*)touch {
	NSMutableDictionary *dic = [self dictionaryForTouch:touch shouldCreate:YES];
	[dic setObject:object forKey:key];
}

- (id)objectForKey:(NSString*)key forTouch:(UITouch*)touch {
	NSMutableDictionary *dic = [self dictionaryForTouch:touch shouldCreate:NO];
	return [dic objectForKey:key];
}

- (void)setInteger:(NSInteger)i forKey:(NSString*)key forTouch:(UITouch*)touch {
	[self setObject:[NSNumber numberWithInteger:i] forKey:key forTouch:touch];
}

- (NSInteger)integerForKey:(NSString*)key forTouch:(UITouch*)touch {
	return [[self objectForKey:key forTouch:touch] integerValue];
}

- (void)setFloat:(float)f forKey:(NSString*)key forTouch:(UITouch*)touch {
	[self setObject:[NSNumber numberWithFloat:f] forKey:key forTouch:touch];
}

- (float)floatForKey:(NSString*)key forTouch:(UITouch*)touch {
	return [[self objectForKey:key forTouch:touch] floatValue];
}

- (void)setBool:(BOOL)b forKey:(NSString*)key forTouch:(UITouch*)touch {
	[self setObject:[NSNumber numberWithBool:b] forKey:key forTouch:touch];
}

- (BOOL)boolForKey:(NSString*)key forTouch:(UITouch*)touch {
	return [[self objectForKey:key forTouch:touch] boolValue];
}

- (void)removeMetadataForTouch:(UITouch*)touch {
	NSString *key = [NSString stringWithFormat:@"%p", touch];
	[metadata removeObjectForKey:key];
}

- (void)removeAllMetadata {
	[metadata removeAllObjects];
}


#pragma mark Checks

- (BOOL)hasObjectForKey:(NSString*)key forTouch:(UITouch*)touch {
	return [self objectForKey:key forTouch:touch] != nil;
}

- (BOOL)hasTouchWithObject:(id)object forKey:(NSString*)key {
	for (NSMutableDictionary *dic in metadata.allValues) {
		if ([[dic objectForKey:key] isEqual:object]) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)hasTouchWithInteger:(NSInteger)i forKey:(NSString*)key {
	return [self hasTouchWithObject:[NSNumber numberWithInteger:i] forKey:key];
}

- (BOOL)hasTouchWithBool:(BOOL)b forKey:(NSString*)key {
	return [self hasTouchWithObject:[NSNumber numberWithBool:b] forKey:key];
}


@end
