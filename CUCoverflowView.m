//
//  CUCoverflowView.m
//  Loopseque
//
//  Created by Павел Литвиненко on 29.06.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUCoverflowView.h"
#import "CUCoverView.h"

@interface CUCoverflowView(protected)
- (void)setupTransforms;
- (void)update;
- (void)reset;
- (void)newRange;
- (void)adjustViewHeirarchy;
- (void)deplaceAlbumsFrom:(int)start to:(int)end;
- (void)deplaceAlbumsAtIndex:(int)cnt;
- (BOOL)placeAlbumsFrom:(int)start to:(int)end;
- (void)placeAlbumAtIndex:(int)cnt;
- (void)animateToIndex:(int)index animated:(BOOL)animated;
- (void)snapToAlbum:(BOOL)animated;
@end

@implementation CUCoverflowView
@synthesize coverflowDelegate, dataSource;
@synthesize numberOfCovers   = _numberOfCovers;
@synthesize currentIndex     = _currentIndex;
@synthesize coverSpacing     = _coverSpacing;
@synthesize coverAngle       = _coverAngle;
@synthesize coverSize        = _coverSize;
@synthesize flippedCoverSize = _flippedCoverSize;

#pragma mark Setups
- (void)setup {
    //activate uiscrollview delegate
	[self setDelegate:self];
    //hide scroll indiator
	[self setShowsVerticalScrollIndicator:NO];
	[self setShowsHorizontalScrollIndicator:NO];
    //set deceleration tate
	[self setDecelerationRate:0.05];
    //init properties
	_numberOfCovers   = 0;
    _currentIndex     = -1;
	_coverAngle       = 1.4;
	_coverSize        = CGSizeMake(224, 224);
    _flippedCoverSize = CGSizeMake(320, 320);
    _coverSpacing     = roundf(_coverSize.width/3.1);
    //init vars
    yard              = [[NSMutableArray alloc] init];
	views             = [[NSMutableArray alloc] init];
	spaceFromCurrent  = _coverSize.width/2.4;
    currentSize       = self.frame.size;
    coverBuffer       = 0;
    margin            = currentSize.width/2;
	origin            = self.contentOffset.x;
    //init 3d transformations
	[self setupTransforms];
    //reset coverflow
	[self reset];
}

- (void)setupTransforms {
    //left transform
	leftTransform  = CATransform3DMakeRotation(_coverAngle, 0, 1, 0);
	leftTransform  = CATransform3DConcat(leftTransform, CATransform3DMakeTranslation(-spaceFromCurrent, 0, -300));
    //right transform
	rightTransform = CATransform3DMakeRotation(-_coverAngle, 0, 1, 0);
	rightTransform = CATransform3DConcat(rightTransform, CATransform3DMakeTranslation(spaceFromCurrent, 0, -300));
    //transform sublayer
	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.001;
	[self.layer setSublayerTransform:sublayerTransform];
}

- (void)reset {
    movingRight   = YES;
    _currentIndex = 0;
    //create new range
    [self newRange];
    //update view
    [self update];
}

- (void)newRange {
	int loc = deck.location, len = deck.length, buff = coverBuffer;
    //calculate location and length
	int newLoc = _currentIndex-buff < 0 ? 0 : _currentIndex-buff;
	int newLen = _currentIndex+buff > _numberOfCovers ? _numberOfCovers-newLoc : _currentIndex+buff-newLoc;
	//place overs in right direction
	if (loc==newLoc && newLen==len) {
		return;
	} else {
		if (movingRight) {
            //right side
			[self deplaceAlbumsFrom:loc to:MIN(newLoc,loc+len)];
			[self placeAlbumsFrom:MAX(loc+len,newLoc) to:newLoc+newLen];
		} else {
            //left side
			[self deplaceAlbumsFrom:MAX(newLen+newLoc,loc) to:loc+len];
			[self placeAlbumsFrom:newLoc to:newLoc+newLen];
		}
        //update range
		NSRange spectrum = NSMakeRange(0, _numberOfCovers);
		deck = NSIntersectionRange(spectrum, NSMakeRange(newLoc, newLen));
	}
}

- (void)newContentSizeAndCoverBuffer {
    //update content size
    self.contentSize = CGSizeMake(_coverSpacing * (_numberOfCovers-1) + (margin*2), currentSize.height);
    //calculate size of buffer
    coverBuffer = (int)((currentSize.width - _coverSize.width) / _coverSpacing) + 3;
    coverBuffer = coverBuffer > 0 ? coverBuffer : _numberOfCovers;
}

