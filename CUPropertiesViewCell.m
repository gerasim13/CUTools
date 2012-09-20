//
//  CUPropertiesViewCell.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 28.07.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "CUPropertiesViewCell.h"

@implementation CUPropertiesViewCell
@synthesize delegate;
@synthesize data = _data;
@synthesize type;
@synthesize targetSel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

#pragma mark Properties

- (void)setData:(NSDictionary*)data {
    _data = [data retain];
    
    NSString *label    = [_data valueForKey:@"Label"];
    NSString *selector = [_data valueForKey:@"Selector"];
    NSObject *value    = [_data objectForKey:@"Value"];
    
    self.textLabel.text = RETURN_EMPTY_STRING_IF_NIL(label);
    self.targetSel      = NSSelectorFromString(selector);
    
    if (value != nil) {
        if ([value isKindOfClass:[NSNumber class]]) {
            const char *valueType = [(NSNumber*)value objCType];
            if (IS_BOOL(valueType)) {
                // BOOL value
                self.type = CellPropertiesTypeSwitch;
                [self addSwitchWithValue:[(NSNumber*)value boolValue]];
            } else if (IS_ANY_OF_INT(valueType)) {
                // int value
                self.type = CellPropertiesTypeSlider;
                [self addSliderWithValue:[(NSNumber*)value intValue]];
            }
        } else {
            self.type = CellPropertiesTypeButton;
            [self addButtonWithValue:value];
        }
    } else {
        self.type = CellPropertiesTypeBlank;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}


#pragma mark Private methods

- (void)switchTouched:(UISwitch*)sender {
    if ([delegate respondsToSelector:targetSel]) {
        [delegate performSelector:targetSel withObject:_data];
    }
}

- (void)sliderTouched:(UISlider*)sender {
    if ([delegate respondsToSelector:targetSel]) {
        NSNumber *sliderValue = [NSNumber numberWithInt:[sender value]];
        [delegate performSelector:targetSel withObject:sliderValue];
    }
}

- (void)addButtonWithValue:(NSObject*)value {

}

- (void)addSwitchWithValue:(BOOL)value {
    UISwitch *cellSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
    [cellSwitch setOn:value];
    [cellSwitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    self.accessoryView = cellSwitch;
}

- (void)addSliderWithValue:(int)value {
    UISlider *cellSlider = [[[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 20)] autorelease];
    [cellSlider setMinimumValue:-999];
    [cellSlider setMaximumValue:999];
    [cellSlider setValue:(value > cellSlider.maximumValue || value < cellSlider.minimumValue) ? value / 1000000 : value];
    [cellSlider addTarget:self action:@selector(sliderTouched:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    self.accessoryView = cellSlider;
}

@end
