//
//  CUTrackListView.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 29.11.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "TrackListCellView.h"

@implementation TrackListCellView
@synthesize delegate;
@synthesize progressBar;
@synthesize titleLabel, additionsLabel;
@synthesize playImageView, animationView, formatView;
@synthesize previewUrl;
@synthesize activityIndicator;
@synthesize isLoading = _isLoading;

- (void)dealloc {
    [previewUrl release];
    [super dealloc];
}

- (void)setTrackFormat:(NSString*)format {
    NSString *formatImageName;
    if ([format isEqualToString:@"LoopsequeProject"]) {
        formatImageName = @"growing.store.tracklist.format.lsq.png";
#ifdef TARGET_MINI
        formatImageName = @"iphone.store.tracklist.format.lsq.png";
#endif
    } else {
        formatImageName = @"growing.store.tracklist.format.mp3.png";
#ifdef TARGET_MINI
        formatImageName = @"iphone.store.tracklist.format.mp3.png";
#endif
    }
    UIImage *formatImage = [UIImage imageNamed:formatImageName];
    [formatView setImage:formatImage];
}

- (void)setDownloadProgress:(float)progress {
    //display current progress in percentage
    NSString *progressString = [NSString stringWithFormat:@"%d%%", (int)(progress*100)];
    [additionsLabel setText:progressString];
    //update progressbar
    [progressBar setProgress:progress];
}

- (void)setLoading:(BOOL)loaded {
    if (_isLoading==loaded) return;
    //update cell state
    _isLoading = loaded;
    
    CGSize additionsSize    = additionsLabel.frame.size;
    CGPoint additionsOrigin = additionsLabel.frame.origin;
    CGSize formatSize       = formatView.frame.size;
    CGPoint formatOrigin    = formatView.frame.origin;
    //calculate new position and set new colour
    CGFloat additionsX, formatX;
    UIColor *labelsColor;
    if (!_isLoading) {
        additionsX  = additionsOrigin.x - 46;
        formatX     = formatOrigin.x - 60;
#ifdef TARGET_MINI
        additionsX  = additionsOrigin.x - 36;
        formatX     = formatOrigin.x - 50;
#endif
        labelsColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        //restore additions label string
        [additionsLabel setText:additionsString];
        //hide progress view
        progressBar.hidden = YES;
        //show format ico
        [formatView setAlpha:1.0];
    } else {
        additionsX  = additionsOrigin.x + 46;
        formatX     = formatOrigin.x + 60;
#ifdef TARGET_MINI
        additionsX  = additionsOrigin.x + 36;
        formatX     = formatOrigin.x + 50;
#endif
        labelsColor = [UIColor whiteColor];
        //save additions label string
        additionsString = [additionsLabel text];
        //show progress view
        progressBar.hidden = NO;
        //hide format ico
        [formatView setAlpha:0.0];
    }
    //update labels position
    [additionsLabel setFrame:CGRectMake(additionsX, additionsOrigin.y, additionsSize.width, additionsSize.height)];
    [formatView     setFrame:CGRectMake(formatX, formatOrigin.y, formatSize.width, formatSize.height)];
    //update labels color
    [titleLabel     setTextColor:labelsColor];
    [additionsLabel setTextColor:labelsColor];
    //reser progress
    [progressBar setProgress:0.0];
}

- (void)transformView {
    [self setLoading:!_isLoading];
}

- (void)hideProgressView {
    [UIView beginAnimations:@"hideProgressView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self setLoading:NO];
    [UIView commitAnimations];
}

- (void)showProgressView {
    [UIView beginAnimations:@"showProgressView" context:nil];
    [UIView setAnimationDuration:0.6];
    [self setLoading:YES];
    [UIView commitAnimations];
}


@end