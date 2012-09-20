//
//  UILabel+VerticalAlignment.h
//  MolodejjTV
//
//  Created by Pavel Litvinenko on 24.08.12.
//
//

#import <UIKit/UIKit.h>

// vertical alignment values
typedef enum UITextVerticalAlignment {
    UITextVerticalAlignmentTop,
    UITextVerticalAlignmentMiddle,
    UITextVerticalAlignmentBottom
} UITextVerticalAlignment;

@interface UILabel(VerticalAlignment)

// getter
-(UITextVerticalAlignment)textVerticalAlignment;

// setter
-(void)setTextVerticalAlignment:(UITextVerticalAlignment)textVerticalAlignment;

@end
