//
//  CURearCoverView.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURoundedView.h"
#import "InfoCoverView.h"
#import "TrackListCellView.h"

@class RearCoverView;

@protocol RearCoverViewDelegate <NSObject>
@optional
- (void)rearCoverViewShowInfoView:(RearCoverView*)rearCoverView;
- (void)rearCoverViewHideInfoView:(RearCoverView*)rearCoverView;
- (void)rearCoverViewBuyButtonTouched;
- (void)rearCoverViewInfoButtonTouched;
- (void)rearCoverViewCloseButtonTouched;
@end

@interface RearCoverView : CURoundedView <InfoCoverViewDelegate> {
    id <RearCoverViewDelegate> delegate;
    InfoCoverView *infoView;
    UIButton *buyButton, *infoButton;
    UIActivityIndicatorView *buyIndicator;
    UILabel *releaseTitleLabel, *artistNameLabel, *releaseDateLabel;
    IBOutlet UIView *rearImageContainer;
    IBOutlet UIImageView *rearImageView, *rearBackground;
    UIButton *closeButton;
    UITableView *trackList;
}

@property (nonatomic, assign) id <RearCoverViewDelegate> delegate;
@property (nonatomic, assign) InfoCoverView *infoView;
@property (nonatomic, assign) IBOutlet UIButton *buyButton;
@property (nonatomic, assign) IBOutlet UIButton *infoButton;
@property (nonatomic, assign) IBOutlet UIButton *closeButton;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *buyIndicator;
@property (nonatomic, assign) IBOutlet UILabel *releaseTitleLabel;
@property (nonatomic, assign) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, assign) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic, assign) IBOutlet UITableView *trackList;

- (void)setCoverImage:(UIImage*)image;
- (void)showInfoView;
- (void)hideInfoView;
- (IBAction)buyButtonTouched;
- (IBAction)infoButtonTouched;
- (IBAction)closeButtonTouched;

@end
