//
//  IBParametersAdapter.h
//  Loovie
//
//  Created by Paul Savich on 11.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IBParametersAdapter : UIView {
	NSMutableDictionary *parameterViews;
}

- (IBParametersAdapter*)parametersForKey:(NSString*)key;
- (NSString*)stringForKey:(NSString*)key;
- (CGFloat)floatForKey:(NSString*)key;
- (BOOL)boolForKey:(NSString*)name;
- (NSInteger)integerForKey:(NSString*)name;
- (CGFloat)floatForKey:(NSString*)name;

@end
