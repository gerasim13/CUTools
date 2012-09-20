//
//  CUActionSheet.m
//  Loovie
//
//  Created by Павел Литвиненко on 21.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUActionSheet.h"

@implementation CUActionSheet
@synthesize actions, objects;

- (id)init {
	if (self=[super init]) {
		int maxButtonNum = 14;
		[self setActions:[[NSMutableArray alloc] initWithCapacity:maxButtonNum]];
		[self setObjects:[[NSMutableArray alloc] initWithCapacity:maxButtonNum]];
		
		for(int i = 0; i < maxButtonNum; i++) {
			[actions addObject: [NSNull null]];
			[objects addObject: [NSNull null]];
		}
	}
	return self;
}

- (void)dealloc {
	[actions release];
	[objects release];
	[super dealloc];
}

- (NSInteger)addButtonWithTitle:(NSString*)title andAction:(SEL)action {
	NSInteger index = [self addButtonWithTitle:title];
	[actions insertObject:NSStringFromSelector(action) atIndex:index];
	return index;
}

- (NSInteger)addButtonWithTitle:(NSString*)title action:(SEL)action andObject:(NSObject*)object {
	NSInteger index = [self addButtonWithTitle:title andAction:action];
	[objects insertObject:object atIndex:index];
	return index;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	if (buttonIndex!=[self cancelButtonIndex]) {
		if ([actions objectAtIndex:buttonIndex]!=[NSNull null]) {
			id target  = [self delegate];
			SEL action = NSSelectorFromString([actions objectAtIndex:buttonIndex]);
			if ([target respondsToSelector:action]) {
				if ([objects objectAtIndex:buttonIndex]!=[NSNull null]) {
					[target performSelector:action withObject:[objects objectAtIndex:buttonIndex]];
				} else {
					[target performSelector:action];
				}
			}
		}
	}
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

@end
