//
//  CUTouchMetadata.h
//  Loopseque
//
//  Created by Paul Savich on 02.09.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CUTouchMetadata : NSObject {
	NSMutableDictionary *metadata;
}

+ (id)touchMetadata;

- (void)setObject:(id)object forKey:(NSString*)key forTouch:(UITouch*)touch;
- (id)objectForKey:(NSString*)key forTouch:(UITouch*)touch;

- (void)setInteger:(NSInteger)i forKey:(NSString*)key forTouch:(UITouch*)touch;
- (NSInteger)integerForKey:(NSString*)key forTouch:(UITouch*)touch;

- (void)setFloat:(float)f forKey:(NSString*)key forTouch:(UITouch*)touch;
- (float)floatForKey:(NSString*)key forTouch:(UITouch*)touch;

- (void)setBool:(BOOL)b forKey:(NSString*)key forTouch:(UITouch*)touch;
- (BOOL)boolForKey:(NSString*)key forTouch:(UITouch*)touch;

- (void)removeMetadataForTouch:(UITouch*)touch;
- (void)removeAllMetadata;

- (BOOL)hasObjectForKey:(NSString*)key forTouch:(UITouch*)touch;
- (BOOL)hasTouchWithObject:(id)object forKey:(NSString*)key;
- (BOOL)hasTouchWithInteger:(NSInteger)i forKey:(NSString*)key;
- (BOOL)hasTouchWithBool:(BOOL)b forKey:(NSString*)key;

@end
