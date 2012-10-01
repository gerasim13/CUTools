//
//  CUImageCache.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 29.11.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUImageCache.h"

#define CacheDir NSTemporaryDirectory()

@interface CUImageCache(private)
- (NSString*)cachedImagePath:(NSString*)imageName;
- (BOOL)isFilenameAssociatedWithType:(NSString*)type;
@end

@implementation CUImageCache
@synthesize delegate;

+ (void)loadImageFromURL:(NSString*)url delegate:(id<CUImageCacheDelegate>)delegate {
    CUImageCache *imageCache = [[[CUImageCache alloc] init] autorelease];
    [imageCache setDelegate:delegate];
    [imageCache addImageToCache:url];
}

- (void)dealloc {
    [imageFilename release], imageFilename = nil;
    [super dealloc];
}

- (void)addImageToCache:(NSString*)imageURLString {
    imageFilename  = [[imageURLString lastPathComponent] retain];
    NSString *imageCachePath = [self cachedImagePath:imageFilename];
    
    //check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageCachePath]) {
        [CUDataLoader loadDataFromURL:imageURLString delegate:self];
    } else {
        [delegate imageCachedSuccessfully:[self getImageFromCache:imageFilename]];
    }
}

- (UIImage*)getImageFromCache:(NSString*)imageName {
    NSString *imageCachePath = [self cachedImagePath:imageFilename];
    return [UIImage imageWithContentsOfFile:imageCachePath];
}

- (NSString*)cachedImagePath:(NSString*)imageName {
    return [CacheDir stringByAppendingPathComponent:imageName];
}

- (BOOL)isFilenameAssociatedWithType:(NSString*)type {
    return ([imageFilename rangeOfString:type options:NSCaseInsensitiveSearch].location != NSNotFound);
}

#pragma mark CUDataLoader delegate

- (void)dataLoaded:(CUDataLoader*)dataLoader {
    UIImage *image           = [dataLoader responseImage];
    NSString *imageCachePath = [self cachedImagePath:imageFilename];
    
    //check filetype and save image to cache
    if([self isFilenameAssociatedWithType:@".png"]) {
        [UIImagePNGRepresentation(image) writeToFile:imageCachePath atomically: YES];
    } else if([self isFilenameAssociatedWithType:@".jpg"] || [self isFilenameAssociatedWithType:@".jpeg"]) {
        [UIImageJPEGRepresentation(image, 100) writeToFile:imageCachePath atomically: YES];
    } else {
        return;
    }
    
    [delegate imageCachedSuccessfully:image];
}

@end
