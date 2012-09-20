//
//  CUPickerView.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 13.06.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "CUPickerView.h"

@implementation CUPickerView
@synthesize components = _components;

- (id)init {
    if ((self = [super init])) {
        self.components = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    [_components release];
    [super dealloc];
}

- (void)addComponent:(CUPickerViewComponent*)component {
    NSMutableArray *components = [NSMutableArray arrayWithArray:_components];
    [components addObject:component];
    self.components = [NSArray arrayWithArray:components];
}

- (void)addComponentWithArray:(NSArray*)array {
    CUPickerViewComponent *component = [CUPickerViewComponent componentWithArray:array];
    [self addComponent:component];
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component {
    CUPickerViewComponent *pickerCpmponent = [_components objectAtIndex:component];
    return [pickerCpmponent numberOfRows];
}

- (UIView*)viewForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex {
    CUPickerViewComponent *component = [_components objectAtIndex:componentIndex];
    return [component viewForRowAtIndex:rowIndex];
}


#pragma mark Settings

- (NSInteger)numberOfComponents {
    return [_components count];
}

@end


@implementation CUPickerViewComponent
@synthesize rows = _rows;
@synthesize numberOfRows;

+ (CUPickerViewComponent*)componentWithArray:(NSArray*)array {
    return [[[CUPickerViewComponent alloc] initWithArray:array] autorelease];
}

- (CUPickerViewComponent*)initWithArray:(NSArray*)array {
    if ((self = [super init])) {
        self.rows = array;
    }
    return self;
}

- (void)dealloc {
    [_rows release];
    [super dealloc];
}

- (UILabel*)labelWithText:(NSString*)text {
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 22)] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:text];
    return label;
}

- (UIView*)viewForRowAtIndex:(NSInteger)index {
    NSObject *obj = [self.rows objectAtIndex:index];
    // Check
    if ([obj isKindOfClass:[UIView class]]) {
        // Return view
        return (UIView*)obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        // Create label
        return [self labelWithText:(NSString*)obj];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        // Create label
        NSString *string = [NSString stringWithFormat:@"%d", [(NSNumber*)obj intValue]];
        return [self labelWithText:string];
    }
    return nil;
}


#pragma mark Settings

- (NSInteger)numberOfRows {
    return [_rows count];
}

@end
