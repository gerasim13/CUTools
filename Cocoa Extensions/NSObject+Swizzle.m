//
//  NSObject+AWHSwizzle.m
//  MolodejjTV
//
//  Created by Павел Литвиненко on 01.04.13.
//
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (Swizzle)

void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

+ (void)swizzleMethod:(SEL)orig_sel withMethod:(SEL)alt_sel {
    NSString *originalMethodName = NSStringFromSelector(orig_sel);
    NSString *alternateMethodName = NSStringFromSelector(alt_sel);
    NSLog(@"Attempting to swizzle in class '%@': swapping method '%@' with '%@'...",[self class], originalMethodName, alternateMethodName);
	
	Swizzle([self class], orig_sel, alt_sel);
}

@end
