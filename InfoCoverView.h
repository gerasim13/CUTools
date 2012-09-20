//
//  CUInfoCoverView.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CURoundedView.h"

@class InfoCoverView;

@protocol InfoCoverViewDelegate <NSObject>
@optional
- (void)infoCoverViewBackButtonTouched;
- (void)infoCoverViewCloseButtonTouched;
@end

@interface InfoCoverView : CURoundedView <UIWebViewDelegate> {
    id <InfoCoverViewDelegate> delegate;
    UILabel *artistNameLabel, *artistDescriptionLabel;
    IBOutlet UIView *infoImageContainer;
    IBOutlet UIImageView *infoImageView;
    IBOutlet UIButton *backButton;
    UIButton *closeButton;
    UIWebView *infoWebView;
}

@property (nonatomic, assign) id <InfoCoverViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet UIWebView *infoWebView;
@property (nonatomic, assign) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, assign) IBOutlet UILabel *artistDescriptionLabel;
@property (nonatomic, assign) IBOutlet UIButton *closeButton;

- (void)clearWebView;
- (void)setImageWithURL:(NSString*)imageURL;
- (IBAction)backButtonTouched;
- (IBAction)closeButtonTouched;

@end
