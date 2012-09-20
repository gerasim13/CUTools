//
//  CUDataLoader.m
//  Loopseque
//
//  Created by Paul Savich on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CUDataLoader.h"


@implementation CUDataLoader

#pragma mark Lifecycle

- (void)requestStarted {
	[self retain];
	[delegate retain];
}

- (void)requestComplete {
	if (!complete) {
		complete = YES;
		[delegate release];
		[self release];
	}
}

+ (CUDataLoader*)loadDataFromURL:(NSString*)url delegate:(id<CUDataLoaderDelegate>)delegate {
	return [[[CUDataLoader alloc] initWithURL:url delegate:delegate] autorelease];
}

- (id)initWithURL:(NSString*)_url delegate:(id<CUDataLoaderDelegate>)_delegate {
	self = [super init];
	if (self) {
		// Assign
		delegate = _delegate;
		responseData = [[NSMutableData alloc] init];

		// Start connection
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[connection start];

		// Keep alive objects
		[self requestStarted];		
	}
	return self;
}

- (void)dealloc {
	[responseData release];
	[connection release];
	[super dealloc];
}

- (void)cancel {
	[connection cancel];
	[self requestComplete];
}


#pragma mark Data access

- (NSData*)responseData {
	return responseData;
}

- (NSString*)responseString {
	return [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
}

- (UIImage*)responseImage {
	return [UIImage imageWithData:responseData];
}


#pragma mark Connection delegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response {
    statusCode = [response statusCode];
    if (statusCode == 200) {
        //get data size
        dataSize = [response expectedContentLength];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
	[responseData appendData:data];
    
    if ([delegate respondsToSelector:@selector(dataLoadProgress:progress:)]) {
        //calculate download progress
        float progress = (float)[responseData length] / (float)dataSize;
        [delegate dataLoadProgress:self progress:progress];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (statusCode != 200) {
        if ([delegate respondsToSelector:@selector(dataFailedToLoad:error:)]) {
            [delegate dataFailedToLoad:self error:nil];
        }
    }
	else if ([delegate respondsToSelector:@selector(dataLoaded:)]) {
		[delegate dataLoaded:self];
	}
	[self requestComplete];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([delegate respondsToSelector:@selector(dataFailedToLoad:error:)]) {
		[delegate dataFailedToLoad:self error:error];
	}
	[self requestComplete];
}

// HTTPS certificate validation workaround
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    NSLog(@"canAuthenticateAgainstProtectionSpace");
//    if([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        // Note: this is presently only called once per server (or URL?) until
//        //       you restart the app
//        NSLog(@"Authentication checking is doing");
//        return YES; // Self-signed cert will be accepted
//        // Note: it doesn't seem to matter what you return for a proper SSL cert
//        //       only self-signed certs
//    }
//    return NO;
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    NSLog(@"didReceiveAuthenticationChallenge");
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//        NSLog(@"chalenging protection space authentication checking");
//    }
//}

@end
