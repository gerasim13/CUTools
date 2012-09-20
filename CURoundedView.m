//
//  CURoundedView.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 09.12.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CURoundedView.h"

@implementation CURoundedView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    //set rounded corners
    int cornerRadius = 30;
    int borderWidth  = 1;
#ifdef TARGET_MINI
    cornerRadius = 15;
    borderWidth  = 1;
#endif
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setBorderWidth:borderWidth];
    [self.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [self.layer setMasksToBounds:YES];
    
    //disable touch events
    [self setUserInteractionEnabled:NO];
    [self setNeedsDisplay];
}

- (void)setSubviewsAlpha:(float)alpha {
    for (UIView *subView in [self subviews]) {
        [subView setAlpha:alpha];
    }
}

@end
