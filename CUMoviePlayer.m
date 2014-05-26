//
//  CUMoviePlayer.m
//  Loovie
//
//  Created by Павел Литвиненко on 15.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUMoviePlayer.h"

@interface CUMoviePlayer(private)
- (void)setScalingModeToAspectFill;
@end


@implementation CUMoviePlayer

+ (CUMoviePlayer*)moviePlayer {
	SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] init];
	});
}

- (id)init {
	if (self=[super init]) {
		[self setup];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)setup {
	[self setShouldAutoplay:NO];
	[self setScalingModeToAspectFill];
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self.backgroundView setBackgroundColor:[UIColor clearColor]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(pause)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(prepareToPlay)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setScalingModeToAspectFill)
												 name:MPMoviePlayerDidExitFullscreenNotification
											   object:self];
}

- (void)setContentURL:(NSURL*)contentURL {	
	[super setContentURL:contentURL];
	[self prepareToPlay];
}

- (void)setScalingModeToAspectFill {
	[self setScalingMode:MPMovieScalingModeAspectFill];
	[self.view setClipsToBounds:YES];
}

@end