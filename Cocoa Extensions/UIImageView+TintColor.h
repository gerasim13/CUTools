//
//  UIImageView+TintColor.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 11.06.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (TintColor)

@property (nonatomic, retain) UIImage *originalImage;

- (void)setTintColor:(UIColor*)tintColor;

@end
