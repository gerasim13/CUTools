//
//  CUActionSheet.h
//  Loovie
//
//  Created by Павел Литвиненко on 21.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CUActionSheet : UIActionSheet {
	NSMutableArray *actions;
	NSMutableArray *objects;
}

@property (nonatomic, assign) NSMutableArray *actions;
@property (nonatomic, assign) NSMutableArray *objects;

- (NSInteger)addButtonWithTitle:(NSString*)title andAction:(SEL)action;
- (NSInteger)addButtonWithTitle:(NSString*)title action:(SEL)action andObject:(NSObject*)object;

@end