- (void)update {
    //remove all views
	for (UIView *v in views) [v removeFromSuperview];
	//clean arrays
	[yard removeAllObjects];
	[views removeAllObjects];
	//release coverviews array
	[coverViews release], coverViews = nil;
	//reset content offset
    self.contentOffset = CGPointZero;
	if(_numberOfCovers > 0){
        //create new coverviews array
		coverViews = [[NSMutableArray alloc] initWithCapacity:_numberOfCovers];
        //fill an array with empty data
		for (int i=0; i<_numberOfCovers; i++) [coverViews addObject:[NSNull null]];
        //create new range
		deck = NSMakeRange(0, 0);
        //update content size and cover buffer
        [self newContentSizeAndCoverBuffer];
        //reset content offset
		self.contentOffset = CGPointZero;
        //move to current cover
		[self animateToIndex:_currentIndex animated:NO];
	}
}

- (void)layoutSubviews {
    //wierd bug walkaround
    if (self.frame.size.width==currentSize.width && self.frame.size.height==currentSize.height) {
		return;
	} else {
        //update current size var
        currentSize = self.frame.size;
        //update content size and cover buffer
        [self newContentSizeAndCoverBuffer];
        //apply transformation on covers from stage
        for (UIView *cover in views) {
            cover.layer.transform = CATransform3DIdentity;
            //update cover frame
            CGRect rect   = cover.frame;
            rect.origin.y = (currentSize.height/2 - (_coverSize.height/2)) - _coverSize.height/16;
            cover.frame   = rect;
        }
        //set position of covers from backstage
        for (unsigned int i=deck.location; i<deck.location+deck.length; i++) {
            if ([coverViews objectAtIndex:i] != [NSNull null]) {
                UIView *cover = [coverViews objectAtIndex:i];
                //update cover frame
                CGRect rect   = cover.frame;
                rect.origin.x = (currentSize.width/2 - (_coverSize.width/2)) + _coverSpacing*i;
                cover.frame   = rect;
            }
        }
        //create new range
        [self newRange];
        //move to current cover
        [self animateToIndex:_currentIndex animated:NO];
    }
}


#pragma mark Views heirarchy
- (void)adjustViewHeirarchy {
    //send covers to back
	if (_currentIndex-1 >= 0) {
		for (unsigned int i=_currentIndex; i>deck.location; i--) {
			[self sendSubviewToBack:[coverViews objectAtIndex:i]];
		}
	}
	if (_currentIndex+1 >= _numberOfCovers-1) {
		for (unsigned int i=_currentIndex; i<deck.location+deck.length; i++) {
			[self sendSubviewToBack:[coverViews objectAtIndex:i]];
		}
	}
	//bring current cover to front
	if ([coverViews objectAtIndex:_currentIndex] != [NSNull null]) {
		UIView *view = [coverViews objectAtIndex:_currentIndex];
		[self bringSubviewToFront:view];
	}	
}

- (void)placeAlbumAtIndex:(int)index {
	if ((NSUInteger)index<[coverViews count] && [coverViews objectAtIndex:index]==[NSNull null]) {
        //create new cover from datasource
        CUCoverView *cover = [dataSource coverflowView:self coverAtIndex:index];
        //insert new cover in coverviews array
        [coverViews replaceObjectAtIndex:index withObject:cover];
        //update cover frame
        CGRect rect = cover.frame;
        //calculate new position
        rect.origin.y = roundf(currentSize.height/2 - (_coverSize.height/2) - (_coverSize.height/16));
        rect.origin.x = (currentSize.width/2 - (_coverSize.width/2)) + (_coverSpacing)*index;
        //set new frame
        cover.frame = rect;
        //add new cover to superview
        [self addSubview:cover];
        //send cover to back if needed
        if (index>_currentIndex) [self sendSubviewToBack:cover];
        //add cover to views array
        [views addObject:cover];
	}
}

- (BOOL)placeAlbumsFrom:(int)start to:(int)end {
	if (start < end) {
        //place some covers to stage
        for(int cnt=start; cnt<=end; cnt++) {
            [self placeAlbumAtIndex:cnt];
        }
        return YES;
	}
	return NO;
}

