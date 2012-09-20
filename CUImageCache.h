//
//  CUImageCache.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 29.11.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUDataLoader.h"

@class CUImageCache;

@protocol CUImageCacheDelegate <NSObject>
@optional
- (void)imageCachedSuccessfully:(UIImage*)image;
@end


@interface CUImageCache : NSObject <CUDataLoaderDelegate> {
    id<CUImageCacheDelegate> delegate;
    NSString *imageFilename;
}

@property (nonatomic, assign) id <CUImageCacheDelegate> delegate;
+ (void)loadImageFromURL:(NSString*)url delegate:(id<CUImageCacheDelegate>)delegate;
- (void)addImageToCache:(NSString*)imageURLString;
- (UIImage*)getImageFromCache:(NSString*)imageName;

@end
