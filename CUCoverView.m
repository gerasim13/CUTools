//
//  CUCoverView.m
//  Loopseque
//
//  Created by Павел Литвиненко on 30.06.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUCoverView.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImageView+CUImageCache.h"

@implementation CUCoverView
@synthesize imageView;
@synthesize identifier;

#pragma mark Lifecycle
- (id)initWithNib:(NSString*)nib frame:(CGRect)frame {
    if ((self=[super initWithFrame:frame])) {
        
	}
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Set cover image
- (UIImage*)image {
	return imageView.image;
}

- (void)setImage:(UIImage*)img {
    int cornerRadius = 30;
    int borderSize   = 2;
#ifdef TARGET_MINI
    cornerRadius = 15;
    borderSize   = 1;
#endif
    UIImage *roundedImage = [img roundedCornerImage:cornerRadius borderSize:borderSize];
	[imageView setImage:roundedImage];
    
    [self addReflectionAndBorders];
}

- (void)setImageWithURL:(NSString*)imageURL {
    [imageView setImageWithURL:imageURL];
    
    [self addReflectionAndBorders];
}

- (void)addReflectionAndBorders {
    //	CGFloat w = frontView.frame.size.width;
    //	CGFloat h = frontView.frame.size.height;
    //    CGFloat y = frontView.frame.origin.y;
    //	
    //    //3.2 workaround
    //    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    //    if (version >= 4.0) {
    //        //create gradient mask
    //        CAGradientLayer *gradientMask = [CAGradientLayer layer];
    //        NSArray *gradientColors = [NSArray arrayWithObjects:
    //                                   (id)[UIColor colorWithWhite:0 alpha:0.18].CGColor,
    //                                   (id)[UIColor clearColor].CGColor,
    //                                   nil];
    //        [gradientMask setColors:gradientColors];
    //        [gradientMask setStartPoint:CGPointMake(0,0)];
    //        [gradientMask setEndPoint:CGPointMake(0,0.085)];
    //        [gradientMask setFrame:CGRectMake(0, 0, w, h)];
    //        
    //        //create flipped image from rounded image
    //        UIImage *reflectedImage = [UIImage imageWithCGImage:roundedImage.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
    //        
    //        //create reflected image by adding gradient mask to flipped image
    //        reflected = [[[UIImageView alloc] initWithImage:reflectedImage] autorelease];
    //        [reflected setFrame:CGRectMake(0, y + h, w, h)];
    //        [reflected.layer setMask:gradientMask];
    //        
    //        [self insertSubview:reflected belowSubview:frontView];
    //    }
    
    //disable user interation for image and reflected image views
    [imageView setUserInteractionEnabled:NO];
    [reflected setUserInteractionEnabled:NO];
}

@end