//
//  CUInfoCoverView.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "InfoCoverView.h"
#import "UIImageView+CUImageCache.h"

@implementation InfoCoverView
@synthesize delegate;
@synthesize infoWebView;
@synthesize artistNameLabel, artistDescriptionLabel;
@synthesize closeButton;

- (void)setup {
    [super setup];
    //hide info cover content
    [self setSubviewsAlpha:0.0];
    //set webview delegate
    [infoWebView setDelegate:self];
    //clear webview content
    [self clearWebView];
    //disable bounce in webview
    for (id subview in infoWebView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            ((UIScrollView*)subview).bounces = NO;
        }
    }
}

- (void)clearWebView {
    [infoWebView loadHTMLString:@"<html><body style='background:#1D1D1D;'></body></html>" baseURL:nil];
}

- (void)setImageWithURL:(NSString*)imageURL {
    [infoImageView setImageWithURL:imageURL];
}

- (IBAction)backButtonTouched {
    [delegate infoCoverViewBackButtonTouched];
    //clear webview content
    [self clearWebView];
}

- (IBAction)closeButtonTouched {
    [delegate infoCoverViewCloseButtonTouched];
    //clear webview content
    [self clearWebView];
}


#pragma mark WebView delegate
- (BOOL)webView:(UIWebView*)inWeb shouldStartLoadWithRequest:(NSURLRequest*)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

@end