- (void)deplaceAlbumsAtIndex:(int)cnt {
	if ((NSUInteger)cnt<[coverViews count] && [coverViews objectAtIndex:cnt]!=[NSNull null]) {
        //remove cover from superview and arrays
        UIView *view = [coverViews objectAtIndex:cnt];
        [view removeFromSuperview];
        [views removeObject:view];
        [yard addObject:view];
        //replace cover with empty object
        [coverViews replaceObjectAtIndex:cnt withObject:[NSNull null]];
	}
}

- (void)deplaceAlbumsFrom:(int)start to:(int)end {
	if (start < end) {
        //deplace some covers to stage
		for(int cnt=start; cnt<end; cnt++) {
			[self deplaceAlbumsAtIndex:cnt];
		}
	}	
}


#pragma mark Lifecycle
- (void)dealloc {
    currentTouch = nil;
    //release arrays
	[yard       release], yard = nil;
	[views      release], views = nil;
	[coverViews release], coverViews = nil;
	//release delegate and datasource
	[coverflowDelegate release], coverflowDelegate = nil;
	[dataSource        release], dataSource = nil;
	//release everything else
    [super dealloc];
}


#pragma mark Properties
- (void)setNumberOfCovers:(NSInteger)numberOfCovers {
    _numberOfCovers = numberOfCovers;
    [self reset];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    [self setCurrentIndex:_currentIndex animated:NO];
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
    if (_currentIndex!=currentIndex) {
        //update current index
		_currentIndex = currentIndex;
        //snap to nearest cover
		[self snapToAlbum:animated];
        //create new range
		[self newRange];
        //move to cover
		[self animateToIndex:_currentIndex animated:animated];
	}
}

- (void)setCoverSpacing:(CGFloat)coverSpacing {
    _coverSpacing = coverSpacing;
    [self reset];
	[self layoutSubviews];
}

- (void)setCoverAngle:(CGFloat)coverAngle {
    _coverAngle = coverAngle;
    [self setupTransforms];
	[self reset];
}

- (void)setCoverSize:(CGSize)coverSize {
    _coverSize       = coverSize;
    _coverSpacing    = roundf(_coverSize.width/3.1);
    spaceFromCurrent = _coverSize.width/2.4;
    [self setupTransforms];
	[self reset];
}

- (void)setFlippedCoverSize:(CGSize)flippedCoverSize {
    _flippedCoverSize = flippedCoverSize;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self layoutSubviews];
}


#pragma mark Animation
- (void)animationFinished:(NSString*)animationID finished:(BOOL)finished context:(void*)context {
    if (finished) {
        //update views heirarchy
        [self adjustViewHeirarchy];
        //call delegate method
        if ([animationID intValue]==_currentIndex) {
            [coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:_currentIndex];
        }
    }
}

- (void)animateToIndex:(int)index animated:(BOOL)animated {
	if (velocity>200) animated = NO;
	//prepare animation
	if (animated) {
        NSString *animationName = [NSString stringWithFormat:@"%d",_currentIndex];
		float animationSpeed    = velocity<100 ? 0.3 : 0.6;
		//begin animation
		[UIView beginAnimations:animationName context:nil];
		[UIView setAnimationDuration:animationSpeed];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)]; 
	}
	
	int visibleCount = 5;
    int coversCount  = [coverViews count] - 1;
	int mini = animated ? MAX(0,           index - visibleCount) : 0;
	int maxi = animated ? MIN(coversCount, index + visibleCount) : coversCount;
	
	for (int i = mini; i <= maxi; i++) {
        if ([coverViews objectAtIndex:i]!=[NSNull null]) {
            CUCoverView *view = [coverViews objectAtIndex:i];
            CALayer *layer = view.layer;
            //update cover transform and opacity
            if (i==index) {
                layer.transform = CATransform3DIdentity;
                layer.opacity   = 1.0;
            } else {
                layer.transform = (i<index ? leftTransform : rightTransform);
                layer.opacity   = MAX(0.0, 1.0 - fabs(index-i)/visibleCount);
            }
            //hide cover if opacity below 0.3
            [view setHidden:!(layer.opacity>=0.3)];
        }
	}
	//commit animation or call delegate method
	if (animated) {
		[UIView commitAnimations];
	} else {
		[coverflowDelegate coverflowView:self coverAtIndexWasBroughtToFront:_currentIndex];
	}
}

