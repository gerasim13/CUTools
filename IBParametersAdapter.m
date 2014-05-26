//
//  IBParametersAdapter.m
//  Loovie
//
//  Created by Paul Savich on 11.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "IBParametersAdapter.h"


@implementation IBParametersAdapter


#pragma mark Lifecycle

- (void)awakeFromNib {
	[super awakeFromNib];
	
//	parameterViews = [[NSMutableDictionary alloc] init];
//	for (UIView *subview in self.subviews) {
//		if ([subview isKindOfClass:[IBParameterButton class]]) {
//			
//		}
//	}
}
			
- (void)dealloc {
	[parameterViews release];
	[super dealloc];
}


#pragma mark Public interface

// Internal method to get real UIViews behind parameters
- (UIView*)parameterForKey:(NSString*)key {
//	[parameterViews ];
	// TO-DO
	return nil;
}
   
- (IBParametersAdapter*)parametersForKey:(NSString*)key {
   	// TO-DO
	return nil;
}

- (NSString*)stringForKey:(NSString*)key {
	// TO-DO
	return nil;
}

- (CGFloat)floatForKey:(NSString*)key {
	// TO-DO
	return 0.0;
}

- (BOOL)boolForKey:(NSString*)name {
	// TO-DO
	return NO;
}

- (NSInteger)integerForKey:(NSString*)name {
	// TO-DO
	return 0;
}


@end
