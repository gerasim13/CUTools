//
//  CUPickerView.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 13.06.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUPickerView, CUPickerViewComponent;

@interface CUPickerView : UIPickerView {
}

@property (nonatomic, retain) NSArray *components;

- (void)addComponent:(CUPickerViewComponent*)component;
- (void)addComponentWithArray:(NSArray*)array;
- (UIView*)viewForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex;

@end


@interface CUPickerViewComponent : NSObject {
    NSArray *rows;
}

@property (nonatomic, retain)   NSArray   *rows;
@property (nonatomic, readonly) NSInteger numberOfRows;

+ (CUPickerViewComponent*)componentWithArray:(NSArray*)array;
- (CUPickerViewComponent*)initWithArray:(NSArray*)array;
- (UIView*)viewForRowAtIndex:(NSInteger)index;

@end
