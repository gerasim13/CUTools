//
//  UIImage+ImageCache.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 29.11.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "UIImageView+CUImageCache.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "CUImageCache.h"

@implementation UIImageView (CUImageCache)

- (void)setImageWithURL:(NSString*)imageURL {
    [self setImageWithURL:imageURL placeholderImage:nil];
}

- (void)setImageWithURL:(NSString*)imageURL placeholderImage:(UIImage*)placeholderImage {
    self.image = [placeholderImage roundedCornerImage:30 borderSize:2];
    [CUImageCache loadImageFromURL:imageURL delegate:self];
}

- (void)imageCachedSuccessfully:(UIImage*)image {
    [self setImage:[image roundedCornerImage:30 borderSize:2]];
}

@end