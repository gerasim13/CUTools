//
//  UIButton+CUDataLoader.h
//  Loopseque
//
//  Created by Paul Savich on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUDataLoader.h"

@interface UIButton (CUDataLoader) <CUDataLoaderDelegate>
- (void)setImageWithURL:(NSString*)imageURL;
@end
