//
//  CUMoviePlayer.h
//  Loovie
//
//  Created by Павел Литвиненко on 15.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LoovieConfig.h"

@interface CUMoviePlayer : MPMoviePlayerController {
	
}

+ (CUMoviePlayer*)moviePlayer;
- (void)setup;

@end
