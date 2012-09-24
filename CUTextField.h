//
//  CUTextField.h
//  Loovie
//
//  Created by Павел Литвиненко on 21.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CUTextField : UITextField {
}

@property (nonatomic, retain) NSString *name;
- (id)initWithFrame:(CGRect)frame name:(NSString*)fieldName andLabel:(NSString*)labelText;
- (id)initWithFrame:(CGRect)frame andName:(NSString*)fieldName;
@end


@interface CUTextView : UITextView {
}

@property (nonatomic, assign) NSString *name;
- (id)initWithFrame:(CGRect)frame andName:(NSString*)fieldName;
@end