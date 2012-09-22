//
//  NSDictionary+NSData.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "NSDictionary+NSData.h"

@implementation NSDictionary (NSData)

+ (NSDictionary*)dictionaryWithContentsOfData:(NSData*)data {
	// uses toll-free bridging for data into CFDataRef and CFPropertyList into NSDictionary
	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListImmutable, NULL);
	// we check if it is the correct type and only return it if it is
	if ([(id)plist isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)plist autorelease];
    } else {
        // clean up ref
        if (plist!=nil) {
            CFRelease(plist);
        }
    }
    return nil;
}

@end
