//
//  UIButton+SelectedHighlighted.m
//  Loovie
//
//  Created by Paul Savich on 28.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "UIButton+SelectedHighlighted.h"


@implementation UIButton (SelectedHighlighted)

- (void)updateSelectedHighlightedState {
	[self setTitle:[self titleForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
	[self setImage:[self imageForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
	[self setBackgroundImage:[self backgroundImageForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
	
}

@end
