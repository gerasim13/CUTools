//
//  CUCoverflowView.h
//  Loopseque
//
//  Created by Павел Литвиненко on 29.06.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class CUCoverflowView;

@protocol CUCoverflowViewDelegate <NSObject>
@required
- (void)coverflowView:(CUCoverflowView*)coverflowView coverAtIndexWasBroughtToFront:(int)index;
@optional
- (void)coverflowView:(CUCoverflowView*)coverflowView coverAtIndexWasDoubleTapped:(int)index;
- (void)coverflowView:(CUCoverflowView*)coverflowView coverAtIndexWasTapped:(int)index;
@end

@protocol CUCoverflowViewDataSource <NSObject>
@required
- (id)coverflowView:(CUCoverflowView*)coverflowView coverAtIndex:(int)index;
@end

@interface CUCoverflowView : UIScrollView <UIScrollViewDelegate> {
    id <CUCoverflowViewDelegate>   coverflowDelegate;
	id <CUCoverflowViewDataSource> dataSource;
    
    long  velocity;
	BOOL  movingRight;
    NSInteger   pos, margin, coverBuffer;
	CGFloat     origin, spaceFromCurrent;
    CGSize      currentSize;
    
    NSInteger     _numberOfCovers, _currentIndex;
    CGFloat       _coverSpacing, _coverAngle;
    CGSize        _coverSize, _flippedCoverSize;
    CATransform3D leftTransform, rightTransform;
    NSRange       deck;
    
    NSMutableArray *coverViews, *views, *yard;
    UIView         *currentTouch;
}

@property (nonatomic, retain) id <CUCoverflowViewDelegate> coverflowDelegate;
@property (nonatomic, retain) id <CUCoverflowViewDataSource> dataSource;
@property (nonatomic, assign) NSInteger numberOfCovers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat   coverSpacing;
@property (nonatomic, assign) CGFloat   coverAngle;
@property (nonatomic, assign) CGSize    coverSize;
@property (nonatomic, assign) CGSize    flippedCoverSize;

- (void)setup;
- (id)dequeueReusableCoverView;
- (id)coverAtIndex:(int)index;
- (id)coverWithIdentifier:(NSString*)identifier;
- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;

@end
