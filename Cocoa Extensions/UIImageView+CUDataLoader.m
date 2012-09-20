//
//  UIImageView+ImageLoader.m
//  MolodejjTV
//
//  Created by Павел Литвиненко on 12.04.11.
//  Copyright 2011 CULab. All rights reserved.
//
#import "UIImageView+CUDataLoader.h"
#import "CUDataLoader.h"

@implementation UIImageView (CUDataLoader)

- (void)setImageWithURL:(NSString*)imageURL {
	self.image = nil;
	[CUDataLoader loadDataFromURL:imageURL delegate:self];
}

- (void)dataLoaded:(CUDataLoader*)dataLoader {
	self.image = [dataLoader responseImage];
}

@end