- (void)snapToAlbum:(BOOL)animated {
    CGPoint offsetPoint;
    //calculate offset point
    if ([coverViews objectAtIndex:_currentIndex]!=[NSNull null]) {
        CUCoverView *view = [coverViews objectAtIndex:_currentIndex];
        offsetPoint = CGPointMake(view.center.x - (currentSize.width/2), 0);
    } else {
        offsetPoint = CGPointMake(_coverSpacing * _currentIndex, 0);
    }
    //update content offset
	[self setContentOffset:offsetPoint animated:animated];
}


#pragma mark Covers
- (id)coverAtIndex:(int)index {
    //return cover at index
	if ([coverViews objectAtIndex:index]!=[NSNull null]) {
		return [coverViews objectAtIndex:index];
	}
	return nil;
}

- (id)coverWithIdentifier:(NSString*)identifier {
    //return over with identifier
    for (CUCoverView *cover in coverViews) {
        if (cover!=(CUCoverView*)[NSNull null] && [cover.identifier isEqualToString:identifier]) {
            return cover;
        }
    }
    return nil;
}

- (id)dequeueReusableCoverView {
    //return last object from yard
	if ([yard count] >= 1) {
		CUCoverView *cover = [[[yard lastObject] retain] autorelease];
		cover.layer.transform = CATransform3DIdentity;
		[yard removeLastObject];
		return cover;
	}
	return nil;
}


#pragma mark Touch events
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    if ([self isScrollEnabled]) {
        //create empty set
        NSSet *coverObjects;
        //sort object, add covers to set
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            //test for iOS4
            coverObjects = [touches objectsPassingTest:^(id obj, BOOL *stop){
                return [[obj view] isKindOfClass:[CUCoverView class]];
            }];
        } else {
            //test for iOS3
            NSMutableArray *tempArray = [NSMutableArray array];
            for (UITouch *touch in touches) {
                if ([[touch view] isKindOfClass:[CUCoverView class]]) {
                    [tempArray addObject:touch];
                }
            }
            coverObjects = [NSSet setWithArray:tempArray];
        }
        //select touch
        UITouch *touch = [coverObjects anyObject];
        //set current touch
        if (touch.view!=self && [touch locationInView:touch.view].y<_coverSize.height) {
            currentTouch = touch.view;
        }
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	if (touch.view==currentTouch) {
		if (touch.tapCount>1 && (NSUInteger)_currentIndex==[coverViews indexOfObject:currentTouch]) {
            //call delegate method
			if ([coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasDoubleTapped:)]) {
				[coverflowDelegate coverflowView:self coverAtIndexWasDoubleTapped:_currentIndex];
			}
		} else if ((NSUInteger)_currentIndex==[coverViews indexOfObject:currentTouch]) {
            //call delegate method
            if ([coverflowDelegate respondsToSelector:@selector(coverflowView:coverAtIndexWasTapped:)]) {
				[coverflowDelegate coverflowView:self coverAtIndexWasTapped:_currentIndex];
			}
        } else {
			int index = [coverViews indexOfObject:currentTouch];
            //update content offset
			[self setContentOffset:CGPointMake(_coverSpacing*index, 0) animated:YES];
		}
	}
	//delete current touch
	currentTouch = nil;
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	if (currentTouch!=nil) currentTouch = nil;
}


#pragma mark Scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    //setup vars
    velocity    = abs(pos-scrollView.contentOffset.x) / 19.4;
	pos         = scrollView.contentOffset.x;
    origin      = self.contentOffset.x;
	movingRight = self.contentOffset.x-origin > 0;
    //space per cover
	CGFloat per = pos / (self.contentSize.width-currentSize.width);
    //overall space
	CGFloat ind = _numberOfCovers * per;
    //middle
	CGFloat mi = ind / (_numberOfCovers/2);
    mi = (1-mi)/2;
    //get new current index
	NSInteger index = (NSInteger)(ind+mi);
    index = MIN(MAX(0,index), _numberOfCovers-1);
	
	if(index!=_currentIndex) {
		_currentIndex = index;
        //create new range
		[self newRange];
		//move to cover
		if (velocity<180 || _currentIndex<15 || _currentIndex>(_numberOfCovers-16)) {
			[self animateToIndex:_currentIndex animated:YES];
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
	if (!scrollView.tracking&&!scrollView.decelerating) {
		[self snapToAlbum:YES];
		[self adjustViewHeirarchy];
	} 
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
	if (!self.decelerating&&!decelerate) {
		[self snapToAlbum:YES];
		[self adjustViewHeirarchy];
	}
}


@end