//
//  UIImageView+ImageLoader.h
//  Loopseque
//
//  Created by Павел Литвиненко on 12.04.11.
//  Copyright 2011 CULab. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CUDataLoader.h"

@interface UIImageView (CUDataLoader) <CUDataLoaderDelegate>
- (void)setImageWithURL:(NSString*)imageURL;
@end
