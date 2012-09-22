//
//  NSString+HexValue.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 02.03.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "NSString+HexValue.h"

@implementation NSString (HexValue)
- (int)hexValue {
	int n = 0;
	sscanf([self UTF8String], "%x", &n);
	return n;
}
@end
