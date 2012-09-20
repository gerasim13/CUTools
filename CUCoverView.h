//
//  CUCoverView.h
//  Loopseque
//
//  Created by Павел Литвиненко on 30.06.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CUCoverView : UIView {
    NSString *identifier;
    UIImageView *imageView;
	UIImageView *reflected;
}

@property (nonatomic, assign) NSString *identifier;
@property (nonatomic, assign) IBOutlet UIImageView *imageView;

- (id)initWithNib:(NSString*)nib frame:(CGRect)frame;
- (UIImage*)image;
- (void)setImage:(UIImage*)img;
- (void)setImageWithURL:(NSString*)imageURL;
- (void)addReflectionAndBorders;

@end
