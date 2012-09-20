//
//  CUImageView.h
//  Loopseque
//
//  Created by Paul Savich on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CUImageView : UIView {
	UIImage *image;
	BOOL tile;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL tile;

@end
