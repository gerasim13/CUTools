//
//  CUAlertView.m
//  Loovie
//
//  Created by Павел Литвиненко on 20.08.11.
//  Copyright 2011 Casual Underground. All rights reserved.
//

#import "CUAlertView.h"

@interface CUAlertView(private)
- (CGSize)getMessageSize;
- (CGFloat)getBottomOfView:(UIView*)view;
- (void)moveView:(UIView*)view1 underAhotherView:(UIView*)view2;
- (void)moveViewToCenter:(UIView*)view;
- (void)resizeToFitView:(UIView*)view;
@end


@implementation CUAlertView


#pragma mark Init

- (id)initWithTarget:(id)target
              action:(SEL)action
        cancelAction:(SEL)cancelAction
   activityIndicator:(BOOL)withAcIndicator
              object:(NSObject*)object
               title:(NSString*)title
             message:(NSString*)message
        cancelButton:(NSString*)cancelButton
     andOtherButtons:(NSString*)otherButtonTitles, ... {
    if (self=[super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButton otherButtonTitles:otherButtonTitles, nil]) {
		target_          = target;
		action_          = action;
        cancelAction_    = cancelAction;
        withAcIndicator_ = withAcIndicator;
		object_          = object!=nil ? [object retain] : [NSNull null];
	}
	return self;
}

- (id)initWithTarget:(id)target
              action:(SEL)action
        cancelAction:(SEL)cancelAction
              object:(NSObject*)object
               title:(NSString*)title
             message:(NSString*)message
        cancelButton:(NSString*)cancelButton
     andOtherButtons:(NSString*)otherButtonTitles, ... {
    return [self initWithTarget:target action:action cancelAction:cancelAction activityIndicator:NO object:object title:title message:message cancelButton:cancelButton andOtherButtons:otherButtonTitles];
}

- (id)initWithTarget:(id)target
			  action:(SEL)action
			  object:(NSObject*)object
			   title:(NSString*)title
			 message:(NSString*)message
		cancelButton:(NSString*)cancelButton
	 andOtherButtons:(NSString*)otherButtonTitles, ... {
	return [self initWithTarget:target action:action cancelAction:nil object:object title:title message:message cancelButton:cancelButton andOtherButtons:otherButtonTitles];
}

- (id)initWithTarget:(id)target
			  action:(SEL)action
			   title:(NSString*)title
			 message:(NSString*)message
		cancelButton:(NSString*)cancelButton
	 andOtherButtons:(NSString*)otherButtonTitles, ... {
	return [self initWithTarget:target action:action cancelAction:nil object:nil title:title message:message cancelButton:cancelButton andOtherButtons:otherButtonTitles];
}

- (id)initWithTitle:(NSString*)title
			message:(NSString*)message
			 button:(NSString*)button {
	if (self=[super initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles:nil]) {
	}
	return self;
}


#pragma mark Class methods

+ (CUAlertView*)alertWithTarget:(id)target
                         action:(SEL)action
                   cancelAction:(SEL)cancelAction
              activityIndicator:(BOOL)withAcIndicator
                         object:(NSObject*)object
                          title:(NSString*)title
                        message:(NSString*)message
                   cancelButton:(NSString*)cancelButton
                andOtherButtons:(NSString*)otherButtonTitles, ... {
    return [[CUAlertView alloc] initWithTarget:target
                                        action:action
                                  cancelAction:cancelAction
                             activityIndicator:withAcIndicator
                                        object:object
                                         title:title
                                       message:message
                                  cancelButton:cancelButton
                               andOtherButtons:otherButtonTitles];
}

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
               cancelAction:(SEL)cancelAction
          activityIndicator:(BOOL)withAcIndicator
					 object:(NSObject*)object
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ... {
    CUAlertView *alert = [CUAlertView alertWithTarget:target
                                               action:action
                                         cancelAction:cancelAction
                                    activityIndicator:withAcIndicator
                                               object:object
                                                title:title
                                              message:message
                                         cancelButton:cancelButton
                                      andOtherButtons:otherButtonTitles];
	[alert show];
	[alert release];
}

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
               cancelAction:(SEL)cancelAction
					 object:(NSObject*)object
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ... {
    [CUAlertView showAlertWithTarget:target
                              action:action
                        cancelAction:cancelAction
                   activityIndicator:NO
                              object:object
                               title:title
                             message:message
                        cancelButton:cancelButton
                     andOtherButtons:otherButtonTitles];
}

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
					 object:(NSObject*)object
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ... {
    [CUAlertView showAlertWithTarget:target
                              action:action
                        cancelAction:nil
                   activityIndicator:NO
                              object:object
                               title:title
                             message:message
                        cancelButton:cancelButton
                     andOtherButtons:otherButtonTitles];
}

+ (void)showAlertWithTarget:(id)target
					 action:(SEL)action
					  title:(NSString*)title
					message:(NSString*)message
			   cancelButton:(NSString*)cancelButton
			andOtherButtons:(NSString*)otherButtonTitles, ... {
    [CUAlertView showAlertWithTarget:target
                              action:action
                        cancelAction:nil
                   activityIndicator:NO
                              object:nil
                               title:title
                             message:message
                        cancelButton:cancelButton
                     andOtherButtons:otherButtonTitles];
}

