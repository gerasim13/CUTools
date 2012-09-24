//
//  CUDataLoader.h
//  Loopseque
//
//  Created by Paul Savich on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CUDataLoader;


@protocol CUDataLoaderDelegate <NSObject>
@optional
- (void)dataLoaded:(CUDataLoader*)dataLoader;
- (void)dataFailedToLoad:(CUDataLoader*)dataLoader error:(NSError*)error;
- (void)dataLoadProgress:(CUDataLoader*)dataLoader progress:(float)progress;
@end


@interface CUDataLoader : NSObject {
	id<CUDataLoaderDelegate> delegate;
	NSURLConnection          *connection;
	NSMutableData            *responseData;
    float                    dataSize;
	BOOL                     complete;
    NSInteger                statusCode;
}

+ (CUDataLoader*)loadDataFromURL:(NSString*)url delegate:(id<CUDataLoaderDelegate>)delegate;
- (id)initWithURL:(NSString*)url delegate:(id<CUDataLoaderDelegate>)delegate;
- (void)cancel;

- (NSData*)responseData;
- (NSString*)responseString;
- (UIImage*)responseImage;

@end
