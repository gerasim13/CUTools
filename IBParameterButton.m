//
//  IBParameterButton.m
//  Loovie
//
//  Created by Paul Savich on 11.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "IBParameterButton.h"


@implementation IBParameterButton

// Invisible method to parse label
- (void)parse {
	
}

- (NSString*)key {
	if (key == nil) { [self parse]; }
	return key;	
}

- (NSString*)stringValue {
	if (value == nil) { [self parse]; }
	return value;
}

- (CGFloat)floatValue {
	// TO-DO
	return 0.0;
}

- (BOOL)boolValue {
	// TO-DO
	return NO;
}

- (NSInteger)integerValue {
	// TO-DO
	return 0;
}


@end
