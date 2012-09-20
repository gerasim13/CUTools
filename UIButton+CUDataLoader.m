//
//  UIButton+CUDataLoader.m
//  Loopseque
//
//  Created by Paul Savich on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIButton+CUDataLoader.h"

@implementation UIButton (CUDataLoader)

- (void)setImageWithURL:(NSString*)imageURL {
	[self setImage:nil forState:UIControlStateNormal];
	[CUDataLoader loadDataFromURL:imageURL delegate:self];
}

- (void)dataLoaded:(CUDataLoader*)dataLoader {
	UIImage *image = [dataLoader responseImage];
	[self setImage:image forState:UIControlStateNormal];
}

@end
