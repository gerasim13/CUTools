//
//  CUModeController.m
//  Loovie
//
//  Created by Paul Savich on 11.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUModeController.h"


@implementation CUModeController

@synthesize delegate;
@synthesize currentMode;
@synthesize animated;
@synthesize animationDuration;
@synthesize useDelegateForModeChanges;


#pragma mark Lifecycle

- (void)setup {
	// Setting default values
	animated = YES;
	animationDuration = 0.4;
	useDelegateForModeChanges = YES;
	previousModes = [[NSMutableArray alloc] init];
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
	[previousModes release];
	[currentMode release];
	[super dealloc];
}


#pragma mark Notification

- (BOOL)canSwitchFromMode:(NSString*)oldMode toMode:(NSString*)newMode {
	// Ask delegate or allow switching by default
	if (useDelegateForModeChanges && [delegate respondsToSelector:@selector(canSwitchFromMode:toMode:)]) {
		return [delegate canSwitchFromMode:oldMode toMode:newMode];
	}
	else {
		return YES;
	}
}

- (void)willEnterMode:(NSString*)newMode animated:(BOOL)_animated {
	// Notify delegate
	if (useDelegateForModeChanges && [delegate respondsToSelector:@selector(willEnterMode:animated:)]) {
		[delegate willEnterMode:newMode animated:_animated];
	}
}

- (void)didLeaveMode:(NSString*)oldMode animated:(BOOL)_animated {
	// Notify delegate
	if (useDelegateForModeChanges && [delegate respondsToSelector:@selector(didLeaveMode:animated:)]) {
		[delegate didLeaveMode:oldMode animated:_animated];
	}
}

- (void)failedToSwitchFromMode:(NSString*)oldMode toMode:(NSString*)wantedMode {
	// Notify delegate
	if (useDelegateForModeChanges && [delegate respondsToSelector:@selector(failedToSwitchFromMode:toMode:)]) {
		[delegate failedToSwitchFromMode:oldMode toMode:wantedMode];
	}
}


#pragma mark Mode set

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self didLeaveMode:[(NSString*)context autorelease] animated:YES];
}
	 
- (BOOL)setCurrentMode:(NSString*)newMode animated:(BOOL)_animated {
	// Don't change to the same mode - but return YES,
	// because action is successful
	if (currentMode == newMode) { return YES; }
	if ([currentMode isEqualToString:newMode]) { return YES; }
	
	// Check if we can change mode from delegate
	if (![self canSwitchFromMode:currentMode toMode:newMode]) {
		[self failedToSwitchFromMode:currentMode toMode:newMode];
		return NO;
	}

	// Animation begin
	if (_animated) {
		[UIView beginAnimations:nil context:[currentMode retain]];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		if (animationDuration != 0.0) {
			[UIView setAnimationDuration:animationDuration];
		}
	}
	[self willEnterMode:newMode animated:_animated];
	
	// Mode change
	NSString *previousMode = currentMode;
	currentMode = [newMode retain];

	// Animation commit & (possibly delegate notification
	if (_animated) {
		[UIView commitAnimations];
	}
	else {
		[self didLeaveMode:previousMode animated:_animated];
	}

	// Done
	[previousMode release];
	return YES;
}

- (void)setCurrentMode:(NSString*)mode {
	[self setCurrentMode:mode animated:animated];
}

#pragma mark Mode queueing

- (void)pushMode:(NSString*)mode animated:(BOOL)_animated {
	[previousModes addObject:(currentMode ? currentMode : (NSObject*)[NSNull null])];
	[self setCurrentMode:mode animated:_animated];
}

- (void)pushMode:(NSString*)mode {
	[self pushMode:mode animated:animated];
}

- (void)popMode {
	NSString *mode = nil;
	if (previousModes.count > 0) {
		mode = [previousModes lastObject];
		[previousModes removeLastObject];
	}
	[self setCurrentMode:(mode != (NSObject*)[NSNull null] ? mode : nil)];
}

- (void)pushMode:(NSString*)mode orMode:(NSString*)mode2 {
	if (mode == currentMode || [mode isEqual:currentMode]) {
		[self pushMode:mode2];
	}
	else {
		[self pushMode:mode];
	}
}

- (void)pushOrPopMode:(NSString*)mode {
	if (mode == currentMode || [mode isEqual:currentMode]) {
		[self popMode];
	}
	else {
		[self pushMode:mode];
	}
}

//- (void)switchMode:(NSString*)mode {
//	// Same mode => switch current and previous (if any)
//	if (mode == currentMode || [mode isEqual:currentMode]) {
//		if (previousModes.count > 0) {
//			[self popMode];
//			[previousModes addObject:(mode ? mode : (NSObject*)[NSNull null])];
//		}
//	}
//	// Update previous modes
//	else {
//		if (previousModes.count > 0) {
//			[previousModes removeAllObjects];
//		}
//		[self pushMode:mode];
//	}
//}

@end
