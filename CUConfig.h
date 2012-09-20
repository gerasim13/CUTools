//
//  CUConfig.h
//  CUTools
//
//  Created by Paul Savich on 12.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define MEASURE_START(name) NSTimeInterval name = [NSDate timeIntervalSinceReferenceDate];
#define MEASURE_FINISH(name) NSLog(@"Measured time: %f", [NSDate timeIntervalSinceReferenceDate]-name);

@interface CUConfig : NSObject {
	NSDictionary* configData;
}

// Singleton access
+ (CUConfig*)sharedConfig;
+ (NSObject*)valueForKey:(NSString*)key;
+ (NSDictionary*)dictionaryForKey:(NSString*)key;
+ (NSString*)stringForKey:(NSString*)key;
+ (NSInteger)integerForKey:(NSString*)key;
+ (float)floatForKey:(NSString*)key;

// Parsing
+ (CGRect)parseRect:(NSString*)string;
+ (UIEdgeInsets)parseEdgeInsets:(NSString*)string;
+ (CGSize)parseSize:(NSString*)string;
+ (CGPoint)parsePoint:(NSString*)string;

// Paths
+ (NSString*)applicationDocumentsDirectory;
+ (NSString*)defaultProjectPath;
+ (NSString*)moviesPath;

// Device
+ (NSString*)deviceModel;
+ (NSString*)deviceString;
+ (NSInteger)deviceMemoryInMegabytes;
+ (BOOL)deviceModelIs3GSOrEarlier;
+ (NSInteger)integerForKeyWithMemorySuffix:(NSString*)key;

// Other
+ (UIViewController*)rootViewController;

@end
