//
//  CUConfig.m
//  CUTools
//
//  Created by Paul Savich on 12.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#include <sys/types.h>
#include <sys/sysctl.h>
#import "CUConfig.h"


@implementation CUConfig


#pragma mark Lifecycle

- (void)setup {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Config.plist" ofType:nil];
	configData = [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (id)init {
	if ((self = [super init])) {
		[self setup];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self setup];
}

- (void)dealloc {
	[configData release];
	[super dealloc];
}


#pragma mark Key-Value access

- (NSObject*)valueForKey:(NSString*)key {
	return [configData objectForKey:key];
}

- (NSDictionary*)dictionaryForKey:(NSString*)key {
	NSObject *value = [configData objectForKey:key];
	if ([value isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary*)value;
	}
	else {
		NSLog(@"Failed to read dictionary config key: %@", key);
		return 0;
	}
}

- (NSString*)stringForKey:(NSString*)key {
	NSObject *value = [configData objectForKey:key];
	if ([value isKindOfClass:[NSString class]]) {
		return (NSString*)value;
	}
	else {
		NSLog(@"Failed to read string config key: %@", key);
		return 0;
	}
}

- (NSInteger)integerForKey:(NSString*)key {
	NSObject *value = [configData objectForKey:key];
	if ([value isKindOfClass:[NSNumber class]]) {
		return [(NSNumber*)value integerValue];
	}
	else {
		NSLog(@"Failed to read integer config key: %@", key);
		return 0;
	}
}

- (float)floatForKey:(NSString*)key {
	NSObject *value = [configData objectForKey:key];
	if ([value isKindOfClass:[NSNumber class]]) {
		return [(NSNumber*)value floatValue];
	}
	else {
		NSLog(@"Failed to read float config key: %@", key);
		return 0.0;
	}
}


#pragma mark Other

- (UIViewController*)rootViewController {
	id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	return [appDelegate performSelector:@selector(viewController)];
}


#pragma mark Singleton access

+ (CUConfig*)sharedConfig {
	SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] init];
	});
}

+ (NSObject*)valueForKey:(NSString*)key {
	return [[CUConfig sharedConfig] valueForKey:key];
}

+ (NSDictionary*)dictionaryForKey:(NSString*)key {
	return [[CUConfig sharedConfig] dictionaryForKey:key];
}

+ (NSString*)stringForKey:(NSString*)key {
	return [[CUConfig sharedConfig] stringForKey:key];
}

+ (NSInteger)integerForKey:(NSString*)key {
	return [[CUConfig sharedConfig] integerForKey:key];
}

+ (float)floatForKey:(NSString*)key {
	return [[CUConfig sharedConfig] floatForKey:key];
}


#pragma mark Parsing

+ (CGRect)parseRect:(NSString*)string {
	NSArray *numbers = [string componentsSeparatedByString:@","];
	if (numbers.count != 4) { return CGRectMake(0, 0, 0, 0); }
	return CGRectMake([[numbers objectAtIndex:0] floatValue],
					  [[numbers objectAtIndex:1] floatValue],
					  [[numbers objectAtIndex:2] floatValue],
					  [[numbers objectAtIndex:3] floatValue]);
}

+ (UIEdgeInsets)parseEdgeInsets:(NSString*)string {
	NSArray *numbers = [string componentsSeparatedByString:@","];
	if (numbers.count != 4) { return UIEdgeInsetsMake(0, 0, 0, 0); }
	// Note: UIEdgeInsetsMake takes (top, left, bottom, right),
	// but we want (left, top, right, bottom)
	return UIEdgeInsetsMake([[numbers objectAtIndex:1] floatValue],
							[[numbers objectAtIndex:0] floatValue],
							[[numbers objectAtIndex:3] floatValue],
							[[numbers objectAtIndex:2] floatValue]);
}

+ (CGSize)parseSize:(NSString*)string {
	NSArray *numbers = [string componentsSeparatedByString:@","];
	if (numbers.count != 2) { return CGSizeMake(0, 0); }
	return CGSizeMake([[numbers objectAtIndex:0] floatValue],
					  [[numbers objectAtIndex:1] floatValue]);
}

+ (CGPoint)parsePoint:(NSString*)string {
	NSArray *numbers = [string componentsSeparatedByString:@","];
	if (numbers.count != 2) { return CGPointMake(0, 0); }
	return CGPointMake([[numbers objectAtIndex:0] floatValue],
					   [[numbers objectAtIndex:1] floatValue]);
}


#pragma mark Paths

+ (NSString*)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString*)defaultProjectPath {
	NSString *projectName = [CUConfig stringForKey:@"DefaultProjectName"];
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:projectName];
}

+ (NSString*)moviesPath {
	NSString *moviesDir = [CUConfig stringForKey:@"MoviesDirName"];
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:moviesDir];
}


#pragma mark Device

+ (NSString*)deviceModel {
    char buffer[32];
    size_t length = sizeof(buffer);
    if (sysctlbyname("hw.machine", &buffer, &length, NULL, 0) == 0) {
        return [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    }
    else {
		return nil;
	}
}

+ (NSString*)deviceString {
    NSString *model = [self deviceModel];
    if ([model isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([model isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([model isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([model isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([model isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([model isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([model isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([model isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([model isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([model isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([model isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([model isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([model isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([model isEqualToString:@"i386"])         return @"Simulator";
    return model;
}

+ (NSInteger)deviceMemoryInMegabytes {
	NSString *model = [self deviceModel];
	// iPhone 4 (model=iPhone3,*) and later, iPad 2 and later
	if ([model hasPrefix:@"iPhone3"] || [model hasPrefix:@"iPhone4"] || [model hasPrefix:@"iPhone5"] ||
		[model hasPrefix:@"iPad2"] || [model hasPrefix:@"iPad3"] || [model hasPrefix:@"iPad4"]) {
		return 512;
	}
	else {
		return 256;
	}
}

+ (BOOL)deviceModelIs3GSOrEarlier {
	NSString *model = [self deviceModel];
	return ([model hasPrefix:@"iPhone1"] || [model hasPrefix:@"iPhone2"] || 
			[model hasPrefix:@"iPod1"] || [model hasPrefix:@"iPod2"] || [model hasPrefix:@"iPod3"]);
}

+ (NSInteger)integerForKeyWithMemorySuffix:(NSString*)key {
	if ([self deviceMemoryInMegabytes] >= 512) {
		return [self integerForKey:[key stringByAppendingString:@"512"]];
	}
	else {
		return [self integerForKey:[key stringByAppendingString:@"256"]];
	}
}


#pragma mark Other

+ (UIViewController*)rootViewController {
	id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
	return [appDelegate performSelector:@selector(viewController)];
}


@end
