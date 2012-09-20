//
//  CUPropertiesViewCell.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 28.07.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_BOOL(a) strcmp(@encode(BOOL), a) == 0
#define IS_INT(a) strcmp(@encode(int), a) == 0
#define IS_LONG(a) strcmp(@encode(long), a) == 0
#define IS_LONG_LONG(a) strcmp(@encode(long long), a) == 0
#define IS_UNSIGNED_LONG(a) strcmp(@encode(unsigned long), a) == 0
#define IS_UNSIGNED_LONG_LONG(a) strcmp(@encode(unsigned long long), a) == 0
#define IS_ANY_OF_INT(a) (IS_INT(a) || IS_LONG(a) || IS_LONG_LONG(a) || IS_UNSIGNED_LONG(a) || IS_UNSIGNED_LONG_LONG(a))

#define RETURN_EMPTY_STRING_IF_NIL(a) ((NSObject*)a == [NSNull null]) ? [NSString string] : a

typedef enum {
    CellPropertiesTypeBlank,
    CellPropertiesTypeButton,
    CellPropertiesTypeSwitch,
    CellPropertiesTypeSlider
} CellPropertiesType;

@protocol CUPropertiesViewCellDelegate;

@interface CUPropertiesViewCell : UITableViewCell {
    id<CUPropertiesViewCellDelegate> delegate;
    NSDictionary *_data;
    CellPropertiesType type;
    SEL targetSel;
}

@property (nonatomic, assign) id<CUPropertiesViewCellDelegate> delegate;
@property (nonatomic, assign) NSDictionary *data;
@property (nonatomic, assign) CellPropertiesType type;
@property (nonatomic, assign) SEL targetSel;

- (void)addButtonWithValue:(NSObject*)value;
- (void)addSwitchWithValue:(BOOL)value;
- (void)addSliderWithValue:(int)value;

@end


@protocol CUPropertiesViewCellDelegate <NSObject>
@end