+ (void)showSimpleAlertWithTitle:(NSString*)title
						 message:(NSString*)message
						  button:(NSString*)button {
	CUAlertView *alert = [[CUAlertView alloc] initWithTitle:title
													message:message
													 button:button];
	[alert show];
	[alert release];
}


#pragma mark Present&Dismiss

- (void)show {
    [super show];
    
    if (withAcIndicator_) {
        UIActivityIndicatorView* acIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        [acIndicator startAnimating];
        [self addSubview:acIndicator];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	int i = withAcIndicator_? 1 : 2;
	for (UIView *view in [self subviews]) {
		if ([view respondsToSelector:@selector(name)]) {
			[self moveViewToCenter:view];
            //move textfield under message or another textfield
			[self moveView:view underAhotherView:[self.subviews objectAtIndex:i]];
			
			//move buttons under textfield
			[self moveView:[self.subviews objectAtIndex:3] underAhotherView:view];
			[self moveView:[self.subviews objectAtIndex:4] underAhotherView:view];
			
			i = [self.subviews indexOfObject:view];
		} else if ([view isMemberOfClass:[UIActivityIndicatorView class]]) {
            [self moveViewToCenter:view];
            
            //move activity indicator under title
			[self moveView:view underAhotherView:[self.subviews objectAtIndex:i]];
			//move message buttons under indicator
			[self moveView:[self.subviews objectAtIndex:2] underAhotherView:view];
            //move cancel button under message
			[self moveView:[self.subviews objectAtIndex:3] underAhotherView:[self.subviews objectAtIndex:2]];
        }
    }
    //resize alert view
	[self resizeToFitView:[self.subviews objectAtIndex:3]];
}

- (void)alertView:(UIAlertView*)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //remove the spinner
    if (withAcIndicator_) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    
	if (buttonIndex!=[alertView cancelButtonIndex]&&[target_ respondsToSelector:action_]) {
		NSMutableDictionary *values = [[NSMutableDictionary dictionary] retain];
		for (CUTextField *textField in [alertView subviews]) {
			if ([textField respondsToSelector:@selector(name)] && textField.name!=nil) {
                NSString *fieldText = textField.text;
                NSString *fieldName = textField.name;
                
                if ([fieldText isEqualToString:@""] || fieldText == nil) {
                    [values setValue:[NSNull null] forKey:fieldName];
                } else {
                    [values setValue:fieldText forKey:fieldName];
                }
			}
		}
		//check count of values
		if ([values count]>0) {
			if (object_!=[NSNull null]&&object_!=nil) {
				[values setObject:object_ forKey:@"AdditionalObject"];
				[object_ release], object_=nil;
			}
			[target_ performSelector:action_ withObject:values];
		} else {
			[target_ performSelector:action_ withObject:object_];
			[object_ release], object_=nil;
		}
        [values release];
	} else if ([target_ respondsToSelector:cancelAction_]) {
        [target_ performSelector:cancelAction_];
    }
}

- (void)dismiss {
    cancelAction_ = nil;
    [self dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:YES];
}

#pragma mark Adding text fields

- (void)addTextField:(CUTextField*)textField {
	[self addSubview:textField];
//	CGSize newSize  = [self getMessageSize];
//	CGRect newFrame = CGRectMake(0, 0, newSize.width, textField.frame.size.height);
//	[textField setFrame:newFrame];
}

- (void)addTextView:(CUTextView*)textView {
	[self addSubview:textView];
}

- (CGSize)getMessageSize {
	CGSize maximumSize = CGSizeMake(800.0, 400.0);
	for (UILabel *label in self.subviews) {
		if ([label isKindOfClass:[UILabel class]] && label.text==self.message) {
			CGSize messageSize = [label.text sizeWithFont:label.font
										constrainedToSize:maximumSize
											lineBreakMode:label.lineBreakMode];
			return messageSize;
		}
	}
	return maximumSize;
}

- (CGFloat)getBottomOfView:(UIView*)view {
	return view.frame.size.height + view.frame.origin.y;
}

- (void)moveViewToCenter:(UIView*)view {
	[view setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
}

- (void)moveView:(UIView*)view1 underAhotherView:(UIView*)view2  {
	CGRect view1Frame = view1.frame;
	view1Frame.origin.y = [self getBottomOfView:view2] + 5;
	view1.frame = view1Frame;
}

- (void)resizeToFitView:(UIView*)view {
	CGRect selfFrame   = self.frame;
	CGPoint selfOrigin = selfFrame.origin;
	CGSize selfSize    = selfFrame.size;
	CGFloat newHeight  = [self getBottomOfView:view] + 15;
	
	[self setFrame:CGRectMake(selfOrigin.x, selfOrigin.y, selfSize.width, newHeight)];
}

@end
