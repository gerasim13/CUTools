//
//  CUTrackListView.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 29.11.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressView.h"

@class TrackListCellView;

@protocol TrackListCellViewDelegate <NSObject>
@optional
- (void)trackListCell:(TrackListCellView*)cell setHighlighted:(BOOL)highlighted;
@end

@interface TrackListCellView : UITableViewCell {
    id <TrackListCellViewDelegate> delegate;
    ProgressView *progressBar;
    UIImageView *playImageView, *animationView, *formatView;
    UILabel  *titleLabel, *additionsLabel;
    NSString *previewUrl, *additionsString;
    UIActivityIndicatorView *activityIndicator;
    BOOL _isLoading;
}
@property (nonatomic, assign) id <TrackListCellViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet ProgressView *progressBar;
@property (nonatomic, assign) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) IBOutlet UILabel *additionsLabel;
@property (nonatomic, assign) IBOutlet UIImageView *playImageView;
@property (nonatomic, assign) IBOutlet UIImageView *animationView;
@property (nonatomic, assign) IBOutlet UIImageView *formatView;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *previewUrl;

- (void)setTrackFormat:(NSString*)format;
- (void)setDownloadProgress:(float)progress;
- (void)setLoading:(BOOL)loaded;
- (void)transformView;
- (void)showProgressView;
- (void)hideProgressView;

@end
