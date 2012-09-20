//
//  CUImageView.m
//  Loopseque
//
//  Created by Paul Savich on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CUImageView.h"


@implementation CUImageView

@synthesize tile;
@synthesize image;

- (void)dealloc {
	self.image = nil;
	[super dealloc];
}

- (void)setTile:(BOOL)_tile {
	tile = _tile;
	[self setNeedsDisplay];
}

- (void)setImage:(UIImage*)_image {
	[image release];
	image = [_image retain];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	if (!image) { return; }
	
//    if (!tile) {
//	}

	CGSize       frameSize = self.frame.size;
	CGSize       imageSize = image.size;
	
	for (CGFloat x = 0.0; x < frameSize.width; x += imageSize.width) {
		for (CGFloat y = 0.0; y < frameSize.height; y += imageSize.height) {
			CGRect r = CGRectMake(x, y, imageSize.width, imageSize.height);
			if (CGRectIntersectsRect(rect, r)) {
				[image drawInRect:r];
			}
		}
	}
}

@end
