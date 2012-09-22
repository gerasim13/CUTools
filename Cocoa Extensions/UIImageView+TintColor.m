//
//  UIImageView+TintColor.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 11.06.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageView+TintColor.h"
#import "UIImage+TintColor.h"

static char const * const originalImageKey = "OriginalImage";

@implementation UIImageView (TintColor)
@dynamic originalImage;

- (UIImage*)originalImage {
    return objc_getAssociatedObject(self, originalImageKey);
}

- (void)setOriginalImage:(UIImage*)image {
    objc_setAssociatedObject(self, originalImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dealloc {
    self.originalImage = nil;
    [super dealloc];
}

- (void)setTintColor:(UIColor*)tintColor {
    if (tintColor == [UIColor clearColor] || tintColor == nil) {
        // Set original image
        [self setImage:self.originalImage];
    } else {
        // Save original image
        self.originalImage = self.image;
        // Set image
        [self setImage:[self.image imageWithTint:tintColor]];
    }
}

@end
