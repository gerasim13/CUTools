//
//  CUAlertView.h
//  Loovie
//
//  Created by Павел Литвиненко on 20.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CUTextField.h"

@interface CUAlertView : UIAlertView <UIAlertViewDelegate> {
	id target_;
	SEL action_;
    SEL cancelAction_;
    BOOL withAcIndicator_;
	NSObject *object_;
}

// Class methods

+ (CUAlertView*)alertWithTarget:(id)target
                         action:(SEL)action
                   cancelAction:(SEL)cancelAction
              activityIndicator:(BOOL)withAcIndicator
                         object:(NSObject*)object
                          title:(NSString*)title
                        message:(NSString*)message
                   cancelButton:(NSString*)cancelButton
                andOtherButtons:(NSString*)otherButtonTitles, ...;

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
               cancelAction:(SEL)cancelAction
          activityIndicator:(BOOL)withAcIndicator
					 object:(NSObject*)object
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ...;

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
               cancelAction:(SEL)cancelAction
					 object:(NSObject*)object
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ...;

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
					 object:(NSObject*)object
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ...;

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ...;

+ (void)showSimpleAlertWithTitle:(NSString*)title
						 message:(NSString*)message
						  button:(NSString*)button;


// Initialization

- (id)initWithTitle:(NSString*)title
			message:(NSString*)message
			 button:(NSString*)button;

- (id)initWithTarget:(id)target
              action:(SEL)action
        cancelAction:(SEL)cancelAction
   activityIndicator:(BOOL)withAcIndicator
              object:(NSObject*)object
               title:(NSString*)title
             message:(NSString*)message
        cancelButton:(NSString*)cancelButton
     andOtherButtons:(NSString*)otherButtonTitles, ...;

- (id)initWithTarget:(id)target
              action:(SEL)action
        cancelAction:(SEL)cancelAction
              object:(NSObject*)object
               title:(NSString*)title
             message:(NSString*)message
        cancelButton:(NSString*)cancelButton
     andOtherButtons:(NSString*)otherButtonTitles, ...;

- (id)initWithTarget:(id)target
			  action:(SEL)action
			  object:(NSObject*)object
			   title:(NSString*)title
			 message:(NSString*)message
		cancelButton:(NSString*)cancelButton
	 andOtherButtons:(NSString*)otherButtonTitles, ...;

- (id)initWithTarget:(id)target
			  action:(SEL)action
			   title:(NSString*)title
			 message:(NSString*)message
		cancelButton:(NSString*)cancelTitle
	 andOtherButtons:(NSString*)otherButtonTitles, ...;

- (void)dismiss;

- (void)addTextField:(CUTextField*)textField;
- (void)addTextView:(CUTextView*)textView;

@end
