//
//  CURearCoverView.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 17.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "RearCoverView.h"

@implementation RearCoverView;
@synthesize delegate;
@synthesize infoView;
@synthesize buyButton, infoButton, closeButton, buyIndicator;
@synthesize releaseTitleLabel, artistNameLabel, releaseDateLabel;
@synthesize trackList;

- (void)setup {
    [super setup];
    //hide rear cover content
    [self setSubviewsAlpha:0.0];
}

- (void)setSubviewsAlpha:(float)alpha {
    [super setSubviewsAlpha:alpha];
    //set rear background alpha
    [rearBackground setAlpha:!(alpha>0)];
}

- (void)setCoverImage:(UIImage*)image {
    //set rear image view
    if (rearImageView!=nil) {
        [rearImageView setImage:image];
    }
}


#pragma mark RearCover animation
- (void)setupAnimationWithName:(NSString*)name enableAnimationDelegate:(BOOL)enableAnimationDelegate {
    [UIView beginAnimations:name context:nil];
    //run selector after animation if this is first animation
    if (enableAnimationDelegate) {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    }
}

- (void)runPageFlipAnimationWithName:(NSString*)name flipDown:(BOOL)flipDown enableAnimationDelegate:(BOOL)enableAnimationDelegate {
    if (![closeButton isEnabled]) {
        return;
    }

    [self setupAnimationWithName:name enableAnimationDelegate:enableAnimationDelegate];
    
    if (flipDown) {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.superview cache:NO];
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.superview cache:NO];
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.8];
    
    [self setAlpha:flipDown];
    [infoView setAlpha:!flipDown];
    [infoView setSubviewsAlpha:!flipDown];
    
    [UIView commitAnimations];
    
    //disable buttons
    [closeButton setEnabled:NO];
    [infoView.closeButton setEnabled:NO];
}

- (void)runFadeAnimationWithName:(NSString*)name alpha:(float)alpha enableAnimationDelegate:(BOOL)enableAnimationDelegate {
    [self setupAnimationWithName:name enableAnimationDelegate:enableAnimationDelegate];
    
    [UIView setAnimationDuration:0.3];
    if (enableAnimationDelegate) {
        [self setAlpha:alpha];
        [infoView setAlpha:!(alpha>0)];
    } else {
        [infoView setSubviewsAlpha:alpha];
    }
    [UIView commitAnimations];
}

- (void)showInfoView {
    [delegate rearCoverViewShowInfoView:self];
    [infoView setDelegate:self];
    [infoView setUserInteractionEnabled:YES];
    //run pageflip animation, show info view
    [self runPageFlipAnimationWithName:@"showInfoView" flipDown:NO enableAnimationDelegate:YES];
}

- (void)hideInfoView {
    //run pageflip animation, hide info view
    [self runPageFlipAnimationWithName:@"hideInfoView" flipDown:YES enableAnimationDelegate:YES];
}

- (void)animationFinished:(NSString*)animationID finished:(BOOL)finished context:(void*)context {
    BOOL hideInfo             = [animationID isEqualToString:@"hideInfoView"];
    BOOL hideInfoAndCloseRear = [animationID isEqualToString:@"hideInfoViewAndCloseRearView"];
    if (hideInfo || hideInfoAndCloseRear) {
        [infoView setDelegate:nil];
        [infoView setUserInteractionEnabled:NO];
        [delegate rearCoverViewHideInfoView:self];
        if (hideInfoAndCloseRear) {
            [self closeButtonTouched];
        }
    } else if ([animationID isEqualToString:@"showInfoView"]) {
        [self runFadeAnimationWithName:@"showInfoContent" alpha:1.0 enableAnimationDelegate:NO];
    }
    
    //enable buttons
    [closeButton setEnabled:YES];
    [infoView.closeButton setEnabled:YES];
}


#pragma mark RearCover actions
- (IBAction)buyButtonTouched {
    [delegate rearCoverViewBuyButtonTouched];
}

- (IBAction)infoButtonTouched {
    [delegate rearCoverViewInfoButtonTouched];
    [self showInfoView];
}

- (IBAction)closeButtonTouched {
    [delegate rearCoverViewCloseButtonTouched];
}


#pragma mark InfoCover actions
- (void)infoCoverViewBackButtonTouched {
    [self hideInfoView];
}

- (void)infoCoverViewCloseButtonTouched {
    [self runFadeAnimationWithName:@"hideInfoViewAndCloseRearView" alpha:1.0 enableAnimationDelegate:YES];
}

@end