//
//  UIImage+ImageCache.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 29.11.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CUImageCache.h"

@interface UIImageView (CUImageCache) <CUImageCacheDelegate>
- (void)setImageWithURL:(NSString*)imageURL;
- (void)setImageWithURL:(NSString*)imageURL placeholderImage:(UIImage*)placeholderImage;
@end