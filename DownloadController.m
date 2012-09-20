//
//  CUProgressView.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "DownloadController.h"
#import "CUAlertView.h"

@implementation DownloadController
@synthesize delegate;
@synthesize currentTaskNumber;

- (void)setup {
	queue = [[NSMutableArray alloc] init];
    currentTaskNumber = -1;
}

- (id)init {
    if ((self=[super init])) {
		[self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	[self setup];
}

- (void)dealloc {
    [queue release], queue = nil;
    [super dealloc];
}

- (void)downloadFileFromURL:(NSString*)url {
	tasksNumber++;
	[queue addObject:url];
	if ([queue count]==1) {
        currentTaskNumber = 0;
		[self startDownloading];
		[delegate downloadControllerBecameActive:self];
	}
}

- (void)downloadFilesFromArrayWithURLs:(NSArray*)array {
    for (NSString *url in array) {
        [self downloadFileFromURL:url];
    }
}

- (void)startDownloading {
    [delegate downloadControllerBeganDownload:self];
    [delegate downloadController:self getProgress:0.0];
    
	NSString *url = [queue objectAtIndex:0];
    NSLog(@"%@", url);
	[CUDataLoader loadDataFromURL:url delegate:self];
}


#pragma mark CUDataLoader delegate
- (void)dataLoaded:(CUDataLoader*)dataLoader {
    NSLog(@"Returned data: %@", [dataLoader responseString]);
	//return response data
    [delegate downloadController:self getProgress:1.0];
	[delegate downloadController:self finishedLoading:[dataLoader responseData]];
	
	[queue removeObjectAtIndex:0];
	if ([queue count]>0) {
        currentTaskNumber++;
		[self startDownloading];
	} else {
		//hide progressbar
		tasksNumber       =  0;
        currentTaskNumber = -1;
		[delegate downloadControllerBecameInactive:self];
        [delegate downloadControllerCompletedLoadingQueue];
	}
}

- (void)dataFailedToLoad:(CUDataLoader*)dataLoader error:(NSError*)error {
    //clean queue
	[queue removeAllObjects];
	[delegate downloadControllerBecameInactive:self];
    tasksNumber       =  0;
    currentTaskNumber = -1;
    //show alert
    [CUAlertView showSimpleAlertWithTitle:@"Loopseque Store" message:@"Download failed. Please check your Internet connection." button:@"OK"];
}

- (void)dataLoadProgress:(CUDataLoader*)dataLoader progress:(float)progress {
	float p = (progress + (tasksNumber - [queue count])) / tasksNumber;
    [delegate downloadController:self getOverallProgress:p];
    [delegate downloadController:self getProgress:progress];
}


@end
