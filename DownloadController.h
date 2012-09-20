//
//  CUProgressView.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUDataLoader.h"

@class DownloadController;

@protocol DownloadControllerDelegate <NSObject>
- (void)downloadControllerBecameActive:(DownloadController*)controller;
- (void)downloadControllerBecameInactive:(DownloadController*)controller;
- (void)downloadControllerBeganDownload:(DownloadController*)controller;
- (void)downloadController:(DownloadController*)controller getProgress:(float)progress;
- (void)downloadController:(DownloadController*)controller getOverallProgress:(float)progress;
- (void)downloadController:(DownloadController*)controller finishedLoading:(NSData*)data;
- (void)downloadControllerCompletedLoadingQueue;
@end

@interface DownloadController : NSObject <CUDataLoaderDelegate> {
    id<DownloadControllerDelegate> delegate;
    NSMutableArray *queue;
	NSInteger      tasksNumber, currentTaskNumber;
}

@property (nonatomic, assign) id <DownloadControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentTaskNumber;

- (void)downloadFileFromURL:(NSString*)url;
- (void)downloadFilesFromArrayWithURLs:(NSArray*)array;
- (void)startDownloading;
@end
