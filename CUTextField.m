//
//  CUTextField.m
//  Loovie
//
//  Created by Павел Литвиненко on 21.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUTextField.h"

#pragma mark CUTextField
@implementation CUTextField
@synthesize name;

- (id)initWithFrame:(CGRect)frame name:(NSString*)fieldName andLabel:(NSString*)labelText {
    if (self = [super initWithFrame:frame]) {
        // Setup
        [self setName:fieldName];
        self.borderStyle  = UITextBorderStyleRoundedRect;
        // Add label
        if (labelText != nil) {
            self.leftViewMode     = UITextFieldViewModeAlways;
            CGRect  labelViewRect = CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height);
            UILabel *labelView    = [[UILabel alloc] initWithFrame:labelViewRect];
            [labelView setBackgroundColor:[UIColor clearColor]];
            [labelView setFont:[self font]];
            [labelView setText:labelText];
            [self setLeftView:labelView];
            [labelView release];
        }
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame andName:(NSString*)fieldName {
    return [self initWithFrame:frame name:fieldName andLabel:nil];
}

- (void)dealloc {
    [name release];
    [super dealloc];
}

@end


#pragma mark CUTextView
@implementation CUTextView
@synthesize name;

- (id)initWithFrame:(CGRect)frame andName:(NSString*)fieldName {
	if (self = [super initWithFrame:frame]) {
		[self setName:fieldName];
		self.layer.cornerRadius = 4.0;
		self.layer.borderWidth  = 1.0;
		self.layer.borderColor  = [[UIColor grayColor] CGColor];
	}
	return self;
}

@end