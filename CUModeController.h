//
//  CUModeController.h
//  Loovie
//
//  Created by Paul Savich on 11.07.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CUModeControllerDelegate <NSObject>
@optional
- (void)willEnterMode:(NSString*)newMode animated:(BOOL)animated;
- (void)didLeaveMode:(NSString*)oldMode animated:(BOOL)animated;
- (void)failedToSwitchFromMode:(NSString*)oldMode toMode:(NSString*)wantedMode;
- (BOOL)canSwitchFromMode:(NSString*)oldMode toMode:(NSString*)newMode;
@end

@interface CUModeController : NSObject {
	id<CUModeControllerDelegate> delegate;
	NSString *currentMode;
	NSMutableArray *previousModes;
	BOOL animated;
	NSTimeInterval animationDuration;
	BOOL useDelegateForModeChanges;
}

@property (nonatomic, assign) id<CUModeControllerDelegate> delegate;
@property (nonatomic, assign) NSString *currentMode;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) BOOL useDelegateForModeChanges;

- (void)setCurrentMode:(NSString*)mode;
- (BOOL)setCurrentMode:(NSString*)mode animated:(BOOL)_animated;

- (void)pushMode:(NSString*)mode;
- (void)pushMode:(NSString*)mode animated:(BOOL)_animated;
- (void)popMode;
- (void)pushMode:(NSString*)mode orMode:(NSString*)mode2;
- (void)pushOrPopMode:(NSString*)mode;
//- (void)switchMode:(NSString*)mode;

@end
