//
//  IBParameterButton.h
//  Loovie
//
//  Created by Paul Savich on 11.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IBParameterButton : UIButton {
	NSString *key;
	NSString *value;
}

//- (void)sendActionOnDefaultEvent;

- (NSString*)key;
- (NSString*)stringValue;
- (CGFloat)floatValue;
- (BOOL)boolValue;
- (NSInteger)integerValue;
- (CGFloat)floatValue;

@end
